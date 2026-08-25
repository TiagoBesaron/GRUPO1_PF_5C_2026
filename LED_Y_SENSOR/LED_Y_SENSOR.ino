#include <Adafruit_NeoPixel.h>

#define PIN 21
#define NUMPIXELS 24

#define SENSOR_PIN 4

Adafruit_NeoPixel tira(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

// Control de colores
unsigned long tiempoAnterior = 0;
const unsigned long intervaloColor = 1000;

int colorActual = 0;

// Estado de la tira
bool tiraEncendida = true;

// Control del sensor
bool movimientoAnterior = LOW;
unsigned long ultimoMovimiento = 0;

const unsigned long tiempoAntirrebote = 500;


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
    // Rojo
    encenderColor(255, 0, 0);
  }

  else if (colorActual == 1) {
    // Verde
    encenderColor(0, 255, 0);
  }

  else if (colorActual == 2) {
    // Azul
    encenderColor(0, 0, 255);
  }

  colorActual++;

  if (colorActual > 2) {
    colorActual = 0;
  }
}


void setup() {

  tira.begin();
  tira.setBrightness(200);

  pinMode(SENSOR_PIN, INPUT);

  // Arrancamos con rojo
  encenderColor(255, 0, 0);
}


void loop() {

  unsigned long tiempoActual = millis();

  bool movimiento = digitalRead(SENSOR_PIN);

  // Detectamos solamente el momento en que pasa de LOW -> HIGH
  if (movimiento == HIGH && movimientoAnterior == LOW) {

    // Antirrebote / evitar múltiples detecciones
    if (tiempoActual - ultimoMovimiento > tiempoAntirrebote) {

      ultimoMovimiento = tiempoActual;

      // Cambiar estado de la tira
      tiraEncendida = !tiraEncendida;

      if (tiraEncendida) {
        // Volver a encender
        cambiarColor();
      }
      else {
        // Apagar
        apagarLeds();
      }
    }
  }

  movimientoAnterior = movimiento;


  if (tiraEncendida) {

    if (tiempoActual - tiempoAnterior >= intervaloColor) {

      tiempoAnterior = tiempoActual;

      cambiarColor();
    }
  }
}