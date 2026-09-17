#include <WiFi.h>
#include <esp_now.h>
#include <Adafruit_NeoPixel.h>

// Tira led
#define PIN 21
#define NUMPIXELS 24

Adafruit_NeoPixel tira(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

// MAC de este ESP32
const uint8_t MAC_SENDER_1[] = {
  0xE0, 0x72, 0xA1, 0x70, 0xCD, 0x0C
};

// MAC del ESP32 central
const uint8_t MAC_RECEIVER_1[] = {
  0xE0, 0x72, 0xA1, 0x72, 0xD8, 0xBC
};

bool tiraEncendida = false;

unsigned long tiempoInicioTira = 0;

const unsigned long tiempoTira = 2000;


// Se ejecuta cuando termina un envío
void OnDataSent(
  const wifi_tx_info_t *info,
  esp_now_send_status_t status)
{
  Serial.print("Last Packet Send Status: ");

  Serial.println(
    status == ESP_NOW_SEND_SUCCESS
      ? "Delivery Success"
      : "Delivery Fail"
  );
}


// Recibe los mensajes del central
void OnDataRecv(
  const esp_now_recv_info_t *recv_info,
  const uint8_t *incomingData,
  int len)
{
  String mensaje;

  for (int i = 0; i < len; i++)
  {
    mensaje += (char)incomingData[i];
  }

  Serial.print("Mensaje Recibido: ");
  Serial.println(mensaje);

  if (mensaje == "EMPEZAR" && !tiraEncendida)
  {
    Serial.println("Comenzando...");

    for (int i = 0; i < NUMPIXELS; i++)
    {
      tira.setPixelColor(
        i,
        tira.Color(255, 0, 0)
      );
    }

    tira.show();

    tiraEncendida = true;
    tiempoInicioTira = millis();
  }
}


// Envía al central el aviso de que terminó
void SendFinished()
{
  String payload = "TERMINADO";

  esp_err_t result = esp_now_send(
    MAC_RECEIVER_1,
    (uint8_t *)payload.c_str(),
    payload.length()
  );

  if (result == ESP_OK)
  {
    Serial.println("Terminado enviado");
  }
  else
  {
    Serial.println("Error enviando terminado");
  }
}


// Controla cuánto tiempo queda prendida la tira
void controlarTira()
{
  if (tiraEncendida)
  {
    unsigned long tiempoActual = millis();

    if (tiempoActual - tiempoInicioTira >= tiempoTira)
    {
      tira.clear();
      tira.show();

      tiraEncendida = false;

      Serial.println("Tira apagada");

      SendFinished();
    }
  }
}


// Registra al central
void RegisterPeeks()
{
  esp_now_peer_info_t peerInfo = {};

  memcpy(
    peerInfo.peer_addr,
    MAC_RECEIVER_1,
    6
  );

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


// Inicializa ESP-NOW
void InitEspNow()
{
  if (esp_now_init() != ESP_OK)
  {
    Serial.println("Error initializing ESP-NOW");
    return;
  }

  esp_now_register_send_cb(OnDataSent);

  esp_now_register_recv_cb(OnDataRecv);

  RegisterPeeks();
}


void setup()
{
  Serial.begin(9600);

  tira.begin();
  tira.setBrightness(200);
  tira.clear();
  tira.show();

  WiFi.mode(WIFI_STA);

  InitEspNow();
}


void loop()
{
  controlarTira();
}