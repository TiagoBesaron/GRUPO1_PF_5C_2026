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

UserAuth user_auth(
  API_KEY,
  USER_EMAIL,
  USER_PASSWORD,
  3000
);

FirebaseApp app;

RealtimeDatabase Database;

AsyncResult databaseResult;


// =====================================================
// NEOPIXEL CENTRAL
// =====================================================

#define PIN 21
#define NUMPIXELS 24

Adafruit_NeoPixel tira(
  NUMPIXELS,
  PIN,
  NEO_GRB + NEO_KHZ800
);


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

// PERIFERICO 1
uint8_t periferico1[] = {
  0xE0,
  0x72,
  0xA1,
  0x72,
  0xD8,
  0xBC
};


// PERIFERICO 2
// REEMPLAZAR CON LA MAC REAL

uint8_t periferico2[] = {
  0x00,
  0x00,
  0x00,
  0x00,
  0x00,
  0x00
};


// PERIFERICO 3

uint8_t periferico3[] = {
  0x00,
  0x00,
  0x00,
  0x00,
  0x00,
  0x00
};


// PERIFERICO 4

uint8_t periferico4[] = {
  0x00,
  0x00,
  0x00,
  0x00,
  0x00,
  0x00
};


// PERIFERICO 5

uint8_t periferico5[] = {
  0x00,
  0x00,
  0x00,
  0x00,
  0x00,
  0x00
};


uint8_t *perifericos[] = {
  periferico1,
  periferico2,
  periferico3,
  periferico4,
  periferico5
};


const int CANTIDAD_MAXIMA_PERIFERICOS = 5;


// =====================================================
// ENTRENAMIENTO
// =====================================================

bool entrenamientoActivo = false;

bool esperandoReaccion = false;

int cantidadRondas = 1;

int rondaActual = 0;

int perifericoActual = -1;

int perifericoAnterior = -1;

unsigned long inicioRonda = 0;

unsigned long tiempoUltimaReaccion = 0;


// =====================================================
// USUARIO
// =====================================================

String usuarioUID = "";

bool usuarioConectado = false;


// =====================================================
// BLE
// =====================================================

#define SERVICE_UUID \
"12345678-1234-1234-1234-123456789000"

#define CHARACTERISTIC_UUID_RX \
"12345678-1234-1234-1234-123456789001"

#define CHARACTERISTIC_UUID_TX \
"12345678-1234-1234-1234-123456789002"


BLECharacteristic *caracteristicaRX;

BLECharacteristic *caracteristicaTX;

bool dispositivoBLEConectado = false;


// =====================================================
// LED
// =====================================================

void apagarLeds() {

  for (int i = 0; i < NUMPIXELS; i++) {

    tira.setPixelColor(
      i,
      0,
      0,
      0
    );
  }

  tira.show();
}


void encenderColor(
  int r,
  int g,
  int b
) {

  for (int i = 0; i < NUMPIXELS; i++) {

    tira.setPixelColor(
      i,
      tira.Color(r, g, b)
    );
  }

  tira.show();
}


void cambiarColor() {

  if (colorActual == 0) {

    encenderColor(
      255,
      0,
      0
    );
  }

  else if (colorActual == 1) {

    encenderColor(
      0,
      255,
      0
    );
  }

  else {

    encenderColor(
      0,
      0,
      255
    );
  }

  colorActual++;

  if (colorActual > 2) {

    colorActual = 0;
  }
}


// =====================================================
// VERIFICAR MAC
// =====================================================

bool macValida(
  uint8_t *mac
) {

  for (int i = 0; i < 6; i++) {

    if (mac[i] != 0) {

      return true;
    }
  }

  return false;
}


// =====================================================
// AGREGAR PERIFERICO
// =====================================================

void agregarPeriferico(
  uint8_t *mac
) {

  if (!macValida(mac)) {

    return;
  }


  if (
    esp_now_is_peer_exist(mac)
  ) {

    return;
  }


  esp_now_peer_info_t peerInfo = {};

  memcpy(
    peerInfo.peer_addr,
    mac,
    6
  );

  peerInfo.channel = 0;

  peerInfo.encrypt = false;


  esp_err_t resultado =
    esp_now_add_peer(
      &peerInfo
    );


  if (
    resultado == ESP_OK
  ) {

    Serial.println(
      "Periferico agregado"
    );
  }

  else {

    Serial.print(
      "Error agregando periferico: "
    );

    Serial.println(
      resultado
    );
  }
}


