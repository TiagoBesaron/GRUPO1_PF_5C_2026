#include <esp_now.h>
#include <WiFi.h>
#include <Adafruit_NeoPixel.h>

const uint8_t MAC_SENDER_1[] = {
  0xE0, 0x72, 0xA1, 0x72, 0xDA, 0x54
};

const uint8_t MAC_RECEIVER_1[] = {
  0xE0, 0x72, 0xA1, 0x72, 0xD8, 0xBC
};

const uint8_t* SENDERS_MACS[] = { MAC_RECEIVER_1 };
const uint8_t SENDERS_COUNT = sizeof(SENDERS_MACS) / sizeof(uint8_t*);

const uint8_t* RECEIVERS_MACS[] = { MAC_SENDER_1 };
const uint8_t RECEIVERS_COUNT = sizeof(RECEIVERS_MACS) / sizeof(uint8_t*);

// ====== CONFIGURACIÓN DE LA TIRA ======
#define LED_PIN 5       // Cambiar por el GPIO donde conectaste DATA
#define NUMPIXELS 16     // Cambiar por la cantidad de LEDs

Adafruit_NeoPixel pixels(NUMPIXELS, LED_PIN, NEO_GRB + NEO_KHZ800);

// ======================================

void OnMessageReceived(const esp_now_recv_info_t *info, const uint8_t *data, int len)
{
  const uint8_t *mac = info->src_addr;

  Serial.printf("Packet received from: %02X:%02X:%02X:%02X:%02X:%02X\n",
                mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);

  Serial.printf("Bytes received: %d\n", len);

  String payload;

  for (int i = 0; i < len; i++)
  {
    payload += (char)data[i];
  }

  Serial.print("Mensaje: ");
  Serial.println(payload);

  // Encender todos los NeoPixels en verde
  for (int i = 0; i < NUMPIXELS; i++)
  {
    pixels.setPixelColor(i, pixels.Color(0, 255, 0));
  }

  pixels.show();

  delay(1000);

  // Apagar la tira
  pixels.clear();
  pixels.show();
}

void InitEspNow()
{
  if (esp_now_init() != ESP_OK)
  {
    Serial.println("Error initializing ESP-NOW");
    return;
  }

  esp_now_register_recv_cb(OnMessageReceived);
}

void setup()
{
  Serial.begin(115200);

  pixels.begin();
  pixels.clear();
  pixels.show();

  WiFi.mode(WIFI_STA);

  InitEspNow();
}

void loop()
{
}