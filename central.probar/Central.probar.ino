#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <Adafruit_NeoPixel.h>
#include <esp_now.h>
#include <WiFi.h>
#include <esp_wifi.h>
#include <esp_idf_version.h>

#define PIN_NEOPIXEL 7
#define NUM_PIXELS 24
#define PIN_RCWL 2

#define SERVICE_UUID "4fa8691a-0393-40a3-974f-0759e09f114d"
#define CHARACTERISTIC_UUID_RX "87b54dba-055b-4321-8525-2b2a239385c7"
#define CHARACTERISTIC_UUID_TX "d7b54dba-055b-4321-8525-2b2a239385c8"

Adafruit_NeoPixel strip(NUM_PIXELS, PIN_NEOPIXEL, NEO_GRB + NEO_KHZ800);

// MAC REAL de Wi-Fi STA del Pod Periférico (Pod 1)
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

// VARIABLES PARA MANEJO SEGURO DE REACCIÓN REMOTA (POD 1)
volatile bool hayReaccionRemota = false;
volatile uint32_t reactionTimeRemoto = 0;

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

#if ESP_IDF_VERSION >= ESP_IDF_VERSION_VAL(5, 5, 0)
void OnDataSent(const wifi_tx_info_t *tx_info, esp_now_send_status_t status) {
#else
void OnDataSent(const uint8_t *mac_addr, esp_now_send_status_t status) {
#endif
  Serial.print("[CENTRAL] Estado envio a Pod 1: ");
  Serial.println(status == ESP_NOW_SEND_SUCCESS ? "ENTREGADO EXITOSO ✅" : "FALLÓ (Periferico no responde) ❌");
}

// Callback ESP-NOW: Solo guarda los datos recibidos, no llama funciones de BLE aquí
void OnDataRecv(const esp_now_recv_info_t *recv_info, const uint8_t *incomingData, int len) {
  if (len != sizeof(struct_message)) {
    Serial.printf("[CENTRAL] Paquete ignorado: %d bytes (se esperaban %d)\n", len, (int)sizeof(struct_message));
    return;
  }
  memcpy(&datosRecepcion, incomingData, sizeof(datosRecepcion));

  if (datosRecepcion.esReaccion) {
    reactionTimeRemoto = datosRecepcion.reactionTime;
    hayReaccionRemota = true; // Activa la bandera para procesar en el loop()
    Serial.print("[CENTRAL] Reacción recibida por ESP-NOW del Pod ");
    Serial.println(datosRecepcion.podId);
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
          esp_err_t err = esp_now_send(macPod1, (uint8_t *)&datosEnvio, sizeof(datosEnvio));
          if (err != ESP_OK) {
            Serial.printf("[CENTRAL] esp_now_send error: %s\n", esp_err_to_name(err));
          }
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

  delay(1500);

  WiFi.mode(WIFI_STA);
  WiFi.disconnect();
  esp_wifi_set_ps(WIFI_PS_NONE);
  WiFi.setTxPower(WIFI_POWER_8_5dBm);
  esp_wifi_set_channel(1, WIFI_SECOND_CHAN_NONE);

  Serial.print("[CENTRAL] MAC Wi-Fi STA: ");
  Serial.println(WiFi.macAddress());

  if (esp_now_init() != ESP_OK) {
    Serial.println("Error al inicializar ESP-NOW en Central");
    return;
  }
  esp_now_register_send_cb(OnDataSent);
  esp_now_register_recv_cb(OnDataRecv);

  esp_now_peer_info_t peerInfo = {};
  memcpy(peerInfo.peer_addr, macPod1, 6);
  peerInfo.channel = 1;
  peerInfo.ifidx = WIFI_IF_STA;
  peerInfo.encrypt = false;
  esp_err_t r = esp_now_add_peer(&peerInfo);
  if (r != ESP_OK) {
    Serial.printf("[CENTRAL] Error registrando Pod 1: %s\n", esp_err_to_name(r));
  }

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

  Serial.println("[CENTRAL] Puente BLE / ESP-NOW iniciado en Canal 1.");
}

void loop() {
  if (!appConectada) {
    delay(10);
    return;
  }

  // 1. Lectura del sensor RCWL local (Pod 0)
  if (esperandoSensorLocal && digitalRead(PIN_RCWL) == HIGH) {
    unsigned long reactionTime = millis() - startTimeLocal;
    esperandoSensorLocal = false;
    apagarLEDsLocales();

    if (pTxCharacteristic != NULL) {
      String mensaje = "REACCION:" + String(reactionTime);
      pTxCharacteristic->setValue(mensaje.c_str());
      pTxCharacteristic->notify();
      Serial.print("[CENTRAL] Reacción de Pod 0 enviada por BLE: ");
      Serial.println(mensaje);
    }
  }

  if (comandoPendienteLocal && digitalRead(PIN_RCWL) == LOW) {
    comandoPendienteLocal = false;
    encenderLEDsLocales(pendingR, pendingG, pendingB);
    startTimeLocal = millis();
    esperandoSensorLocal = true;
  }

  // 2. PROCESAMIENTO SEGURO DE REACCIÓN REMOTA (Pod 1)
  if (hayReaccionRemota) {
    hayReaccionRemota = false;
    if (pTxCharacteristic != NULL) {
      String mensaje = "REACCION:" + String(reactionTimeRemoto);
      pTxCharacteristic->setValue(mensaje.c_str());
      pTxCharacteristic->notify();
      Serial.print("[CENTRAL] Reacción de Pod 1 retransmitida a la App por BLE: ");
      Serial.println(mensaje);
    }
  }

  delay(1);
}