// =====================================================
// ENVIAR ESP-NOW
// =====================================================

void enviarPeriferico(
  int numero,
  const char *mensaje
) {

  if (
    numero < 0 ||
    numero >= CANTIDAD_MAXIMA_PERIFERICOS
  ) {

    return;
  }


  uint8_t *mac =
    perifericos[numero];


  if (!macValida(mac)) {

    Serial.print(
      "El periferico "
    );

    Serial.print(
      numero + 1
    );

    Serial.println(
      " no tiene MAC configurada"
    );

    return;
  }


  esp_err_t resultado =
    esp_now_send(
      mac,
      (uint8_t *)mensaje,
      strlen(mensaje) + 1
    );


  Serial.print(
    "Enviando a periferico "
  );

  Serial.print(
    numero + 1
  );

  Serial.print(
    ": "
  );

  Serial.println(
    mensaje
  );


  if (
    resultado != ESP_OK
  ) {

    Serial.print(
      "Error ESP-NOW: "
    );

    Serial.println(
      resultado
    );
  }
}


// =====================================================
// ENVIAR A TODOS
// =====================================================

void enviarTodos(
  const char *mensaje
) {

  for (
    int i = 0;
    i < CANTIDAD_MAXIMA_PERIFERICOS;
    i++
  ) {

    if (
      macValida(perifericos[i])
    ) {

      enviarPeriferico(
        i,
        mensaje
      );
    }
  }
}


// =====================================================
// RECIBIR ESP-NOW
// =====================================================

void recibirESPNow(
  const esp_now_recv_info_t *info,
  const uint8_t *data,
  int len
) {

  char mensaje[100];


  if (
    len >= sizeof(mensaje)
  ) {

    len =
      sizeof(mensaje) - 1;
  }


  memcpy(
    mensaje,
    data,
    len
  );


  mensaje[len] =
    '\0';


  String texto =
    String(mensaje);


  Serial.print(
    "ESP-NOW recibido: "
  );

  Serial.println(
    texto
  );


  if (
    texto.startsWith(
      "REACCION:"
    )
  ) {

    unsigned long tiempo =
      texto.substring(9).toInt();


    procesarReaccion(
      tiempo
    );
  }
}


// =====================================================
// IDENTIFICAR PERIFERICO
// =====================================================

int identificarPeriferico(
  const uint8_t *mac
) {

  for (
    int i = 0;
    i < CANTIDAD_MAXIMA_PERIFERICOS;
    i++
  ) {

    if (
      !macValida(
        perifericos[i]
      )
    ) {

      continue;
    }


    bool iguales = true;


    for (int j = 0; j < 6; j++) {

      if (
        mac[j] != perifericos[i][j]
      ) {

        iguales = false;

        break;
      }
    }


    if (iguales) {

      return i;
    }
  }


  return -1;
}


// =====================================================
// FIREBASE
// =====================================================

void procesarFirebase(
  AsyncResult &resultado
) {

  if (
    !resultado.isResult()
  ) {

    return;
  }


  if (
    resultado.isError()
  ) {

    Firebase.printf(
      "Firebase error: %s\n",
      resultado.error().message().c_str()
    );
  }


  if (
    resultado.available()
  ) {

    Firebase.printf(
      "Firebase: %s\n",
      resultado.c_str()
    );
  }
}


// =====================================================
// GUARDAR TIEMPO
// =====================================================

void guardarTiempo(
  unsigned long tiempo,
  int unidad
) {

  if (
    !usuarioConectado
  ) {

    Serial.println(
      "No hay usuario"
    );

    return;
  }


  if (
    !app.ready()
  ) {

    Serial.println(
      "Firebase no esta listo"
    );

    return;
  }


  String ruta =
    "/UsersData/" +
    usuarioUID +
    "/tiempos/" +
    String(millis());


  object_t json;

  JsonWriter writer;


  object_t objTiempo;

  object_t objUnidad;

  object_t objRonda;


  writer.create(
    objTiempo,
    "tiempo",
    number_t(
      tiempo / 1000.0,
      3
    )
  );


  writer.create(
    objUnidad,
    "unidad",
    unidad + 1
  );


  writer.create(
    objRonda,
    "ronda",
    rondaActual
  );


  writer.join(
    json,
    3,
    objTiempo,
    objUnidad,
    objRonda
  );


  Database.set<object_t>(
    aClient,
    ruta,
    json,
    procesarFirebase,
    "guardarTiempo"
  );


  Serial.println(
    "Tiempo guardado en Firebase"
  );
}


