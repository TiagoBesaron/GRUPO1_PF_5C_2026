// El LED interno del ESP32-C3 SuperMini está en el pin 8
const int LED_PIN = 8; 

void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);
}

void loop() {
  Serial.println("LED Encendido");
  digitalWrite(LED_PIN, LOW);   
  delay(1000);              

  Serial.println("LED Apagado");
  digitalWrite(LED_PIN, HIGH);  
  delay(1000);                 
}
