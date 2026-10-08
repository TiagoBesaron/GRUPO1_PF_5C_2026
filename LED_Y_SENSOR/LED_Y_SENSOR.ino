#include <Adafruit_NeoPixel.h>

#define PIN 7
#define NUMPIXELS 24
#define SENSOR_PIN 2 // El Pin 2 cuenta con interrupción física (INT0)

Adafruit_NeoPixel tira(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

// Control de colores
unsigned long tiempoAnterior = 0;
const unsigned long intervaloColor = 1000;
int colorActual = 0;

// Estado de la tira
bool tiraEncendida = true;

// Variables de interrupción (deben declararse como volatile)
volatile bool movimientoDetectado = false;
unsigned long ultimoMovimiento = 0;
const unsigned long tiempoAntirrebote = 150; // Pequeño margen para filtrar ruido eléctrico

// Control para Monitor Serial
unsigned long tiempoAnteriorSerial = 0;
const unsigned long intervaloSerial = 200;

// Rutina de Servicio de Interrupción (ISR)
void ISR_sensor() {
  movimientoDetectado = true;
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

  // Adjuntamos la interrupción por hardware en flanco de subida (LOW a HIGH)
  attachInterrupt(digitalPinToInterrupt(SENSOR_PIN), ISR_sensor, RISING);

  // Arrancamos con rojo
  encenderColor(255, 0, 0);

  Serial.println("--- Sistema Iniciado con Interrupciones en Tiempo Real ---");
}

void loop() {
  unsigned long tiempoActual = millis();

  // 1. Procesamiento inmediato si ocurrió un pulso en el sensor
  if (movimientoDetectado) {
    movimientoDetectado = false; // Reiniciar bandera

    // Antirrebote para evitar falsos disparos consecutivos
    if (tiempoActual - ultimoMovimiento >= tiempoAntirrebote) {
      ultimoMovimiento = tiempoActual;

      // Cambiar estado de la tira
      tiraEncendida = !tiraEncendida;

      if (tiraEncendida) {
        cambiarColor();
        Serial.println(">>> DETECCIÓN EN TIEMPO REAL: Tira encendida");
      } else {
        apagarLeds();
        Serial.println(">>> DETECCIÓN EN TIEMPO REAL: Tira apagada");
      }
    }
  }

  // 2. Monitoreo continuo del sensor para el Monitor Serial
  if (tiempoActual - tiempoAnteriorSerial >= intervaloSerial) {
    tiempoAnteriorSerial = tiempoActual;
    Serial.print("Lectura Sensor PIN 2: ");
    Serial.println(digitalRead(SENSOR_PIN));
  }

  // 3. Cambio periódico de color si la tira está encendida
  if (tiraEncendida) {
    if (tiempoActual - tiempoAnterior >= intervaloColor) {
      tiempoAnterior = tiempoActual;
      cambiarColor();
    }
  }
}