// =====================================================
// GUARDAR ENTRENAMIENTO
// =====================================================

void guardarResultadoEntrenamiento() {

  if (
    !usuarioConectado ||
    !app.ready()
  ) {

    return;
  }


  String ruta =
    "/UsersData/" +
    usuarioUID +
    "/entrenamientos/" +
    String(millis());


  object_t json;

  JsonWriter writer;


  object_t objRondas;

  object_t objUltimo;

  object_t objTotal;


  writer.create(
    objRondas,
    "rondas",
    cantidadRondas
  );


  writer.create(
    objUltimo,
    "ultimoTiempo",
    number_t(
      tiempoUltimaReaccion / 1000.0,
      3
    )
  );


  writer.create(
    objTotal,
    "finalizado",
    true
  );


  writer.join(
    json,
    3,
    objRondas,
    objUltimo,
    objTotal
  );


  Database.set<object_t>(
    aClient,
    ruta,
    json,
    procesarFirebase,
    "guardarEntrenamiento"
  );
}


// =====================================================
// ELEGIR PERIFERICO
// =====================================================

int elegirPeriferico() {

  int disponibles[5];

  int cantidad = 0;


  for (
    int i = 0;
    i < CANTIDAD_MAXIMA_PERIFERICOS;
    i++
  ) {

    if (
      macValida(
        perifericos[i]
      )
    ) {

      if (
        i != perifericoAnterior ||
        CANTIDAD_MAXIMA_PERIFERICOS == 1
      ) {

        disponibles[cantidad] =
          i;

        cantidad++;
      }
    }
  }


  if (
    cantidad == 0
  ) {

    return -1;
  }


  int posicion =
    random(0, cantidad);


  return disponibles[posicion];
}


// =====================================================
// COMENZAR RONDA
// =====================================================

void comenzarRonda() {

  if (
    !entrenamientoActivo
  ) {

    return;
  }


  if (
    rondaActual >= cantidadRondas
  ) {

    finalizarEntrenamiento();

    return;
  }


  perifericoActual =
    elegirPeriferico();


  if (
    perifericoActual == -1
  ) {

    Serial.println(
      "No hay perifericos configurados"
    );

    finalizarEntrenamiento();

    return;
  }


  perifericoAnterior =
    perifericoActual;


  rondaActual++;


  esperandoReaccion =
    true;


  inicioRonda =
    millis();


  Serial.print(
    "Ronda "
  );

  Serial.print(
    rondaActual
  );

  Serial.print(
    " - periferico "
  );

  Serial.println(
    perifericoActual + 1
  );


  enviarPeriferico(
    perifericoActual,
    "EMPEZAR"
  );


  encenderColor(
    0,
    0,
    255
  );


  if (
    dispositivoBLEConectado
  ) {

    String mensaje =
      "RONDA:" +
      String(rondaActual) +
      ":" +
      String(perifericoActual + 1);


    caracteristicaTX->setValue(
      mensaje.c_str()
    );

    caracteristicaTX->notify();
  }
}


// =====================================================
// PROCESAR REACCION
// =====================================================

void procesarReaccion(
  unsigned long tiempo
) {

  if (
    !entrenamientoActivo ||
    !esperandoReaccion
  ) {

    return;
  }


  esperandoReaccion =
    false;


  tiempoUltimaReaccion =
    tiempo;


  Serial.print(
    "Reaccion: "
  );

  Serial.print(
    tiempo
  );

  Serial.println(
    " ms"
  );


  enviarPeriferico(
    perifericoActual,
    "REACCION"
  );


  apagarLeds();


  guardarTiempo(
    tiempo,
    perifericoActual
  );


  if (
    dispositivoBLEConectado
  ) {

    String mensaje =
      "TIEMPO:" +
      String(
        tiempo / 1000.0,
        3
      );


    caracteristicaTX->setValue(
      mensaje.c_str()
    );

    caracteristicaTX->notify();
  }


  unsigned long esperaSiguienteRonda =
    millis();


  while (
    millis() -
    esperaSiguienteRonda <
    500
  ) {

    app.loop();
  }


  if (
    entrenamientoActivo
  ) {

    comenzarRonda();
  }
}


// =====================================================
// FINALIZAR ENTRENAMIENTO
// =====================================================

