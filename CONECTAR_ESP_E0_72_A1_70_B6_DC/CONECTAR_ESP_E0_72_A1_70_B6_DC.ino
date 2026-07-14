#include <WiFi.h>      // Librería para utilizar el WiFi del ESP32
#include <esp_now.h>   // Librería para utilizar el protocolo ESP-NOW

// Dirección MAC de este ESP32 
const uint8_t MAC_SENDER_1[] = {
  0xE0, 0x72, 0xA1, 0x70, 0xB6, 0xDC
};

// Dirección MAC del ESP32 al que se enviarán los datos
const uint8_t MAC_RECEIVER_1[] = {
  0xE0, 0x72, 0xA1, 0x72, 0xD8, 0xBC
};

// Variable que guarda el instante del último envío
unsigned long previousMillis = 0;

// Tiempo entre envíos (2000 ms = 2 segundos)
const unsigned long interval = 2000;

// Callback que se ejecuta cuando finaliza un envío
void OnDataSent(const wifi_tx_info_t *info, esp_now_send_status_t status)
{
  Serial.print("Last Packet Send Status: ");

  // Indica si el mensaje llegó correctamente al receptor
  Serial.println(status == ESP_NOW_SEND_SUCCESS ? "Delivery Success" : "Delivery Fail");
}

// Función encargada de enviar un mensaje
void SendMessage()
{
  // Mensaje que será enviado
  String payload = "Hola Rúben";

  // Envía el mensaje al ESP32 cuya MAC es MAC_RECEIVER_1
  esp_err_t result = esp_now_send(
    MAC_RECEIVER_1,
    (uint8_t *)payload.c_str(),
    payload.length()
  );

  // Verifica si el envío pudo iniciarse correctamente
  if (result == ESP_OK)
  {
    Serial.println("Sent with success");
  }
  else
  {
    Serial.println("Error sending the data");
  }
}

// Registra el dispositivo receptor como "peer"
void RegisterPeeks()
{
  // Estructura con la información del peer
  esp_now_peer_info_t peerInfo = {};

  // Copia la dirección MAC del receptor
  memcpy(peerInfo.peer_addr, MAC_RECEIVER_1, 6);

  // Canal 0 = utiliza el canal actual del WiFi
  peerInfo.channel = 0;

  // Sin cifrado
  peerInfo.encrypt = false;

  // Agrega el peer a la lista de dispositivos permitidos
  if (esp_now_add_peer(&peerInfo) != ESP_OK)
  {
    Serial.println("Failed to add peer");
  }
  else
  {
    Serial.println("Registered peer");
  }
}

// Inicializa el protocolo ESP-NOW
void InitEspNow()
{
  // Inicializa ESP-NOW
  if (esp_now_init() != ESP_OK)
  {
    Serial.println("Error initializing ESP-NOW");
    return;
  }

  // Registra la función callback que informa el estado del envío
  esp_now_register_send_cb(OnDataSent);

  // Registra el receptor
  RegisterPeeks();
}

void setup()
{
  // Inicializa el monitor serie
  Serial.begin(9600);

  // Coloca el ESP32 en modo estación
  WiFi.mode(WIFI_STA);

  // Inicializa ESP-NOW
  InitEspNow();
}

void loop()
{
  // Obtiene el tiempo transcurrido desde que el ESP32 se encendió
  unsigned long currentMillis = millis();

  // Comprueba si pasaron 2 segundos desde el último envío
  if (currentMillis - previousMillis >= interval)
  {
    // Actualiza el instante del último envío
    previousMillis = currentMillis;

    // Envía el mensaje
    SendMessage();
  }

  // El programa sigue ejecutándose sin bloquearse,
  // permitiendo realizar otras tareas mientras espera.
}