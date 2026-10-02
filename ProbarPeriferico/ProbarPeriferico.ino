#include <WiFi.h>
#include <esp_now.h>
#include <Adafruit_NeoPixel.h>

// =====================================================
// HARDWARE & PINES
// =====================================================
#define PIN 21
#define NUMPIXELS 24
#define SENSOR_PIN 4

Adafruit_NeoPixel tira(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

// MAC del ESP32 Central
uint8_t centralMAC[] = {0xE0, 0x72, 0xA1, 0x72, 0xDA, 0x54};

// =====================================================
// CONTROL DE SENSOR Y TIEMPOS
// =====================================================
bool movimientoAnterior = LOW;
unsigned long ultimoMovimiento = 0;
const unsigned long tiempoAntirrebote = 500;  // ms
const unsigned long tiempoInmunidad = 300;    // ms (IHS contra ruido RF al encender)

bool entrenamientoActivo = false;
unsigned long inicioEntrenamiento = 0;

// =====================================================
// CONTROL DE LEDS
// =====================================================
bool tiraEncendida = false;
int colorActual = 0;
unsigned long tiempoAnteriorColor = 0;
const unsigned long intervaloColor = 1000;

// =====================================================
// FUNCIONES AUXILIARES
// =====================================================
String obtenerMAC() {
  return WiFi.macAddress();
}

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
// TRANSMISIÓN ESP-NOW
// =====================================================
void enviarAlCentral(const char *mensaje) {
  esp_err_t resultado = esp_now_send(
    centralMAC,
    (uint8_t *)mensaje,
    strlen(mensaje) + 1
  );

  if (resultado == ESP_OK) {
    Serial.print("Enviado al central: ");
    Serial.println(mensaje);
  } else {
    Serial.print("Error enviando ESP-NOW: ");
    Serial.println(resultado);
  }
}

// =====================================================
// MÁQUINA DE ESTADOS - ENTRENAMIENTO
// =====================================================
void iniciarEntrenamiento() {
  entrenamientoActivo = true;
  inicioEntrenamiento = millis();
  tiraEncendida = true;

  // Encender LEDs en rojo para indicar acción
  encenderColor(255, 0, 0);

  Serial.println("ENTRENAMIENTO INICIADO (Inmunidad RF activa por 300ms)");
}

void detenerEntrenamiento() {
  entrenamientoActivo = false;
  tiraEncendida = false;
  apagarLeds();
  Serial.println("ENTRENAMIENTO DETENIDO");
}

// =====================================================
// RECEPCIÓN ESP-NOW
// =====================================================
void recibirESPNow(const esp_now_recv_info_t *info, const uint8_t *data, int len) {
  char mensaje[100];

  if (len >= sizeof(mensaje)) {
    len = sizeof(mensaje) - 1;
  }

  memcpy(mensaje, data, len);
  mensaje[len] = '\0';

  String comando = String(mensaje);
  Serial.print("Comando recibido: ");
  Serial.println(comando);

  if (comando == "EMPEZAR") {
    iniciarEntrenamiento();
  } 
  else if (comando == "DETENER" || comando == "APAGAR" || comando == "REACCION") {
    detenerEntrenamiento();
  } 
  else if (comando == "ENCENDER") {
    tiraEncendida = true;
    cambiarColor();
  }
}

// =====================================================
// LECTURA DEL SENSOR RADAR (RCWL-0516)
// =====================================================
void comprobarRadar() {
  bool movimiento = digitalRead(SENSOR_PIN);
  unsigned long ahora = millis();

  if (movimiento == HIGH && movimientoAnterior == LOW) {
    if (ahora - ultimoMovimiento > tiempoAntirrebote) {
      ultimoMovimiento = ahora;

      if (entrenamientoActivo) {
        // Filtrar falso disparo generado por la antena o encendido inicial
        if (ahora - inicioEntrenamiento < tiempoInmunidad) {
          Serial.println("Movimiento ignorado: dentro del período de inmunidad RF");
          movimientoAnterior = movimiento;
          return;
        }

        unsigned long tiempo = ahora - inicioEntrenamiento;

        Serial.print("Reaccion detectada: ");
        Serial.print(tiempo);
        Serial.println(" ms");

        char mensaje[100];
        snprintf(mensaje, sizeof(mensaje), "REACCION:%lu|MAC:%s", tiempo, obtenerMAC().c_str());

        enviarAlCentral(mensaje);
        detenerEntrenamiento();
      }
    }
  }

  movimientoAnterior = movimiento;
}

// =====================================================
// MODO REPOSO (CAMBIO AUTOMÁTICO DE COLOR)
// =====================================================
void actualizarColores() {
  if (!tiraEncendida || entrenamientoActivo) {
    return;
  }

  unsigned long ahora = millis();
  if (ahora - tiempoAnteriorColor >= intervaloColor) {
    tiempoAnteriorColor = ahora;
    cambiarColor();
  }
}

// =====================================================
// CONFIGURACIÓN ESP-NOW
// =====================================================
void configurarESPNow() {
  if (esp_now_init() != ESP_OK) {
    Serial.println("ERROR AL INICIALIZAR ESP-NOW");
    return;
  }

  esp_now_register_recv_cb(recibirESPNow);

  esp_now_peer_info_t peerInfo = {};
  memcpy(peerInfo.peer_addr, centralMAC, 6);
  peerInfo.channel = 0;
  peerInfo.encrypt = false;

  if (!esp_now_is_peer_exist(centralMAC)) {
    esp_err_t resultado = esp_now_add_peer(&peerInfo);
    if (resultado == ESP_OK) {
      Serial.println("Central vinculado con exito");
    } else {
      Serial.print("Error al vincular Central: ");
      Serial.println(resultado);
    }
  }
}

// =====================================================
// SETUP & LOOP
// =====================================================
void setup() {
  Serial.begin(115200);

  WiFi.mode(WIFI_STA);

  Serial.println("\n================================");
  Serial.println("LED TRAINER - PERIFERICO");
  Serial.println("================================");
  Serial.print("MAC PERIFERICO: ");
  Serial.println(obtenerMAC());

  tira.begin();
  tira.setBrightness(200);
  apagarLeds();

  pinMode(SENSOR_PIN, INPUT);

  configurarESPNow();

  Serial.println("PERIFERICO LISTO PARA OPERAR\n");
}

void loop() {
  comprobarRadar();
  actualizarColores();
}