#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <Adafruit_NeoPixel.h>
#include <esp_now.h>
#include <WiFi.h>
#include <esp_wifi.h>

#define PIN_NEOPIXEL 7
#define NUM_PIXELS 24
#define PIN_RCWL 2

#define SERVICE_UUID "4fa8691a-0393-40a3-974f-0759e09f114d"
#define CHARACTERISTIC_UUID_RX "87b54dba-055b-4321-8525-2b2a239385c7"
#define CHARACTERISTIC_UUID_TX "d7b54dba-055b-4321-8525-2b2a239385c8"

Adafruit_NeoPixel strip(NUM_PIXELS, PIN_NEOPIXEL, NEO_GRB + NEO_KHZ800);

// MAC REAL del Pod Periférico (Pod 1)
uint8_t macPod1[] = { 0x3C, 0x0F, 0x02, 0x87, 0x0F, 0xA4 };

typedef struct struct_message {
  uint8_t podId;
  uint8_t r;
  uint8_t g;
  uint8_t b;
  uint32_t reactionTime;
  bool esReaccion;
} struct_message;

struct_message datosEnvio;
struct_message datosRecepcion;

BLEServer *pServer = NULL;
BLECharacteristic *pTxCharacteristic = NULL;
bool appConectada = false;

bool esperandoSensorLocal = false;
bool comandoPendienteLocal = false;
uint8_t pendingR = 0, pendingG = 0, pendingB = 0;
unsigned long startTimeLocal = 0;

void apagarLEDsLocales() {
  strip.clear();
  strip.show();
}

void encenderLEDsLocales(uint8_t r, uint8_t g, uint8_t b) {
  for (int i = 0; i < NUM_PIXELS; i++) {
    strip.setPixelColor(i, strip.Color(r, g, b));
  }
  strip.show();
}

void solicitarEncendidoLocal(uint8_t r, uint8_t g, uint8_t b) {
  if (!appConectada) return;

  // Si se solicita apagar (RGB = 0,0,0)
  if (r == 0 && g == 0 && b == 0) {
    esperandoSensorLocal = false;
    comandoPendienteLocal = false;
    apagarLEDsLocales();
    return;
  }

  if (digitalRead(PIN_RCWL) == HIGH) {
    pendingR = r;
    pendingG = g;
    pendingB = b;
    comandoPendienteLocal = true;
  } else {
    comandoPendienteLocal = false;
    encenderLEDsLocales(r, g, b);
    startTimeLocal = millis();
    esperandoSensorLocal = true;
  }
}

// Callback de confirmación de envío por ESP-NOW (Firma adaptada a ESP32 Core v3.x)
void OnDataSent(const wifi_tx_info_t *tx_info, esp_now_send_status_t status) {
  Serial.print("[CENTRAL] Estado envio a Pod 1: ");
  Serial.println(status == ESP_NOW_SEND_SUCCESS ? "ENTREGADO EXITOSO ✅" : "FALLÓ (Periferico no responde) ❌");
}

// Callback al recibir respuesta de reacción por ESP-NOW desde Pod 1
void OnDataRecv(const esp_now_recv_info_t *recv_info, const uint8_t *incomingData, int len) {
  memcpy(&datosRecepcion, incomingData, sizeof(datosRecepcion));

  if (datosRecepcion.esReaccion && pTxCharacteristic != NULL && appConectada) {
    String mensaje = "REACCION:" + String(datosRecepcion.reactionTime);
    pTxCharacteristic->setValue(mensaje.c_str());
    pTxCharacteristic->notify();
    Serial.print("[CENTRAL] Reacción recibida de Pod ");
    Serial.print(datosRecepcion.podId);
    Serial.println(" retransmitida a la App.");
  }
}

class ServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer *pServer) {
    appConectada = true;
    Serial.println("[CENTRAL] App conectada por BLE.");
  }
  void onDisconnect(BLEServer *pServer) {
    appConectada = false;
    esperandoSensorLocal = false;
    comandoPendienteLocal = false;
    apagarLEDsLocales();
    Serial.println("[CENTRAL] App desconectada. Reiniciando publicidad BLE...");
    pServer->getAdvertising()->start();
  }
};

class CharacteristicCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic) {
    if (!appConectada) return;
    String rxValue = pCharacteristic->getValue().c_str();

    // Formato comando: EMPEZAR:POD_ID,R,G,B
    if (rxValue.startsWith("EMPEZAR:")) {
      String parametros = rxValue.substring(8);
      int c1 = parametros.indexOf(',');
      int c2 = parametros.indexOf(',', c1 + 1);
      int c3 = parametros.indexOf(',', c2 + 1);

      if (c1 != -1 && c2 != -1 && c3 != -1) {
        int podTarget = parametros.substring(0, c1).toInt();
        int r = parametros.substring(c1 + 1, c2).toInt();
        int g = parametros.substring(c2 + 1, c3).toInt();
        int b = parametros.substring(c3 + 1).toInt();

        if (podTarget == 0) {
          solicitarEncendidoLocal((uint8_t)r, (uint8_t)g, (uint8_t)b);
        } else if (podTarget == 1) {
          datosEnvio.podId = 1;
          datosEnvio.r = r;
          datosEnvio.g = g;
          datosEnvio.b = b;
          datosEnvio.esReaccion = false;
          esp_now_send(macPod1, (uint8_t *)&datosEnvio, sizeof(datosEnvio));
        }
      }
    }
  }
};

void setup() {
  Serial.begin(115200);
  strip.begin();
  strip.setBrightness(255);
  apagarLEDsLocales();
  pinMode(PIN_RCWL, INPUT);

  WiFi.mode(WIFI_STA);
  esp_wifi_set_channel(1, WIFI_SECOND_CHAN_NONE);

  if (esp_now_init() != ESP_OK) {
    Serial.println("Error al inicializar ESP-NOW en Central");
    return;
  }
  esp_now_register_send_cb(OnDataSent);
  esp_now_register_recv_cb(OnDataRecv);

  esp_now_peer_info_t peerInfo = {};
  memcpy(peerInfo.peer_addr, macPod1, 6);
  peerInfo.channel = 0;
  peerInfo.encrypt = false;
  esp_now_add_peer(&peerInfo);

  BLEDevice::init("ACTIVELO_CENTRAL");
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new ServerCallbacks());

  BLEService *pService = pServer->createService(SERVICE_UUID);
  pTxCharacteristic = pService->createCharacteristic(
    CHARACTERISTIC_UUID_TX, BLECharacteristic::PROPERTY_NOTIFY);
  pTxCharacteristic->addDescriptor(new BLE2902());

  BLECharacteristic *pRxCharacteristic = pService->createCharacteristic(
    CHARACTERISTIC_UUID_RX, BLECharacteristic::PROPERTY_WRITE);
  pRxCharacteristic->setCallbacks(new CharacteristicCallbacks());

  pService->start();
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->start();

  Serial.println("[CENTRAL] Puente BLE / ESP-NOW iniciado.");
}

void loop() {
  if (!appConectada) {
    delay(10);
    return;
  }

  // Lectura del sensor RCWL local (Pod 0)
  if (esperandoSensorLocal && digitalRead(PIN_RCWL) == HIGH) {
    unsigned long reactionTime = millis() - startTimeLocal;
    esperandoSensorLocal = false;
    apagarLEDsLocales();

    if (pTxCharacteristic != NULL) {
      String mensaje = "REACCION:" + String(reactionTime);
      pTxCharacteristic->setValue(mensaje.c_str());
      pTxCharacteristic->notify();
    }
  }

  // Desbloqueo si la mano estaba encima cuando llegó la orden
  if (comandoPendienteLocal && digitalRead(PIN_RCWL) == LOW) {
    comandoPendienteLocal = false;
    encenderLEDsLocales(pendingR, pendingG, pendingB);
    startTimeLocal = millis();
    esperandoSensorLocal = true;
  }

  delay(1);
}