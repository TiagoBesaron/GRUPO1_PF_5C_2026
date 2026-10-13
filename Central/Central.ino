#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <Adafruit_NeoPixel.h>
#include <esp_bt.h>

// --- CONFIGURACIÓN HARDWARE CENTRAL ---
#define PIN_NEOPIXEL   7    // GPIO 7 para tira NeoPixel
#define NUM_PIXELS     24   // 24 NeoPixels
#define PIN_RCWL       2    // GPIO 2 para sensor RCWL-0516

Adafruit_NeoPixel strip(NUM_PIXELS, PIN_NEOPIXEL, NEO_GRB + NEO_KHZ800);

// --- UUIDs PROYECTO ACTIVELO ---
#define SERVICE_UUID           "4fa8691a-0393-40a3-974f-0759e09f114d"
#define CHARACTERISTIC_UUID_RX "87b54dba-055b-4321-8525-2b2a239385c7"
#define CHARACTERISTIC_UUID_TX "d7b54dba-055b-4321-8525-2b2a239385c8"

BLEServer* pServer = NULL;
BLECharacteristic* pTxCharacteristic = NULL;

// Variable de control de conexión de la App
bool appConectada = false;

// Estados del sensor y encendido local
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
  if (!appConectada) return; // Si la app no está conectada, no enciende
  
  if (digitalRead(PIN_RCWL) == HIGH) {
    // Si el RCWL está retenido en 1, guarda la orden para cuando baje a 0
    pendingR = r; pendingG = g; pendingB = b;
    comandoPendienteLocal = true;
    Serial.println("[CENTRAL] Sensor en 1 (HIGH). Esperando liberación (0)...");
  } else {
    // Si está en 0, enciende inmediatamente
    comandoPendienteLocal = false;
    encenderLEDsLocales(r, g, b);
    startTimeLocal = millis();
    esperandoSensorLocal = true;
    Serial.println("[CENTRAL] Sensor en 0 (LOW). LEDs encendidos, esperando reacción...");
  }
}

// Callbacks de conexión/desconexión de la App
class ServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      appConectada = true;
      Serial.println("[CENTRAL] ¡App conectada por BLE! Listo para recibir órdenes de entrenamiento.");
    }

    void onDisconnect(BLEServer* pServer) {
      appConectada = false;
      esperandoSensorLocal = false;
      comandoPendienteLocal = false;
      apagarLEDsLocales();
      Serial.println("[CENTRAL] App desconectada. Apagando todo y esperando nueva conexión...");
      pServer->getAdvertising()->start(); // Reinicia la visibilidad BLE
    }
};

// Callback para recepción de comandos desde la App (EMPEZAR:R,G,B)
class CharacteristicCallbacks: public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *pCharacteristic) {
      if (!appConectada) return;

      String rxValue = pCharacteristic->getValue().c_str();
      Serial.print("[CENTRAL] Orden recibida de la App: ");
      Serial.println(rxValue);

      if (rxValue.startsWith("EMPEZAR:")) {
        String parametros = rxValue.substring(8);
        int c1 = parametros.indexOf(',');
        int c2 = parametros.indexOf(',', c1 + 1);

        if (c1 != -1 && c2 != -1) {
          int r = parametros.substring(0, c1).toInt();
          int g = parametros.substring(c1 + 1, c2).toInt();
          int b = parametros.substring(c2 + 1).toInt();
          solicitarEncendidoLocal((uint8_t)r, (uint8_t)g, (uint8_t)b);
        }
      }
    }
};

void setup() {
  Serial.begin(115200);

  // Inicialización Hardware
  strip.begin();
  strip.setBrightness(128);
  apagarLEDsLocales();

  pinMode(PIN_RCWL, INPUT);

  // Inicialización BLE
  BLEDevice::init("ACTIVELO_CENTRAL");
  esp_ble_tx_power_set(ESP_BLE_PWR_TYPE_DEFAULT, ESP_PWR_LVL_N12); // Reducción de potencia para filtrar interferencias RF

  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new ServerCallbacks());

  BLEService *pService = pServer->createService(SERVICE_UUID);

  // Característica TX (Envía notificaciones REACCION:ms a la App)
  pTxCharacteristic = pService->createCharacteristic(
                        CHARACTERISTIC_UUID_TX,
                        BLECharacteristic::PROPERTY_NOTIFY
                      );
  pTxCharacteristic->addDescriptor(new BLE2902());

  // Característica RX (Recibe comandos EMPEZAR:R,G,B desde la App)
  BLECharacteristic *pRxCharacteristic = pService->createCharacteristic(
                                           CHARACTERISTIC_UUID_RX,
                                           BLECharacteristic::PROPERTY_WRITE
                                         );
  pRxCharacteristic->setCallbacks(new CharacteristicCallbacks());

  pService->start();

  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);
  pAdvertising->setMinPreferred(0x12);
  BLEDevice::startAdvertising();

  Serial.println("[CENTRAL] Sistema iniciado. Esperando conexión con la app móvil...");
}

void loop() {
  // --- SI NO HAY APP CONECTADA: NO HACE NADA Y MANTIENE TODO APAGADO ---
  if (!appConectada) {
    delay(10);
    return;
  }

  // 1. APAGADO INSTANTÁNEO: Al primer 1 del sensor apaga los LEDs y manda la medición a Firebase vía la App
  if (esperandoSensorLocal && digitalRead(PIN_RCWL) == HIGH) {
    unsigned long reactionTime = millis() - startTimeLocal;
    esperandoSensorLocal = false;
    apagarLEDsLocales(); // Apagado inmediato

    Serial.print("[CENTRAL] Reacción registrada: ");
    Serial.print(reactionTime);
    Serial.println(" ms");

    if (pTxCharacteristic != NULL) {
      String mensaje = "REACCION:" + String(reactionTime);
      pTxCharacteristic->setValue(mensaje.c_str());
      pTxCharacteristic->notify();
    }
  }

  // 2. DESBLOQUEO DE NUEVA RONDA: Solo enciende si la app envió orden Y el sensor bajó a 0
  if (comandoPendienteLocal && digitalRead(PIN_RCWL) == LOW) {
    comandoPendienteLocal = false;
    encenderLEDsLocales(pendingR, pendingG, pendingB);
    startTimeLocal = millis();
    esperandoSensorLocal = true;
    Serial.println("[CENTRAL] Sensor liberado a 0. LEDs encendidos para la nueva ronda.");
  }

  delay(1);
}