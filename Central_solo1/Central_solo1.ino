#define ENABLE_USER_AUTH
#define ENABLE_DATABASE

#include <WiFi.h>
#include <FirebaseClient.h>
#include <esp_now.h>
#include <esp_wifi.h>

// =====================================================
// CONFIGURACIÓN WIFI & FIREBASE
// =====================================================
#define WIFI_SSID "TU_WIFI"
#define WIFI_PASSWORD "TU_PASSWORD"

#define API_KEY "TU_API_KEY"
#define USER_EMAIL "TU_EMAIL_FIREBASE"
#define USER_PASSWORD "TU_PASSWORD_FIREBASE"
#define DATABASE_URL "TU_DATABASE_URL"

// MAC del Periférico (copiada del Monitor Serie del Periférico)
uint8_t macPeriferico[] = {0xE0, 0x72, 0xA1, 0x72, 0xD8, 0xBC};

SSL_CLIENT ssl_client;
using AsyncClient = AsyncClientClass;
AsyncClient aClient(ssl_client);

UserAuth user_auth(API_KEY, USER_EMAIL, USER_PASSWORD, 3000);
FirebaseApp app;
RealtimeDatabase Database;
AsyncResult databaseResult;

unsigned long ultimoEnvio = 0;
bool esperandoRespuesta = false;

// =====================================================
// FIREBASE HANDLER
// =====================================================
void procesarFirebase(AsyncResult &resultado) {
  if (!resultado.isResult()) return;

  if (resultado.isError()) {
    Firebase.printf("Firebase Error: %s\n", resultado.error().message().c_str());
  }

  if (resultado.available()) {
    Firebase.printf("Firebase Respuesta: %s\n", resultado.c_str());
  }
}

void guardarEnFirebase(unsigned long tiempoMs) {
  if (!app.ready()) {
    Serial.println("Firebase aun no esta listo...");
    return;
  }

  // Guarda en la ruta /PruebasTiempos/timestamp
  String ruta = "/PruebasTiempos/" + String(millis());

  object_t json;
  JsonWriter writer;

  object_t objTiempo, objSegundos;

  writer.create(objTiempo, "tiempo_ms", tiempoMs);
  writer.create(objSegundos, "tiempo_seg", number_t(tiempoMs / 1000.0, 3));

  writer.join(json, 2, objTiempo, objSegundos);

  Database.set<object_t>(aClient, ruta, json, procesarFirebase, "guardarTiempoTest");
  Serial.println(">>> Guardando resultado en Firebase...");
}

// =====================================================
// ESP-NOW
// =====================================================
void agregarPeer(uint8_t *mac) {
  if (!esp_now_is_peer_exist(mac)) {
    esp_now_peer_info_t peerInfo = {};
    memcpy(peerInfo.peer_addr, mac, 6);
    peerInfo.channel = 0;
    peerInfo.encrypt = false;
    esp_now_add_peer(&peerInfo);
  }
}

void enviarComando(const char *cmd) {
  agregarPeer(macPeriferico);
  esp_now_send(macPeriferico, (uint8_t *)cmd, strlen(cmd) + 1);
  Serial.print("Enviando orden al Periferico: ");
  Serial.println(cmd);
}

void recibirESPNow(const esp_now_recv_info_t *info, const uint8_t *data, int len) {
  char mensaje[100];
  if (len >= sizeof(mensaje)) len = sizeof(mensaje) - 1;
  memcpy(mensaje, data, len);
  mensaje[len] = '\0';

  String texto = String(mensaje);
  if (texto.startsWith("REACCION:")) {
    unsigned long tiempoMs = texto.substring(9).toInt();

    Serial.println("\n------------------------------------");
    Serial.print("¡REACCION RECIBIDA!: ");
    Serial.print(tiempoMs);
    Serial.println(" ms");
    Serial.println("------------------------------------");

    // Subir inmediatamente a Firebase
    guardarEnFirebase(tiempoMs);

    esperandoRespuesta = false;
    ultimoEnvio = millis();
  }
}

// =====================================================
// SETUP & LOOP
// =====================================================
void setup() {
  Serial.begin(115200);

  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  Serial.print("Conectando a WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(300);
    Serial.print(".");
  }
  Serial.println("\nWiFi Conectado!");

  // Sincronizar canal de ESP-NOW con el canal del WiFi
  int canal = WiFi.channel();
  esp_wifi_set_channel(canal, WIFI_SECOND_CHAN_NONE);

  if (esp_now_init() != ESP_OK) {
    Serial.println("Error iniciando ESP-NOW");
    return;
  }
  esp_now_register_recv_cb(recibirESPNow);

  // Inicializar Firebase
  set_ssl_client_insecure_and_buffer(ssl_client);
  initializeApp(aClient, app, getAuth(user_auth), procesarFirebase, "authTask");
  app.getApp<RealtimeDatabase>(Database);
  Database.url(DATABASE_URL);

  Serial.println("CENTRAL LISTA CON FIREBASE");
  Serial.println("Disparando primer disparo en 3 segundos...");
  delay(3000);

  enviarComando("EMPEZAR");
  esperandoRespuesta = true;
}

void loop() {
  app.loop();
  procesarFirebase(databaseResult);

  // Si ya respondió y pasaron 4 segundos, dispara de nuevo la prueba
  if (!esperandoRespuesta && (millis() - ultimoEnvio >= 4000)) {
    Serial.println("\nIniciando siguiente ronda de prueba...");
    enviarComando("EMPEZAR");
    esperandoRespuesta = true;
  }
}