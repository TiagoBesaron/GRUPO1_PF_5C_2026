#define ENABLE_USER_AUTH
#define ENABLE_DATABASE

#include <WiFi.h>
#include <FirebaseClient.h>

#include <esp_now.h>
#include <esp_wifi.h>

#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

#include <Adafruit_NeoPixel.h>

// =====================================================
// WIFI
// =====================================================
#define WIFI_SSID "TU_WIFI"
#define WIFI_PASSWORD "TU_PASSWORD"

// =====================================================
// FIREBASE
// =====================================================
#define API_KEY "TU_API_KEY"
#define USER_EMAIL "TU_EMAIL_FIREBASE"
#define USER_PASSWORD "TU_PASSWORD_FIREBASE"
#define DATABASE_URL "TU_DATABASE_URL"

SSL_CLIENT ssl_client;
using AsyncClient = AsyncClientClass;
AsyncClient aClient(ssl_client);

UserAuth user_auth(API_KEY, USER_EMAIL, USER_PASSWORD, 3000);
FirebaseApp app;
RealtimeDatabase Database;
AsyncResult databaseResult;

// =====================================================
// NEOPIXEL CENTRAL
// =====================================================
#define PIN 21
#define NUMPIXELS 24

Adafruit_NeoPixel tira(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

// =====================================================
// RADAR CENTRAL
// =====================================================
#define SENSOR_PIN 4

bool movimientoAnterior = LOW;
unsigned long ultimoMovimiento = 0;
const unsigned long tiempoAntirrebote = 500;

// =====================================================
// COLORES
// =====================================================
int colorActual = 0;
bool tiraEncendida = true;
unsigned long tiempoAnteriorColor = 0;
const unsigned long intervaloColor = 1000;

// =====================================================
// MAC DE LOS PERIFERICOS
// =====================================================
uint8_t periferico1[] = {0xE0, 0x72, 0xA1, 0x72, 0xD8, 0xBC};
uint8_t periferico2[] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00}; // REEMPLAZAR CON MAC REAL
uint8_t periferico3[] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
uint8_t periferico4[] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
uint8_t periferico5[] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

uint8_t *perifericos[] = {
  periferico1,
  periferico2,
  periferico3,
  periferico4,
  periferico5
};

const int CANTIDAD_MAXIMA_PERIFERICOS = 5;

// =====================================================
// ENTRENAMIENTO & ESTADOS NO BLOQUEANTES
// =====================================================
bool entrenamientoActivo = false;
bool esperandoReaccion = false;
bool pausaEntreRondas = false;

int cantidadRondas = 1;
int rondaActual = 0;
int perifericoActual = -1;
int perifericoAnterior = -1;

unsigned long inicioRonda = 0;
unsigned long tiempoUltimaReaccion = 0;
unsigned long tiempoFinReaccion = 0;
const unsigned long TIEMPO_PAUSA_RONDA = 500; // ms de espera entre rondas

// =====================================================
// USUARIO
// =====================================================
String usuarioUID = "";
bool usuarioConectado = false;

// =====================================================
// BLE
// =====================================================
#define SERVICE_UUID           "12345678-1234-1234-1234-123456789000"
#define CHARACTERISTIC_UUID_RX "12345678-1234-1234-1234-123456789001"
#define CHARACTERISTIC_UUID_TX "12345678-1234-1234-1234-123456789002"

BLECharacteristic *caracteristicaRX;
BLECharacteristic *caracteristicaTX;
bool dispositivoBLEConectado = false;

// Declaration Forward
void comenzarRonda();
void finalizarEntrenamiento();
void procesarReaccion(unsigned long tiempo);

// =====================================================
// LED CENTRAL
// =====================================================
void apagarLeds() {
  for (int i = 0; i < NUMPIXELS; i++) {
    tira.setPixelColor(i, 0, 0, 0);
  }
  tira.show();
}

void encenderColor(int r, int g, int b) {
  for (int i = 0; i < NUMPIXELS; i++) {
    tira.setPixelColor(i, tira.Color(r, g, b));
  }
  tira.show();
}

