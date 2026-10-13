#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <Adafruit_NeoPixel.h>
#include <esp_bt.h>

// --- CONFIGURACIÓN HARDWARE POD PERIFÉRICO ---
#define PIN_NEOPIXEL   7    // GPIO 7 para la tira NeoPixel
#define NUM_PIXELS     24   // 24 NeoPixels
#define PIN_RCWL       2    // GPIO 2 para el sensor RCWL-0516

Adafruit_NeoPixel strip(NUM_PIXELS, PIN_NEOPIXEL, NEO_GRB + NEO_KHZ800);

// --- UUIDs PROYECTO ACTIVELO ---
#define SERVICE_UUID           "4fa8691a-0393-40a3-974f-0759e09f114d"
#define CHARACTERISTIC_UUID_RX "87b54dba-055b-4321-8525-2b2a239385c7"
#define CHARACTERISTIC_UUID_TX "d7b54dba-055b-4321-8525-2b2a239385c8"

BLEServer* pServer = NULL;
BLECharacteristic* pTxCharacteristic = NULL;
bool deviceConnected = false;

// --- CONTROL DE ESTADOS Y SENSORES ---
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
  if (digitalRead(PIN_RCWL) == HIGH) {
    // Si el RCWL está retenido en 1, guarda la orden para cuando baje a 0
    pendingR = r; pendingG = g; pendingB = b;
    comandoPendiente = true;
    Serial.println("[POD PERIFÉRICO] Sensor en 1 (HIGH). Esperando liberación (0)...");
  } else {
    // Si está en 0, enciende inmediatamente
    comandoPendiente = false;
    encenderLEDs(r, g, b);
    startTime = millis();
    esperandoSensor = true;
    Serial.println("[POD PERIFÉRICO] Sensor en 0 (LOW). LEDs encendidos, esperando reacción...");
  }
}

// Callbacks para recepción de comandos desde Central / App (EMPEZAR:R,G,B)
class MyCallbacks: public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *pCharacteristic) {
      String rxValue = pCharacteristic->getValue().c_str();
      if (rxValue.startsWith("EMPEZAR:")) {
        String parametros = rxValue.substring(8);
        int c1 = parametros.indexOf(',');
        int c2 = parametros.indexOf(',', c1 + 1);

        if (c1 != -1 && c2 != -1) {
          int r = parametros.substring(0, c1).toInt();
          int g = parametros.substring(c1 + 1, c2).toInt();
          int b = parametros.substring(c2 + 1).toInt();
          solicitarEncendido((uint8_t)r, (uint8_t)g, (uint8_t)b);
        }
      }
    }
};

// Callbacks para gestión de conexión BLE
class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
      Serial.println("[POD PERIFÉRICO] Dispositivo conectado vía BLE.");
    };

    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
      esperandoSensor = false;
      comandoPendiente = false;
      apagarLEDs();
      Serial.println("[POD PERIFÉRICO] Desconectado. Reiniciando publicidad BLE...");
      pServer->getAdvertising()->start();
    }
};

void setup() {
  Serial.begin(115200);

  // Inicialización de Hardware
  strip.begin();
  strip.setBrightness(128);
  apagarLEDs();

  pinMode(PIN_RCWL, INPUT);

  // Inicialización de BLE
  BLEDevice::init("ACTIVELO_POD_1");
  
  // Reducción de potencia BLE para minimizar interferencia RF sobre el sensor RCWL
  esp_ble_tx_power_set(ESP_BLE_PWR_TYPE_DEFAULT, ESP_PWR_LVL_N12);

  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  BLEService *pService = pServer->createService(SERVICE_UUID);

  // Característica TX (Notificación hacia el Master/App: REACCION:ms)
  pTxCharacteristic = pService->createCharacteristic(
                        CHARACTERISTIC_UUID_TX,
                        BLECharacteristic::PROPERTY_NOTIFY
                      );
  pTxCharacteristic->addDescriptor(new BLE2902());

  // Característica RX (Escritura desde Master/App: EMPEZAR:R,G,B)
  BLECharacteristic *pRxCharacteristic = pService->createCharacteristic(
                                           CHARACTERISTIC_UUID_RX,
                                           BLECharacteristic::PROPERTY_WRITE
                                         );
  pRxCharacteristic->setCallbacks(new MyCallbacks());

  pService->start();

  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);
  pAdvertising->setMinPreferred(0x12);
  BLEDevice::startAdvertising();

  Serial.println("[POD PERIFÉRICO] Listo en GPIO 7 (24 LEDs) y GPIO 2 (Radar).");
}

void loop() {
  // 1. APAGADO INSTANTÁNEO: Al primer 1 del sensor apaga los LEDs y transmite la medición
  if (esperandoSensor && digitalRead(PIN_RCWL) == HIGH) {
    unsigned long reactionTime = millis() - startTime;
    esperandoSensor = false;
    apagarLEDs();

    Serial.print("[POD PERIFÉRICO] Reacción registrada: ");
    Serial.print(reactionTime);
    Serial.println(" ms");

    if (deviceConnected && pTxCharacteristic != NULL) {
      String mensaje = "REACCION:" + String(reactionTime);
      pTxCharacteristic->setValue(mensaje.c_str());
      pTxCharacteristic->notify();
    }
  }

  // 2. DESBLOQUEO DE NUEVA RONDA: Solo enciende cuando el RCWL retorne a 0
  if (comandoPendiente && digitalRead(PIN_RCWL) == LOW) {
    comandoPendiente = false;
    encenderLEDs(pendingR, pendingG, pendingB);
    startTime = millis();
    esperandoSensor = true;
    Serial.println("[POD PERIFÉRICO] Sensor liberado a 0. LEDs encendidos para la nueva ronda.");
  }

  delay(1);
}