void finalizarEntrenamiento() {

  entrenamientoActivo =
    false;


  esperandoReaccion =
    false;


  enviarTodos(
    "APAGAR"
  );


  apagarLeds();


  guardarResultadoEntrenamiento();


  Serial.println(
    "ENTRENAMIENTO FINALIZADO"
  );


  if (
    dispositivoBLEConectado
  ) {

    caracteristicaTX->setValue(
      "ENTRENAMIENTO_FINALIZADO"
    );

    caracteristicaTX->notify();
  }
}


// =====================================================
// INICIAR ENTRENAMIENTO
// =====================================================

void iniciarEntrenamiento() {

  if (
    !usuarioConectado
  ) {

    Serial.println(
      "No se puede entrenar sin usuario"
    );

    if (
      dispositivoBLEConectado
    ) {

      caracteristicaTX->setValue(
        "ERROR:USUARIO"
      );

      caracteristicaTX->notify();
    }

    return;
  }


  if (
    entrenamientoActivo
  ) {

    return;
  }


  entrenamientoActivo =
    true;


  esperandoReaccion =
    false;


  rondaActual =
    0;


  perifericoAnterior =
    -1;


  Serial.println(
    "ENTRENAMIENTO INICIADO"
  );


  comenzarRonda();
}


// =====================================================
// DETENER
// =====================================================

void detenerEntrenamiento() {

  entrenamientoActivo =
    false;


  esperandoReaccion =
    false;


  enviarTodos(
    "DETENER"
  );


  apagarLeds();


  if (
    dispositivoBLEConectado
  ) {

    caracteristicaTX->setValue(
      "ENTRENAMIENTO_DETENIDO"
    );

    caracteristicaTX->notify();
  }
}


// =====================================================
// BLE SERVER
// =====================================================

class ServidorCallbacks :
  public BLEServerCallbacks {

  void onConnect(
    BLEServer *server
  ) override {

    dispositivoBLEConectado =
      true;


    Serial.println(
      "APP CONECTADA"
    );
  }


  void onDisconnect(
    BLEServer *server
  ) override {

    dispositivoBLEConectado =
      false;


    Serial.println(
      "APP DESCONECTADA"
    );


    server
      ->getAdvertising()
      ->start();
  }
};


// =====================================================
// BLE RECEPCION
// =====================================================

class RXCallbacks :
  public BLECharacteristicCallbacks {

  void onWrite(
    BLECharacteristic *characteristic
  ) override {

    String mensaje =
      characteristic->getValue();


    mensaje.trim();


    Serial.print(
      "BLE: "
    );

    Serial.println(
      mensaje
    );


    // =============================================
    // UID
    // =============================================

    if (
      mensaje.startsWith(
        "UID:"
      )
    ) {

      usuarioUID =
        mensaje.substring(4);


      usuarioUID.trim();


      usuarioConectado =
        usuarioUID.length() > 0;


      if (
        dispositivoBLEConectado
      ) {

        String respuesta =
          "USUARIO_OK:" +
          usuarioUID;


        caracteristicaTX->setValue(
          respuesta.c_str()
        );

        caracteristicaTX->notify();
      }
    }


    // =============================================
    // ENTRENAR
    // =============================================

    else if (
      mensaje == "ENTRENAR"
    ) {

      iniciarEntrenamiento();
    }


    // =============================================
    // NUMERO DE RONDAS
    // =============================================

    else if (
      mensaje.startsWith(
        "RONDAS:"
      )
    ) {

      cantidadRondas =
        mensaje.substring(7).toInt();


      if (
        cantidadRondas < 1
      ) {

        cantidadRondas = 1;
      }


      if (
        cantidadRondas > 100
      ) {

        cantidadRondas = 100;
      }


      Serial.print(
        "Rondas configuradas: "
      );

      Serial.println(
        cantidadRondas
      );
    }


    // =============================================
    // DETENER
    // =============================================

    else if (
      mensaje == "DETENER"
    ) {

      detenerEntrenamiento();
    }


    // =============================================
    // ENCENDER
    // =============================================

    else if (
      mensaje == "ENCENDER"
    ) {

      enviarTodos(
        "ENCENDER"
      );
    }


    // =============================================
    // APAGAR
    // =============================================

    else if (
      mensaje == "APAGAR"
    ) {

      enviarTodos(
        "APAGAR"
      );
    }
  }
};


// =====================================================
// CONFIGURAR BLE
// =====================================================

