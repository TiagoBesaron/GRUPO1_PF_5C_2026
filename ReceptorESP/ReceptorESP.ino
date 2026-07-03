#include <esp_now.h>   // Librería para comunicación ESP-NOW
#include <WiFi.h>      // Librería para configurar el WiFi del ESP32


// Dirección MAC del primer emisor
const uint8_t MAC_SENDER_1[] = {
  0xE0, 0x72, 0xA1, 0x72, 0xDA, 0x54
};

// Dirección MAC del segundo emisor
const uint8_t MAC_SENDER_2[] = {
  0xE0, 0x72, 0xA1, 0x71, 0x00, 0xBC
};

// Dirección MAC del receptor
const uint8_t MAC_RECEIVER_1[] = {
  0xE0, 0x72, 0xA1, 0x72, 0xD8, 0xBC
};


// Lista de dispositivos que actuarán como emisores.
// En este caso solo se agrega el receptor.
const uint8_t *SENDERS_MACS[] = { MAC_RECEIVER_1 };

// Cantidad de emisores
const uint8_t SENDERS_COUNT = sizeof(SENDERS_MACS) / sizeof(uint8_t *);


// Lista de receptores (los dos ESP32 emisores)
const uint8_t *RECEIVERS_MACS[] = { MAC_SENDER_1, MAC_SENDER_2 };

// Cantidad de receptores
const uint8_t RECEIVERS_COUNT = sizeof(RECEIVERS_MACS) / sizeof(uint8_t *);


// Función que se ejecuta automáticamente cada vez que llega un mensaje
void OnMessageReceived(const esp_now_recv_info_t *info, const uint8_t *data, int len) {

  // Obtiene la MAC del dispositivo que envió el mensaje
  const uint8_t *mac = info->src_addr;

  // Muestra la dirección MAC del emisor
  Serial.printf("Packet received from: %02X:%02X:%02X:%02X:%02X:%02X\n",
                mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);

  // Muestra la cantidad de bytes recibidos
  Serial.printf("Bytes received: %d\n", len);

  // Variable para almacenar el mensaje recibido
  String payload;

  // Reserva memoria para mejorar el rendimiento
  payload.reserve(len);

  // Convierte los bytes recibidos en una cadena de texto
  for (int i = 0; i < len; i++) {
    payload += (char)data[i];
  }

  // Imprime el mensaje recibido
  Serial.print("Mensaje: ");
  Serial.println(payload);
}


// Inicializa ESP-NOW
void InitEspNow() {

  // Verifica que ESP-NOW se inicialice correctamente
  if (esp_now_init() != ESP_OK) {
    Serial.println("Error initializing ESP-NOW");
    return;
  }

  // Registra la función que atenderá los mensajes recibidos
  esp_now_register_recv_cb(OnMessageReceived);
}


void setup() {

  // Inicia el monitor serie
  Serial.begin(9600);

  // Configura el ESP32 en modo estación
  WiFi.mode(WIFI_STA);

  // Inicializa ESP-NOW
  InitEspNow();
}


void loop() {
  // No se necesita código aquí porque la recepción
  // de mensajes ocurre mediante interrupciones (callback).
}