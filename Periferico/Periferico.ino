#include <esp_now.h>
#include <WiFi.h>
#include <Adafruit_NeoPixel.h>
#include <esp_wifi.h>

#define PIN_NEOPIXEL   7
#define NUM_PIXELS     24
#define PIN_RCWL       2

#define POD_ID 1 // Identificador del Pod Periférico

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

uint8_t macCentral[6];
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
  // Manejo de orden de apagar (RGB = 0,0,0)
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
  memcpy(&datosEntrada, incomingData, sizeof(datosEntrada));
  memcpy(macCentral, recv_info->src_addr, 6);

  if (datosEntrada.podId == POD_ID && !datosEntrada.esReaccion) {
    solicitarEncendido(datosEntrada.r, datosEntrada.g, datosEntrada.b);
  }
}

void setup() {
  Serial.begin(115200);
  strip.begin();
  strip.setBrightness(255); // Brillo máximo de hardware
  apagarLEDs();

  pinMode(PIN_RCWL, INPUT);

  WiFi.mode(WIFI_STA);
  esp_wifi_set_channel(1, WIFI_SECOND_CHAN_NONE);

  if (esp_now_init() != ESP_OK) {
    Serial.println("Error al inicializar ESP-NOW en Pod 1");
    return;
  }

  esp_now_register_recv_cb(OnDataRecv);
  Serial.println("[POD 1] Listo esperando órdenes ESP-NOW...");
}

void loop() {
  // Detección de toque / reacción
  if (esperandoSensor && digitalRead(PIN_RCWL) == HIGH) {
    unsigned long reactionTime = millis() - startTime;
    esperandoSensor = false;
    apagarLEDs();

    datosSalida.podId = POD_ID;
    datosSalida.reactionTime = reactionTime;
    datosSalida.esReaccion = true;

    esp_now_peer_info_t peerInfo = {};
    memcpy(peerInfo.peer_addr, macCentral, 6);
    peerInfo.channel = 0;
    peerInfo.encrypt = false;
    
    if (!esp_now_is_peer_exist(macCentral)) {
      esp_now_add_peer(&peerInfo);
    }

    esp_now_send(macCentral, (uint8_t *) &datosSalida, sizeof(datosSalida));
    Serial.print("[POD 1] Reacción enviada al Central: ");
    Serial.println(reactionTime);
  }

  // Desbloqueo si la mano estaba encima cuando llegó la orden
  if (comandoPendiente && digitalRead(PIN_RCWL) == LOW) {
    comandoPendiente = false;
    encenderLEDs(pendingR, pendingG, pendingB);
    startTime = millis();
    esperandoSensor = true;
  }

  delay(1);
}