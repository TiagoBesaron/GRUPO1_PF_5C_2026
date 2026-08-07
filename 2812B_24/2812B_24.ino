#include <Adafruit_NeoPixel.h>

#define PIN 21
#define NUMPIXELS 24

Adafruit_NeoPixel tira(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

void setup() {
  tira.begin();
}

void loop() {
  for (int i = 0; i < NUMPIXELS; i++) {
    tira.setPixelColor(i, tira.Color(255, 0, 0));
  }
  tira.show();
  delay(1000);

  for (int i = 0; i < NUMPIXELS; i++) {
    tira.setPixelColor(i, tira.Color(0, 255, 0));
  }
  tira.show();
  delay(1000);

  for (int i = 0; i < NUMPIXELS; i++) {
    tira.setPixelColor(i, tira.Color(0, 0, 255));
  }
  tira.show();
  delay(1000);
}
