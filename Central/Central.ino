#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <Adafruit_NeoPixel.h>
#include <esp_now.h>
#include <WiFi.h>

#define PIN_NEOPIXEL   7
#define NUM_PIXELS     24
#define PIN_RCWL       2

#define SERVICE_UUID           "4fa8691a-0393-40a3-974f-0759e09f114d"
#define CHARACTERISTIC_UUID_RX "87b54dba-055b-4321-8525-2b2a239385c7"
#define CHARACTERISTIC_UUID_TX "d7b54dba-055b-4321-8525-2b2a239385c8"

Adafruit_NeoPixel strip(NUM_PIXELS, PIN_NEOPIXEL, NEO_GRB + NEO_KHZ800);

// REEMPLAZAR CON LA MAC REAL DEL POD 1 OBTENIDA EN EL PASO 1
uint8_t macPod1[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF}; 

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

BLEServer* pServer = NULL;
BLECharacteristic* pTxCharacteristic = NULL;
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
  if (digitalRead(PIN_RCWL) == HIGH) {
    pendingR = r; pendingG = g; pendingB = b;
    comandoPendienteLocal = true;
  } else {
    comandoPendienteLocal = false;
    encenderLEDsLocales(r, g, b);
    startTimeLocal = millis();
    esperandoSensorLocal = true;
  }
}

// Callback al recibir reacción por ESP-NOW desde Pod 1
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

class ServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) { appConectada = true; }
    void onDisconnect(BLEServer* pServer) {
      appConectada = false;
      esperandoSensorLocal = false;
      apagarLEDsLocales();
      pServer->getAdvertising()->start();
    }
};

class CharacteristicCallbacks: public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *pCharacteristic) {
      if (!appConectada) return;
      String rxValue = pCharacteristic->getValue().c_str();

      // Formato comando: EMPEZAR:POD_ID,R,G,B (ejemplo EMPEZAR:0,255,0,0 o EMPEZAR:1,0,255,0)
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
            // Activar LEDs en el propio Central (Pod 0)
            solicitarEncendidoLocal((uint8_t)r, (uint8_t)g, (uint8_t)b);
          } else if (podTarget == 1) {
            // Enviar orden por ESP-NOW a Pod 1
            datosEnvio.podId = 1;
            datosEnvio.r = r; datosEnvio.g = g; datosEnvio.b = b;
            datosEnvio.esReaccion = false;
            esp_now_send(macPod1, (uint8_t *) &datosEnvio, sizeof(datosEnvio));
          }
        }
      }
    }
};

void setup() {
  Serial.begin(115200);
  strip.begin();
  strip.setBrightness(128);
  apagarLEDsLocales();
  pinMode(PIN_RCWL, INPUT);

  // Inicializar WiFi en modo dual STA para ESP-NOW
  WiFi.mode(WIFI_STA);

  if (esp_now_init() != ESP_OK) {
    Serial.println("Error al inicializar ESP-NOW en Central");
    return;
  }
  esp_now_register_recv_cb(OnDataRecv);

  // Registrar Pod 1 como Peer ESP-NOW
  esp_now_peer_info_t peerInfo = {};
  memcpy(peerInfo.peer_addr, macPod1, 6);
  peerInfo.channel = 0;
  peerInfo.encrypt = false;
  esp_now_add_peer(&peerInfo);

  // Inicialización BLE
  BLEDevice::init("ACTIVELO_CENTRAL");
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new ServerCallbacks());

  BLEService *pService = pServer->createService(SERVICE_UUID);
  pTxCharacteristic = pService->createCharacteristic(
                        CHARACTERISTIC_UUID_TX, BLECharacteristic::PROPERTY_NOTIFY
                      );
  pTxCharacteristic->addDescriptor(new BLE2902());

  BLECharacteristic *pRxCharacteristic = pService->createCharacteristic(
                                           CHARACTERISTIC_UUID_RX, BLECharacteristic::PROPERTY_WRITE
                                         );
  pRxCharacteristic->setCallbacks(new CharacteristicCallbacks());

  pService->start();
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->start();

  Serial.println("[CENTRAL] Puente BLE / ESP-NOW iniciado.");
}

void loop() {
  if (!appConectada) { delay(10); return; }

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

  if (comandoPendienteLocal && digitalRead(PIN_RCWL) == LOW) {
    comandoPendienteLocal = false;
    encenderLEDsLocales(pendingR, pendingG, pendingB);
    startTimeLocal = millis();
    esperandoSensorLocal = true;
  }

  delay(1);
}