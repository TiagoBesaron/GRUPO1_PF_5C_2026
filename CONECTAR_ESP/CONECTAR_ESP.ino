#include <WiFi.h>
#include <esp_now.h>

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

void OnDataSent(const wifi_tx_info_t *info, esp_now_send_status_t status)
{
  Serial.print("Last Packet Send Status: ");
  Serial.println(status == ESP_NOW_SEND_SUCCESS ? "Delivery Success" : "Delivery Fail");
}

void SendMessage()
{
  String payload = "Hola Eze";

  esp_err_t result = esp_now_send(
    MAC_RECEIVER_1,
    (uint8_t *)payload.c_str(),
    payload.length()
  );

  if (result == ESP_OK)
  {
    Serial.println("Sent with success");
  }
  else
  {
    Serial.println("Error sending the data");
  }
}

void RegisterPeeks()
{
  esp_now_peer_info_t peerInfo = {};
  memcpy(peerInfo.peer_addr, MAC_RECEIVER_1, 6);
  peerInfo.channel = 0;
  peerInfo.encrypt = false;

  if (esp_now_add_peer(&peerInfo) != ESP_OK)
  {
    Serial.println("Failed to add peer");
  }
  else
  {
    Serial.println("Registered peer");
  }
}

void InitEspNow()
{
  if (esp_now_init() != ESP_OK)
  {
    Serial.println("Error initializing ESP-NOW");
    return;
  }

  esp_now_register_send_cb(OnDataSent);

  RegisterPeeks();
}

void setup()
{
  Serial.begin(115200);
  delay(2000);

  WiFi.mode(WIFI_STA);

  InitEspNow();
}

void loop()
{
  SendMessage();
  delay(2000);
}