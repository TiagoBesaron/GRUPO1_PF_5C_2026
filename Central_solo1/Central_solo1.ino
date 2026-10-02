#include <Arduino.h>
#include <WiFi.h>
#include <Firebase_ESP_Client.h>
#include <Adafruit_NeoPixel.h>

// Librerías auxiliares de Firebase
#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"

#define WIFI_SSID "MECA-IoT"
#define WIFI_PASSWORD "IoT$2027"

#define API_KEY "AIzaSyB1vdZWLxmgbU74BZwmHlV9ll1zAFuy1Sk"
#define DATABASE_URL "https://g1-pf-5c-2026-default-rtdb.firebaseio.com"
#define USER_EMAIL "esp32@ledtrainer.com.ar"
#define USER_PASSWORD "G1-PF-5C-2026"
// --- CONFIGURACIÓN SENSOR RADAR RCWL-0516 ---
#define RCWL_PIN 4  // Pin digital conectado a OUT del RCWL-0516

// --- CONFIGURACIÓN DEL ANILLO LED (WS2812B / NeoPixel) ---
#define LED_RING_PIN 18  // Pin GPIO conectado al DIN del anillo LED
#define NUM_LEDS 24      // Cantidad de LEDs en tu anillo
Adafruit_NeoPixel strip(NUM_LEDS, LED_RING_PIN, NEO_GRB + NEO_KHZ800);

// --- OBJETOS FIREBASE ---
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

int ultimoEstadoMovimiento = -1;

void encenderColor(uint8_t r, uint8_t g, uint8_t b) {
  for (int i = 0; i < NUM_LEDS; i++) {
    strip.setPixelColor(i, strip.Color(r, g, b));
  }
  strip.show();
}

void setup() {
  Serial.begin(115200);

  // Configurar pin del sensor
  pinMode(RCWL_PIN, INPUT);

  // Inicializar anillo LED
  strip.begin();
  strip.show();             // Apaga los LEDs al iniciar
  strip.setBrightness(50);  // Brillo general (0 a 255)

  // Conexión WiFi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Conectando a WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(400);
  }
  Serial.println("\n¡Conectado a WiFi!");

  // Configuración de Firebase
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;

  if (Firebase.signUp(&config, &auth, "", "")) {
    Serial.println("Autenticación Firebase OK");
  } else {
    Serial.printf("Error Firebase: %s\n", config.signer.signupError.message.c_str());
  }

  config.token_status_callback = tokenStatusCallback;
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

void loop() {
  // 1. LEER RCWL-0516 Y ACTUALIZAR FIREBASE AL DETECTAR CAMBIO DE ESTADO
  int estadoMovimiento = digitalRead(RCWL_PIN);

  if (estadoMovimiento != ultimoEstadoMovimiento) {
    ultimoEstadoMovimiento = estadoMovimiento;

    if (Firebase.ready()) {
      bool hayMovimiento = (estadoMovimiento == HIGH);

      if (hayMovimiento) {
        Serial.println("¡Movimiento detectado!");
      } else {
        Serial.println("Sin movimiento");
      }

      // Actualizar estado en Firebase (/sensor/movimiento = true / false)
      Firebase.RTDB.setBool(&fbdo, "/sensor/movimiento", hayMovimiento);
    }
  }

  // 2. LEER ESTADO DESDE FIREBASE PARA EL ANILLO LED
  if (Firebase.ready()) {
    if (Firebase.RTDB.getString(&fbdo, "/anillo/estado")) {
      String orden = fbdo.stringData();

      if (orden == "rojo") {
        encenderColor(255, 0, 0);
      } else if (orden == "verde") {
        encenderColor(0, 255, 0);
      } else if (orden == "azul") {
        encenderColor(0, 0, 255);
      } else if (orden == "alerta") {
        // Parpadeo de alerta
        encenderColor(255, 0, 0);
        delay(150);
        encenderColor(0, 0, 0);
        delay(150);
      } else if (orden == "apagado") {
        encenderColor(0, 0, 0);
      }
    }
  }
}