void cambiarColor() {
  if (colorActual == 0)      encenderColor(255, 0, 0);
  else if (colorActual == 1) encenderColor(0, 255, 0);
  else                       encenderColor(0, 0, 255);

  colorActual = (colorActual + 1) % 3;
}

// =====================================================
// VERIFICAR & AGREGAR MAC
// =====================================================
bool macValida(uint8_t *mac) {
  for (int i = 0; i < 6; i++) {
    if (mac[i] != 0) return true;
  }
  return false;
}

void agregarPeriferico(uint8_t *mac) {
  if (!macValida(mac)) return;
  if (esp_now_is_peer_exist(mac)) return;

  esp_now_peer_info_t peerInfo = {};
  memcpy(peerInfo.peer_addr, mac, 6);
  peerInfo.channel = 0; // Usar canal actual de WiFi
  peerInfo.encrypt = false;

  esp_err_t resultado = esp_now_add_peer(&peerInfo);
  if (resultado == ESP_OK) {
    Serial.println("Periferico agregado a ESP-NOW");
  } else {
    Serial.print("Error agregando periferico: ");
    Serial.println(resultado);
  }
}

// =====================================================
// ENVIAR ESP-NOW
// =====================================================
void enviarPeriferico(int numero, const char *mensaje) {
  if (numero < 0 || numero >= CANTIDAD_MAXIMA_PERIFERICOS) return;

  uint8_t *mac = perifericos[numero];
  if (!macValida(mac)) {
    Serial.print("El periferico ");
    Serial.print(numero + 1);
    Serial.println(" no tiene MAC configurada");
    return;
  }

  esp_err_t resultado = esp_now_send(mac, (uint8_t *)mensaje, strlen(mensaje) + 1);

  Serial.print("Enviando a periferico ");
  Serial.print(numero + 1);
  Serial.print(": ");
  Serial.println(mensaje);

  if (resultado != ESP_OK) {
    Serial.print("Error ESP-NOW: ");
    Serial.println(resultado);
  }
}

void enviarTodos(const char *mensaje) {
  for (int i = 0; i < CANTIDAD_MAXIMA_PERIFERICOS; i++) {
    if (macValida(perifericos[i])) {
      enviarPeriferico(i, mensaje);
    }
  }
}

// =====================================================
// IDENTIFICAR PERIFERICO POR MAC
// =====================================================
int identificarPeriferico(const uint8_t *mac) {
  for (int i = 0; i < CANTIDAD_MAXIMA_PERIFERICOS; i++) {
    if (!macValida(perifericos[i])) continue;

    bool iguales = true;
    for (int j = 0; j < 6; j++) {
      if (mac[j] != perifericos[i][j]) {
        iguales = false;
        break;
      }
    }
    if (iguales) return i;
  }
  return -1;
}

// =====================================================
// RECIBIR ESP-NOW
// =====================================================
void recibirESPNow(const esp_now_recv_info_t *info, const uint8_t *data, int len) {
  char mensaje[100];
  if (len >= sizeof(mensaje)) len = sizeof(mensaje) - 1;

  memcpy(mensaje, data, len);
  mensaje[len] = '\0';

  String texto = String(mensaje);
  Serial.print("ESP-NOW recibido: ");
  Serial.println(texto);

  if (texto.startsWith("REACCION:")) {
    // Parseo limpio del tiempo antes del separador '|'
    int posPipe = texto.indexOf('|');
    String tiempoStr = (posPipe != -1) ? texto.substring(9, posPipe) : texto.substring(9);
    unsigned long tiempo = tiempoStr.toInt();

    // Validar que el mensaje provenga del periférico activo en la ronda
    int idOrigen = identificarPeriferico(info->src_addr);
    if (idOrigen == perifericoActual || perifericoActual == -1) {
      procesarReaccion(tiempo);
    } else {
      Serial.println("Reaccion ignorada: no corresponde al periferico de la ronda activa");
    }
  }
}