void configurarBLE() {

  BLEDevice::init(
    "LED Trainer Central"
  );


  BLEServer *servidor =
    BLEDevice::createServer();


  servidor->setCallbacks(
    new ServidorCallbacks()
  );


  BLEService *servicio =
    servidor->createService(
      SERVICE_UUID
    );


  caracteristicaRX =
    servicio->createCharacteristic(
      CHARACTERISTIC_UUID_RX,
      BLECharacteristic::PROPERTY_WRITE
    );


  caracteristicaTX =
    servicio->createCharacteristic(
      CHARACTERISTIC_UUID_TX,
      BLECharacteristic::PROPERTY_NOTIFY
    );


  caracteristicaTX->addDescriptor(
    new BLE2902()
  );


  caracteristicaRX->setCallbacks(
    new RXCallbacks()
  );


  servicio->start();


  BLEAdvertising *advertising =
    BLEDevice::getAdvertising();


  advertising->addServiceUUID(
    SERVICE_UUID
  );


  advertising->setScanResponse(
    true
  );


  advertising->start();


  Serial.println(
    "BLE iniciado"
  );
}


// =====================================================
// CONFIGURAR ESP-NOW
// =====================================================

void configurarESPNow() {

  if (
    esp_now_init() != ESP_OK
  ) {

    Serial.println(
      "ERROR ESP-NOW"
    );

    return;
  }


  esp_now_register_recv_cb(
    recibirESPNow
  );


  for (
    int i = 0;
    i < CANTIDAD_MAXIMA_PERIFERICOS;
    i++
  ) {

    agregarPeriferico(
      perifericos[i]
    );
  }
}


// =====================================================
// RADAR CENTRAL
// =====================================================

void comprobarRadarCentral() {

  bool movimiento =
    digitalRead(
      SENSOR_PIN
    );


  unsigned long ahora =
    millis();


  if (
    movimiento == HIGH &&
    movimientoAnterior == LOW
  ) {

    if (
      ahora -
      ultimoMovimiento >
      tiempoAntirrebote
    ) {

      ultimoMovimiento =
        ahora;


      if (
        !entrenamientoActivo
      ) {

        tiraEncendida =
          !tiraEncendida;


        if (
          tiraEncendida
        ) {

          cambiarColor();
        }

        else {

          apagarLeds();
        }
      }
    }
  }


  movimientoAnterior =
    movimiento;
}


// =====================================================
// COLORES CENTRAL
// =====================================================

void actualizarColores() {

  if (
    !tiraEncendida ||
    entrenamientoActivo
  ) {

    return;
  }


  unsigned long ahora =
    millis();


  if (
    ahora -
    tiempoAnteriorColor >=
    intervaloColor
  ) {

    tiempoAnteriorColor =
      ahora;


    cambiarColor();
  }
}


// =====================================================
// SETUP
// =====================================================

void setup() {

  Serial.begin(
    115200
  );


  randomSeed(
    micros()
  );


  tira.begin();

  tira.setBrightness(
    200
  );


  encenderColor(
    255,
    0,
    0
  );


  pinMode(
    SENSOR_PIN,
    INPUT
  );


  WiFi.mode(
    WIFI_STA
  );


  WiFi.begin(
    WIFI_SSID,
    WIFI_PASSWORD
  );


  Serial.print(
    "Conectando WiFi"
  );


  while (
    WiFi.status() != WL_CONNECTED
  ) {

    Serial.print(
      "."
    );

    delay(300);
  }


  Serial.println();


  Serial.println(
    "WiFi conectado"
  );


  Serial.print(
    "MAC CENTRAL: "
  );

  Serial.println(
    WiFi.macAddress()
  );


  Firebase.printf(
    "Firebase Client v%s\n",
    FIREBASE_CLIENT_VERSION
  );


  set_ssl_client_insecure_and_buffer(
    ssl_client
  );


  initializeApp(
    aClient,
    app,
    getAuth(user_auth),
    procesarFirebase,
    "authTask"
  );


  app.getApp<RealtimeDatabase>(
    Database
  );


  Database.url(
    DATABASE_URL
  );


  configurarESPNow();


  configurarBLE();


  Serial.println(
    "CENTRAL LISTO"
  );
}


// =====================================================
// LOOP
// =====================================================

void loop() {

  app.loop();


  procesarFirebase(
    databaseResult
  );


  comprobarRadarCentral();


  actualizarColores();
}