#include <WiFi.h>

unsigned long tiempoAnterior = 0;
const unsigned long intervalo = 1000;

void setup() {
  Serial.begin(9600);
  WiFi.mode(WIFI_MODE_STA);

  while (!Serial) {
    delay(10);
  }

  String mac = WiFi.macAddress();

  Serial.println("Verificacion de la MAC");
  Serial.print("MAC: ");
  Serial.println(mac);

  // Verificar longitud
  if (mac.length() == 17) {
    Serial.println("Longitud correcta");
  } else {
    Serial.println("Longitud incorrecta");
  }

  // Verificar fabricante
  if (mac.startsWith("E0:72:A1")) {
    Serial.println("La direccion MAC pertenece a Espressif Inc");
  } else {
    Serial.println("La direccion MAC no pertenece al bloque E0:72:A1");
  }
}

void loop() {
  if (millis() - tiempoAnterior >= intervalo) {
    tiempoAnterior = millis();
    Serial.println(WiFi.macAddress());
  }
}