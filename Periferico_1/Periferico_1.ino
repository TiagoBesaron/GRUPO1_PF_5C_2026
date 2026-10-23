#include <esp_now.h>
#include <WiFi.h>
#include <Adafruit_NeoPixel.h>
#include <esp_wifi.h>

#define PIN_NEOPIXEL   7
#define NUM_PIXELS     24
#define PIN_RCWL       2
#define POD_ID         1

Adafruit_NeoPixel strip(NUM_PIXELS, PIN_NEOPIXEL, NEO_GRB + NEO_KHZ800);

typedef struct struct_message {
  uint8_t podId;
  uint8_t r;
  uint8_t g;
  uint8_t b;
  uint32_t reactionTime;
  bool esReaccion;
} struct_message;

struct_message datosEntrada;
struct_message datosSalida;

uint8_t macCentral[6] = {0};
bool esperandoSensor = false;
bool comandoPendiente = false;
uint8_t pendingR = 0, pendingG = 0, pendingB = 0;
unsigned long startTime = 0;

void apagarLEDs() {
  strip.clear();
  strip.show();
}

void encenderLEDs(uint8_t r, uint8_t g, uint8_t b) {
  for (int i = 0; i < NUM_PIXELS; i++) {
    strip.setPixelColor(i, strip.Color(r, g, b));
  }
  strip.show();
}

void solicitarEncendido(uint8_t r, uint8_t g, uint8_t b) {
  if (r == 0 && g == 0 && b == 0) {
    esperandoSensor = false;
    comandoPendiente = false;
    apagarLEDs();
    return;
  }

  if (digitalRead(PIN_RCWL) == HIGH) {
    pendingR = r; 
    pendingG = g; 
    pendingB = b;
    comandoPendiente = true;
  } else {
    comandoPendiente = false;
    encenderLEDs(r, g, b);
    startTime = millis();
    esperandoSensor = true;
  }
}

void OnDataRecv(const esp_now_recv_info_t *recv_info, const uint8_t *incomingData, int len) {
  Serial.println("[PERIFERICO] ¡PAQUETE RECIBIDO POR ESP-NOW! 🎉");
  // Ignorar paquetes que no tengan el formato esperado (p. ej. de otros sketches)
  if (len != sizeof(struct_message)) {
    Serial.printf("[PERIFERICO] Paquete ignorado: %d bytes (se esperaban %d)\n", len, (int)sizeof(struct_message));
    return;
  }
  memcpy(&datosEntrada, incomingData, sizeof(datosEntrada));
  memcpy(macCentral, recv_info->src_addr, 6);

  if (datosEntrada.podId == POD_ID && !datosEntrada.esReaccion) {
    solicitarEncendido(datosEntrada.r, datosEntrada.g, datosEntrada.b);
  }
}

void setup() {
  Serial.begin(115200);
  strip.begin();
  strip.setBrightness(255);
  apagarLEDs();

  pinMode(PIN_RCWL, INPUT);

  delay(1500);  // tiempo para que abra el USB CDC del C3 SuperMini

  // Configuración Wi-Fi sin ahorro de energía y en Canal 1 fijo
  WiFi.mode(WIFI_STA);
  WiFi.disconnect();                    // no asociarse a ningún router (cambiaría el canal)
  esp_wifi_set_ps(WIFI_PS_NONE);
  WiFi.setTxPower(WIFI_POWER_8_5dBm);   // FIX C3 SuperMini: a potencia máxima la antena no transmite bien
  esp_wifi_set_channel(1, WIFI_SECOND_CHAN_NONE);

  Serial.println("\n==========================================");
  Serial.print(">>> MAC REAL DE WI-FI STA DEL PERIFERICO: ");
  Serial.println(WiFi.macAddress());
  Serial.println("==========================================");

  if (esp_now_init() != ESP_OK) {
    Serial.println("Error al inicializar ESP-NOW en Periférico");
    return;
  }

  esp_now_register_recv_cb(OnDataRecv);
  Serial.println("[PERIFERICO] Listo esperando órdenes en Canal 1 (Power Save OFF)...");
}

void loop() {
  if (esperandoSensor && digitalRead(PIN_RCWL) == HIGH) {
    unsigned long reactionTime = millis() - startTime;
    esperandoSensor = false;
    apagarLEDs();

    datosSalida.podId = POD_ID;
    datosSalida.reactionTime = reactionTime;
    datosSalida.esReaccion = true;

    esp_now_peer_info_t peerInfo = {};
    memcpy(peerInfo.peer_addr, macCentral, 6);
    peerInfo.channel = 1;
    peerInfo.ifidx = WIFI_IF_STA;
    peerInfo.encrypt = false;

    if (!esp_now_is_peer_exist(macCentral)) {
      esp_err_t rp = esp_now_add_peer(&peerInfo);
      if (rp != ESP_OK) {
        Serial.printf("[PERIFERICO] Error registrando Central: %s\n", esp_err_to_name(rp));
      }
    }

    esp_err_t r = esp_now_send(macCentral, (uint8_t *) &datosSalida, sizeof(datosSalida));
    if (r != ESP_OK) {
      Serial.printf("[PERIFERICO] esp_now_send error: %s\n", esp_err_to_name(r));
    }
    Serial.print("[PERIFERICO] Reacción enviada a la Central: ");
    Serial.println(reactionTime);
  }

  if (comandoPendiente && digitalRead(PIN_RCWL) == LOW) {
    comandoPendiente = false;
    encenderLEDs(pendingR, pendingG, pendingB);
    startTime = millis();
    esperandoSensor = true;
  }

  delay(1);
}
