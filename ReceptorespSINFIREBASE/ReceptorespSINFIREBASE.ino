#include <esp_now.h>
#include <WiFi.h>
#include <Adafruit_NeoPixel.h>

#define PIN 21
#define NUMPIXELS 24

Adafruit_NeoPixel tira(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

// MAC del primer periférico
const uint8_t MAC_SENDER_1[] = {
  0xE0, 0x72, 0xA1, 0x72, 0xDA, 0x54
};

// MAC del segundo periférico
const uint8_t MAC_SENDER_2[] = {
  0xE0, 0x72, 0xA1, 0x71, 0x00, 0xBC
};

// MAC del tercer periférico
const uint8_t MAC_SENDER_3[] = {
  0xE0, 0x72, 0xA1, 0x70, 0xB6, 0xDC
};

// MAC del cuarto periférico
const uint8_t MAC_SENDER_4[] = {
  0xE0, 0x72, 0xA1, 0x70, 0xCD, 0x0C
};

// MAC del central
const uint8_t MAC_RECEIVER_1[] = {
  0xE0, 0x72, 0xA1, 0x72, 0xD8, 0xBC
};

const uint8_t *RECEIVERS_MACS[] = {
  MAC_SENDER_1,
  MAC_SENDER_2,
  MAC_SENDER_3,
  MAC_SENDER_4
};

const uint8_t RECEIVERS_COUNT = 4;

bool tiraEncendida = false;

unsigned long tiempoInicioTira = 0;

const unsigned long tiempoTira = 2000;

int tiraAnterior = -1;


// Se ejecuta cuando termina un envío
void OnDataSent(
  const wifi_tx_info_t *info,
  esp_now_send_status_t status)
{
  Serial.print("Estado del envio: ");

  Serial.println(
    status == ESP_NOW_SEND_SUCCESS
      ? "Exito"
      : "Fallo"
  );
}


// Recibe mensajes de los periféricos
void OnMessageReceived(
  const esp_now_recv_info_t *info,
  const uint8_t *data,
  int len)
{
  String mensaje;

  for (int i = 0; i < len; i++)
  {
    mensaje += (char)data[i];
  }

  Serial.print("Mensaje recibido: ");
  Serial.println(mensaje);
}


// Prende la tira del central
void prenderTiraCentral()
{
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

  Serial.println("Central encendido");
}


// Apaga la tira del central
void apagarTiraCentral()
{
  tira.clear();
  tira.show();

  tiraEncendida = false;

  Serial.println("Central apagado");
}


// Le manda EMPEZAR a uno de los periféricos
void enviarEmpezar(int numero)
{
  String mensaje = "EMPEZAR";

  esp_err_t result = esp_now_send(
    RECEIVERS_MACS[numero],
    (uint8_t *)mensaje.c_str(),
    mensaje.length()
  );

  if (result == ESP_OK)
  {
    Serial.print("Se prendio el periferico ");
    Serial.println(numero + 1);
  }
  else
  {
    Serial.println("Error enviando EMPEZAR");
  }
}


// Elige cuál se prende después
void elegirSiguiente()
{
  int siguiente;

  do
  {
    siguiente = random(0, 5);
  }
  while (siguiente == tiraAnterior);

  tiraAnterior = siguiente;

  if (siguiente == 0)
  {
    prenderTiraCentral();
  }
  else
  {
    enviarEmpezar(siguiente - 1);

    tiraEncendida = true;
    tiempoInicioTira = millis();
  }
}


// Controla el cambio de una tira a otra
void controlarSecuencia()
{
  if (tiraEncendida)
  {
    unsigned long currentMillis = millis();

    if (currentMillis - tiempoInicioTira >= tiempoTira)
    {
      if (tiraAnterior == 0)
      {
        apagarTiraCentral();
      }
      else
      {
        Serial.println("Periferico terminado");
        tiraEncendida = false;
      }

      elegirSiguiente();
    }
  }
}


// Registra los periféricos
void RegisterAllPeers()
{
  esp_now_peer_info_t peerInfo = {};

  peerInfo.channel = 0;
  peerInfo.encrypt = false;

  for (int i = 0; i < RECEIVERS_COUNT; i++)
  {
    memcpy(
      peerInfo.peer_addr,
      RECEIVERS_MACS[i],
      6
    );

    if (esp_now_add_peer(&peerInfo) != ESP_OK)
    {
      Serial.printf(
        "Error al registrar Peer %d\n",
        i + 1
      );
    }
    else
    {
      Serial.printf(
        "Peer %d registrado\n",
        i + 1
      );
    }
  }
}


// Inicializa ESP-NOW
void InitEspNow()
{
  if (esp_now_init() != ESP_OK)
  {
    Serial.println("Error inicializando ESP-NOW");
    return;
  }

  esp_now_register_send_cb(OnDataSent);
  esp_now_register_recv_cb(OnMessageReceived);

  RegisterAllPeers();
}


void setup()
{
  Serial.begin(115200);

  tira.begin();
  tira.setBrightness(200);
  tira.clear();
  tira.show();

  WiFi.mode(WIFI_STA);
  WiFi.disconnect();

  InitEspNow();

  randomSeed(micros());

  // Arranca la secuencia
  elegirSiguiente();
}


void loop()
{
  controlarSecuencia();
}