// =====================================================
// FIREBASE
// =====================================================
void procesarFirebase(AsyncResult &resultado) {
  if (!resultado.isResult()) return;

  if (resultado.isError()) {
    Firebase.printf("Firebase error: %s\n", resultado.error().message().c_str());
  }

  if (resultado.available()) {
    Firebase.printf("Firebase respuesta: %s\n", resultado.c_str());
  }
}

void guardarTiempo(unsigned long tiempo, int unidad) {
  if (!usuarioConectado || !app.ready()) {
    Serial.println("Firebase no listo o sin usuario");
    return;
  }

  String ruta = "/UsersData/" + usuarioUID + "/tiempos/" + String(millis());

  object_t json;
  JsonWriter writer;

  object_t objTiempo, objUnidad, objRonda;

  writer.create(objTiempo, "tiempo", number_t(tiempo / 1000.0, 3));
  writer.create(objUnidad, "unidad", unidad + 1);
  writer.create(objRonda, "ronda", rondaActual);

  writer.join(json, 3, objTiempo, objUnidad, objRonda);

  Database.set<object_t>(aClient, ruta, json, procesarFirebase, "guardarTiempo");
  Serial.println("Tiempo guardado en Firebase");
}

void guardarResultadoEntrenamiento() {
  if (!usuarioConectado || !app.ready()) return;

  String ruta = "/UsersData/" + usuarioUID + "/entrenamientos/" + String(millis());

  object_t json;
  JsonWriter writer;

  object_t objRondas, objUltimo, objTotal;

  writer.create(objRondas, "rondas", cantidadRondas);
  writer.create(objUltimo, "ultimoTiempo", number_t(tiempoUltimaReaccion / 1000.0, 3));
  writer.create(objTotal, "finalizado", true);

  writer.join(json, 3, objRondas, objUltimo, objTotal);

  Database.set<object_t>(aClient, ruta, json, procesarFirebase, "guardarEntrenamiento");
}

// =====================================================
// ELEGIR PERIFERICO ALEATORIO POR HARDWARE
// =====================================================
int elegirPeriferico() {
  int disponibles[5];
  int cantidad = 0;

  for (int i = 0; i < CANTIDAD_MAXIMA_PERIFERICOS; i++) {
    if (macValida(perifericos[i])) {
      if (i != perifericoAnterior || CANTIDAD_MAXIMA_PERIFERICOS == 1) {
        disponibles[cantidad] = i;
        cantidad++;
      }
    }
  }

  if (cantidad == 0) return -1;

  // Generador aleatorio verdaderamente aleatorio del ESP32
  int posicion = esp_random() % cantidad;
  return disponibles[posicion];
}

// =====================================================
// GESTIÓN DE ENTRENAMIENTO
// =====================================================
void comenzarRonda() {
  if (!entrenamientoActivo) return;

  if (rondaActual >= cantidadRondas) {
    finalizarEntrenamiento();
    return;
  }

  perifericoActual = elegirPeriferico();

  if (perifericoActual == -1) {
    Serial.println("No hay perifericos configurados con MAC");
    finalizarEntrenamiento();
    return;
  }

  perifericoAnterior = perifericoActual;
  rondaActual++;
  esperandoReaccion = true;
  inicioRonda = millis();

  Serial.print("Ronda ");
  Serial.print(rondaActual);
  Serial.print(" - Periferico ");
  Serial.println(perifericoActual + 1);

  enviarPeriferico(perifericoActual, "EMPEZAR");
  encenderColor(0, 0, 255); // Central en Azul durante la ronda

  if (dispositivoBLEConectado) {
    String mensaje = "RONDA:" + String(rondaActual) + ":" + String(perifericoActual + 1);
    caracteristicaTX->setValue(mensaje.c_str());
    caracteristicaTX->notify();
  }
}

