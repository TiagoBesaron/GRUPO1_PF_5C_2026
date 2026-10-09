#include <Adafruit_NeoPixel.h>

#define PIN 7
#define NUMPIXELS 24
#define SENSOR_PIN 2 // Pin 2 con interrupción física (INT0)

Adafruit_NeoPixel tira(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

// Control de colores
unsigned long tiempoAnterior = 0;
const unsigned long intervaloColor = 1000;
int colorActual = 0;

// Estado de la tira
bool tiraEncendida = false;

// Variable de interrupción para registrar cambios en el sensor
volatile bool cambioEstadoSensor = false;

// Control para Monitor Serial
unsigned long tiempoAnteriorSerial = 0;
const unsigned long intervaloSerial = 200;

// Rutina de Servicio de Interrupción (ISR)
void ISR_sensor() {
  cambioEstadoSensor = true;
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
  if (colorActual == 0) {
    encenderColor(255, 0, 0); // Rojo
  } else if (colorActual == 1) {
    encenderColor(0, 255, 0); // Verde
  } else if (colorActual == 2) {
    encenderColor(0, 0, 255); // Azul
  }

  colorActual = (colorActual + 1) % 3;
}

void setup() {
  Serial.begin(9600);

  tira.begin();
  tira.setBrightness(200);

  pinMode(SENSOR_PIN, INPUT);

  // Se activa la interrupción ante CUALQUIER cambio de estado (HIGH a LOW o LOW a HIGH)
  attachInterrupt(digitalPinToInterrupt(SENSOR_PIN), ISR_sensor, CHANGE);

  // Verificar estado inicial del sensor al arrancar
  if (digitalRead(SENSOR_PIN) == HIGH) {
    tiraEncendida = true;
    cambiarColor();
  } else {
    tiraEncendida = false;
    apagarLeds();
  }

  Serial.println("--- Sistema Iniciado por Detección Directa ---");
}

void loop() {
  unsigned long tiempoActual = millis();

  // 1. Procesar cambio detectado por el sensor
  if (cambioEstadoSensor) {
    cambioEstadoSensor = false; // Reiniciar bandera
    bool estadoSensor = digitalRead(SENSOR_PIN);

    if (estadoSensor == HIGH && !tiraEncendida) {
      tiraEncendida = true;
      cambiarColor();
      Serial.println(">>> MOVIMIENTO/PRESENCIA DETECTADA: Tira encendida");
    } else if (estadoSensor == LOW && tiraEncendida) {
      tiraEncendida = false;
      apagarLeds();
      Serial.println(">>> SIN DETECCIÓN: Tira apagada");
    }
  }

  // 2. Monitoreo periódico para el Monitor Serial
  if (tiempoActual - tiempoAnteriorSerial >= intervaloSerial) {
    tiempoAnteriorSerial = tiempoActual;
    Serial.print("Lectura Sensor PIN 2: ");
    Serial.println(digitalRead(SENSOR_PIN));
  }

  // 3. Cambio periódico de color únicamente mientras se mantenga la detección
  if (tiraEncendida) {
    if (tiempoActual - tiempoAnterior >= intervaloColor) {
      tiempoAnterior = tiempoActual;
      cambiarColor();
    }
  }
}