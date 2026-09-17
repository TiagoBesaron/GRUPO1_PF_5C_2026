#define ENABLE_USER_AUTH
#define ENABLE_DATABASE

#include <esp_now.h>  // Librería para comunicación ESP-NOW
#include <WiFi.h>     // Librería para configurar el WiFi del ESP32
#include <WiFiClientSecure.h>
#include <FirebaseClient.h>

#define WIFI_SSID "MECA-IoT"
#define WIFI_PASSWORD "IoT$2026"

#define API_KEY "AIzaSyB1vdZWLxmgbU74BZwmHlV9ll1zAFuy1Sk"
#define DATABASE_URL "https://g1-pf-5c-2026-default-rtdb.firebaseio.com"
#define USER_EMAIL "esp32@ledtrainer.com.ar"
#define USER_PASSWORD "G1-PF-5C-2026"
UserAuth userAuth(
  API_KEY,
  USER_EMAIL,
  USER_PASSWORD,
  3000);

FirebaseApp app;

WiFiClientSecure ssl_client;

using AsyncClient = AsyncClientClass;

AsyncClient aClient(ssl_client);

RealtimeDatabase Database;

const int TAM_COLA = 20;

String colaMensajes[TAM_COLA];

int frente = 0;
int fin = 0;

void processData(AsyncResult &aResult);
bool agregarMensaje(String mensaje);
bool sacarMensaje(String &mensaje);
void addPeer(const uint8_t *mac);
void OnMessageReceived(const esp_now_recv_info_t *info,
                       const uint8_t *data,
                       int len);
void InitEspNow() {

  if (esp_now_init() != ESP_OK) {
    Serial.println("Error initializing ESP-NOW");
    return;
  }

  esp_now_register_recv_cb(OnMessageReceived);

  Serial.println("ESP-NOW listo");
}

void connectWiFi() {

  WiFi.mode(WIFI_STA);

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  Serial.print("Conectando");

  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }

  Serial.println();
  Serial.println("WiFi conectado");
}

// Dirección MAC del primer emisor
const uint8_t MAC_SENDER_1[] = {
  0xE0, 0x72, 0xA1, 0x72, 0xDA, 0x54
};

// Dirección MAC del segundo emisor
const uint8_t MAC_SENDER_2[] = {
  0xE0, 0x72, 0xA1, 0x71, 0x00, 0xBC
};

// Dirección MAC del tercer emisor
const uint8_t MAC_SENDER_3[] = {
  0xE0, 0x72, 0xA1, 0x70, 0xB6, 0xDC
};

// Dirección MAC del cuarto emisor
const uint8_t MAC_SENDER_4[] = {
  0xE0, 0x72, 0xA1, 0x70, 0xCD, 0x0C
};

// Dirección MAC del receptor
const uint8_t MAC_RECEIVER_1[] = {
  0xE0, 0x72, 0xA1, 0x72, 0xD8, 0xBC
};

// Lista de dispositivos que actuarán como emisores.
const uint8_t *SENDERS_MACS[] = {
  MAC_SENDER_1,
  MAC_SENDER_2,
  MAC_SENDER_3,
  MAC_SENDER_4
};

// Cantidad de emisores
const uint8_t SENDERS_COUNT = sizeof(SENDERS_MACS) / sizeof(uint8_t *);

// Lista de receptores
const uint8_t *RECEIVERS_MACS[] = {
  MAC_RECEIVER_1
};

// Cantidad de receptores
const uint8_t RECEIVERS_COUNT = sizeof(RECEIVERS_MACS) / sizeof(uint8_t *);

//--------------------------------------------------
// Callback de recepción ESP-NOW
//--------------------------------------------------
void OnMessageReceived(const esp_now_recv_info_t *info,
                       const uint8_t *data,
                       int len) {

  const uint8_t *mac = info->src_addr;
  bool emisorValido = false;

  for (int i = 0; i < SENDERS_COUNT; i++) {

    if (memcmp(mac, SENDERS_MACS[i], 6) == 0) {
      emisorValido = true;
      break;
    }
  }

  if (!emisorValido) {
    Serial.println("Emisor desconocido");
    return;
  }
  Serial.printf("Packet received from: %02X:%02X:%02X:%02X:%02X:%02X\n",
                mac[0], mac[1], mac[2],
                mac[3], mac[4], mac[5]);

  Serial.printf("Bytes received: %d\n", len);

  String payload;

  payload.reserve(len);

  for (int i = 0; i < len; i++) {
    payload += (char)data[i];
  }

  Serial.print("Mensaje: ");
  Serial.println(payload);

  if (!agregarMensaje(payload)) {
    Serial.println("Cola llena");
  }
}

//--------------------------------------------------
// Inicializa ESP-NOW
//--------------------------------------------------
void processData(AsyncResult &aResult) {

  if (!aResult.isResult())
    return;

  if (aResult.isEvent()) {
    Firebase.printf(
      "Event task: %s, msg: %s, code: %d\n",
      aResult.uid().c_str(),
      aResult.eventLog().message().c_str(),
      aResult.eventLog().code());
  }

  if (aResult.isDebug()) {
    Firebase.printf(
      "Debug task: %s, msg: %s\n",
      aResult.uid().c_str(),
      aResult.debug().c_str());
  }

  if (aResult.isError()) {
    Firebase.printf(
      "Error task: %s, msg: %s, code: %d\n",
      aResult.uid().c_str(),
      aResult.error().message().c_str(),
      aResult.error().code());
  }

  if (aResult.available()) {
    Serial.println("Dato enviado correctamente a Firebase");
  }
}

//--------------------------------------------------
// Setup
//--------------------------------------------------
void setup() {

  // Inicia el monitor serie
  Serial.begin(9600);

  connectWiFi();

  ssl_client.setInsecure();

  initializeApp(aClient, app, getAuth(userAuth));

  int intentos = 0;

  while (!app.ready() && intentos < 500) {

    app.loop();
    delay(10);

    intentos++;
  }

  if (!app.ready()) {
    Serial.println("Error iniciando Firebase");
  }

  app.getApp<RealtimeDatabase>(Database);

  Database.url(DATABASE_URL);

  InitEspNow();
  Serial.println("Firebase listo.");
}

void loop() {

  app.loop();

  String mensaje;

  if (app.ready()) {

    if (sacarMensaje(mensaje)) {

      Database.push<String>(
        aClient,
        "/Mensajes",
        mensaje,
        processData);
    }
  }
}
bool agregarMensaje(String mensaje) {

  int siguiente = (fin + 1) % TAM_COLA;

  if (siguiente == frente) {
    // Cola llena
    return false;
  }

  colaMensajes[fin] = mensaje;
  fin = siguiente;

  return true;
}
bool sacarMensaje(String &mensaje) {

  if (frente == fin) {
    // Cola vacía
    return false;
  }

  mensaje = colaMensajes[frente];

  frente = (frente + 1) % TAM_COLA;

  return true;
}
void addPeer(const uint8_t *mac) {

  esp_now_peer_info_t peerInfo = {};

  memcpy(peerInfo.peer_addr, mac, 6);

  peerInfo.channel = 0;
  peerInfo.encrypt = false;

  if (esp_now_add_peer(&peerInfo) != ESP_OK) {
    Serial.println("Error agregando peer");
  }
}