void procesarReaccion(unsigned long tiempo) {
  if (!entrenamientoActivo || !esperandoReaccion) return;

  esperandoReaccion = false;
  tiempoUltimaReaccion = tiempo;

  Serial.print("Reaccion recibida: ");
  Serial.print(tiempo);
  Serial.println(" ms");

  enviarPeriferico(perifericoActual, "REACCION");
  apagarLeds();

  guardarTiempo(tiempo, perifericoActual);

  if (dispositivoBLEConectado) {
    String mensaje = "TIEMPO:" + String(tiempo / 1000.0, 3);
    caracteristicaTX->setValue(mensaje.c_str());
    caracteristicaTX->notify();
  }

  // Activar temporizador no bloqueante para la siguiente ronda
  pausaEntreRondas = true;
  tiempoFinReaccion = millis();
}

void finalizarEntrenamiento() {
  entrenamientoActivo = false;
  esperandoReaccion = false;
  pausaEntreRondas = false;

  enviarTodos("APAGAR");
  apagarLeds();

  guardarResultadoEntrenamiento();

  Serial.println("ENTRENAMIENTO FINALIZADO");

  if (dispositivoBLEConectado) {
    caracteristicaTX->setValue("ENTRENAMIENTO_FINALIZADO");
    caracteristicaTX->notify();
  }
}

void iniciarEntrenamiento() {
  if (!usuarioConectado) {
    Serial.println("No se puede entrenar sin usuario autenticado");
    if (dispositivoBLEConectado) {
      caracteristicaTX->setValue("ERROR:USUARIO");
      caracteristicaTX->notify();
    }
    return;
  }

  if (entrenamientoActivo) return;

  entrenamientoActivo = true;
  esperandoReaccion = false;
  pausaEntreRondas = false;
  rondaActual = 0;
  perifericoAnterior = -1;

  Serial.println("ENTRENAMIENTO INICIADO");
  comenzarRonda();
}

void detenerEntrenamiento() {
  entrenamientoActivo = false;
  esperandoReaccion = false;
  pausaEntreRondas = false;

  enviarTodos("DETENER");
  apagarLeds();

  if (dispositivoBLEConectado) {
    caracteristicaTX->setValue("ENTRENAMIENTO_DETENIDO");
    caracteristicaTX->notify();
  }
}

// =====================================================
// BLE SERVER & CALLBACKS
// =====================================================
class ServidorCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer *server) override {
    dispositivoBLEConectado = true;
    Serial.println("APP CONECTADA POR BLE");
  }

  void onDisconnect(BLEServer *server) override {
    dispositivoBLEConectado = false;
    Serial.println("APP DESCONECTADA DE BLE");
    server->getAdvertising()->start();
  }
};

class RXCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *characteristic) override {
    String mensaje = characteristic->getValue();
    mensaje.trim();

    Serial.print("Comando BLE: ");
    Serial.println(mensaje);

    if (mensaje.startsWith("UID:")) {
      usuarioUID = mensaje.substring(4);
      usuarioUID.trim();
      usuarioConectado = usuarioUID.length() > 0;

      if (dispositivoBLEConectado) {
        String respuesta = "USUARIO_OK:" + usuarioUID;
        caracteristicaTX->setValue(respuesta.c_str());
        caracteristicaTX->notify();
      }
    } 
    else if (mensaje == "ENTRENAR") {
      iniciarEntrenamiento();
    } 
    else if (mensaje.startsWith("RONDAS:")) {
      cantidadRondas = mensaje.substring(7).toInt();
      if (cantidadRondas < 1) cantidadRondas = 1;
      if (cantidadRondas > 100) cantidadRondas = 100;

      Serial.print("Rondas configuradas: ");
      Serial.println(cantidadRondas);
    } 
    else if (mensaje == "DETENER") {
      detenerEntrenamiento();
    } 
    else if (mensaje == "ENCENDER") {
      enviarTodos("ENCENDER");
    } 
    else if (mensaje == "APAGAR") {
      enviarTodos("APAGAR");
    }
  }
};

