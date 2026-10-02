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

// Control para no saturar el Monitor Serial
unsigned long tiempoAnteriorSerial = 0;
const unsigned long intervaloSerial = 200; // Imprime cada 200 ms


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
  // Inicialización del Monitor Serial a 9600 baudios
  Serial.begin(9600);

  tira.begin();
  tira.setBrightness(200);

  pinMode(SENSOR_PIN, INPUT);

  // Arrancamos con rojo
  encenderColor(255, 0, 0);

  Serial.println("--- Sistema Iniciado ---");
}


void loop() {
  unsigned long tiempoActual = millis();

  bool movimiento = digitalRead(SENSOR_PIN);

  // Imprime el valor actual que mide el sensor en el pin 4 (0 o 1) cada 200 ms
  if (tiempoActual - tiempoAnteriorSerial >= intervaloSerial) {
    tiempoAnteriorSerial = tiempoActual;
    Serial.print("Lectura Sensor PIN 4: ");
    Serial.println(movimiento); // 1 = HIGH, 0 = LOW
  }

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
        Serial.println(">>> DETECCIÓN: Tira encendida");
      }
      else {
        // Apagar
        apagarLeds();
        Serial.println(">>> DETECCIÓN: Tira apagada");
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