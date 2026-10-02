#include <WiFi.h>
#include <esp_now.h>
#include <Adafruit_NeoPixel.h>

#define PIN_NEOPIXEL 21
#define NUMPIXELS 24
#define SENSOR_PIN 4

Adafruit_NeoPixel tira(NUMPIXELS, PIN_NEOPIXEL, NEO_GRB + NEO_KHZ800);

bool luzEncendida = false;
unsigned long inicioEntrenamiento = 0;
uint8_t macCentral[6];

void apagarLeds() {
  for (int i = 0; i < NUMPIXELS; i++) tira.setPixelColor(i, 0, 0, 0);
  tira.show();
}

void encenderColor(int r, int g, int b) {
  for (int i = 0; i < NUMPIXELS; i++) tira.setPixelColor(i, tira.Color(r, g, b));
  tira.show();
}

void enviarAlCentral(const char *mensaje) {
  if (!esp_now_is_peer_exist(macCentral)) {
    esp_now_peer_info_t peerInfo = {};
    memcpy(peerInfo.peer_addr, macCentral, 6);
    peerInfo.channel = 0;
    peerInfo.encrypt = false;
    esp_now_add_peer(&peerInfo);
  }
  esp_now_send(macCentral, (uint8_t *)mensaje, strlen(mensaje) + 1);
}

void recibirESPNow(const esp_now_recv_info_t *info, const uint8_t *data, int len) {
  char mensaje[100];
  if (len >= sizeof(mensaje)) len = sizeof(mensaje) - 1;
  memcpy(mensaje, data, len);
  mensaje[len] = '\0';

  memcpy(macCentral, info->src_addr, 6);

  if (strcmp(mensaje, "EMPEZAR") == 0) {
    inicioEntrenamiento = millis();
    luzEncendida = true;
    encenderColor(0, 255, 0); // Encender en VERDE
    Serial.println("Comando EMPEZAR recibido -> Luz encendida");
  }
}

void setup() {
  Serial.begin(115200);
  pinMode(SENSOR_PIN, INPUT);
  
  tira.begin();
  apagarLeds();

  WiFi.mode(WIFI_STA);
  Serial.print("MAC PERIFERICO: ");
  Serial.println(WiFi.macAddress());

  if (esp_now_init() != ESP_OK) {
    Serial.println("Error iniciando ESP-NOW");
    return;
  }
  esp_now_register_recv_cb(recibirESPNow);

  Serial.println("PERIFERICO LISTO");
}

void loop() {
  if (luzEncendida) {
    if (digitalRead(SENSOR_PIN) == HIGH) {
      unsigned long tiempoReaccion = millis() - inicioEntrenamiento;

      // 1. APAGAR LEDS DE INMEDIATO
      apagarLeds();
      luzEncendida = false;

      // 2. Mando el tiempo a la Central
      String respuesta = "REACCION:" + String(tiempoReaccion);
      enviarAlCentral(respuesta.c_str());

      Serial.print("Sensor activado! Luz apagada. Tiempo: ");
      Serial.print(tiempoReaccion);
      Serial.println(" ms");

      delay(300);
    }
  }
}