void configurarBLE() {
  BLEDevice::init("LED Trainer Central");

  BLEServer *servidor = BLEDevice::createServer();
  servidor->setCallbacks(new ServidorCallbacks());

  BLEService *servicio = servidor->createService(SERVICE_UUID);

  caracteristicaRX = servicio->createCharacteristic(
    CHARACTERISTIC_UUID_RX,
    BLECharacteristic::PROPERTY_WRITE
  );

  caracteristicaTX = servicio->createCharacteristic(
    CHARACTERISTIC_UUID_TX,
    BLECharacteristic::PROPERTY_NOTIFY
  );

  caracteristicaTX->addDescriptor(new BLE2902());
  caracteristicaRX->setCallbacks(new RXCallbacks());

  servicio->start();

  BLEAdvertising *advertising = BLEDevice::getAdvertising();
  advertising->addServiceUUID(SERVICE_UUID);
  advertising->setScanResponse(true);
  advertising->start();

  Serial.println("BLE iniciado correctamente");
}

// =====================================================
// CONFIGURAR ESP-NOW
// =====================================================
void configurarESPNow() {
  if (esp_now_init() != ESP_OK) {
    Serial.println("ERROR INICIANDO ESP-NOW");
    return;
  }

  esp_now_register_recv_cb(recibirESPNow);

  for (int i = 0; i < CANTIDAD_MAXIMA_PERIFERICOS; i++) {
    agregarPeriferico(perifericos[i]);
  }
}

// =====================================================
// RADAR CENTRAL & MODO REPOSO
// =====================================================
void comprobarRadarCentral() {
  bool movimiento = digitalRead(SENSOR_PIN);
  unsigned long ahora = millis();

  if (movimiento == HIGH && movimientoAnterior == LOW) {
    if (ahora - ultimoMovimiento > tiempoAntirrebote) {
      ultimoMovimiento = ahora;

      if (!entrenamientoActivo) {
        tiraEncendida = !tiraEncendida;
        if (tiraEncendida) cambiarColor();
        else apagarLeds();
      }
    }
  }
  movimientoAnterior = movimiento;
}

void actualizarColores() {
  if (!tiraEncendida || entrenamientoActivo) return;

  unsigned long ahora = millis();
  if (ahora - tiempoAnteriorColor >= intervaloColor) {
    tiempoAnteriorColor = ahora;
    cambiarColor();
  }
}

// =====================================================
// SETUP
// =====================================================
void setup() {
  Serial.begin(115200);

  tira.begin();
  tira.setBrightness(200);
  encenderColor(255, 0, 0);

  pinMode(SENSOR_PIN, INPUT);

  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  Serial.print("Conectando WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(300);
    Serial.print(".");
  }
  Serial.println("\nWiFi Conectado!");

  // Sincronizar canal de ESP-NOW con el canal asignado por el Router
  int canalWiFi = WiFi.channel();
  esp_wifi_set_channel(canalWiFi, WIFI_SECOND_CHAN_NONE);
  Serial.print("Canal WiFi asignado: ");
  Serial.println(canalWiFi);

  Serial.print("MAC CENTRAL: ");
  Serial.println(WiFi.macAddress());

  set_ssl_client_insecure_and_buffer(ssl_client);

  initializeApp(aClient, app, getAuth(user_auth), procesarFirebase, "authTask");
  app.getApp<RealtimeDatabase>(Database);
  Database.url(DATABASE_URL);

  configurarESPNow();
  configurarBLE();

  Serial.println("CENTRAL LISTO PARA OPERAR");
}

// =====================================================
// LOOP PRINCIPAL (TOTALMENTE NO BLOQUEANTE)
// =====================================================
void loop() {
  app.loop();
  procesarFirebase(databaseResult);

  // Gestión de pausa no bloqueante entre rondas
  if (pausaEntreRondas && (millis() - tiempoFinReaccion >= TIEMPO_PAUSA_RONDA)) {
    pausaEntreRondas = false;
    if (entrenamientoActivo) {
      comenzarRonda();
    }
  }

  comprobarRadarCentral();
  actualizarColores();
}