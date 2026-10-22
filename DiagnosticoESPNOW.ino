// =====================================================================
// DIAGNOSTICO ESP-NOW para ESP32-C3 SuperMini
// ---------------------------------------------------------------------
// Cargar ESTE MISMO sketch en todas las placas (no hay que escribir
// ninguna MAC). Cada placa:
//   1. Imprime su MAC Wi-Fi STA (la que hay que usar en ESP-NOW),
//      ya formateada para copiar y pegar en el codigo.
//   2. Cada 2 s manda un PING por broadcast.
//   3. Si recibe un PING de otra placa, la registra como peer y le
//      responde un PONG por UNICAST (a su MAC).
//   4. Muestra si el unicast fue entregado (ACK) y el RSSI recibido.
//
// Si ves "PING recibido" pero el PONG da "FALLO", el problema es de
// RF / alimentacion. Si no ves nada, es canal / alimentacion / antena.
//
// IMPORTANTE (Arduino IDE): Herramientas -> "USB CDC On Boot: Enabled",
// si no, el C3 SuperMini no imprime nada por el Monitor Serie.
// =====================================================================

#include <WiFi.h>
#include <esp_now.h>
#include <esp_wifi.h>

#define CANAL_ESPNOW 1          // Debe ser el mismo en TODAS las placas
#define INTERVALO_PING_MS 2000

static const uint8_t MAC_BROADCAST[6] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};

typedef struct {
  char tipo[5];          // "PING" o "PONG"
  uint32_t contador;
} Paquete;

uint8_t miMac[6];
uint32_t contadorPing = 0;
unsigned long ultimoPing = 0;

// Datos compartidos entre los callbacks (tarea Wi-Fi) y loop()
volatile bool hayPingPendiente = false;
uint8_t macPingPendiente[6];

volatile bool hayEvento = false;
char textoEvento[120];

void macATexto(const uint8_t *mac, char *salida) {
  sprintf(salida, "%02X:%02X:%02X:%02X:%02X:%02X",
          mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
}

// ---------------------------------------------------------------------
// Callbacks (firma de ESP32 Arduino core 3.3.x, igual que el resto del repo)
// ---------------------------------------------------------------------
void alEnviar(const wifi_tx_info_t *info, esp_now_send_status_t estado) {
  // Solo informamos los unicast (los broadcast siempre dan "exito")
  if (memcmp(info->des_addr, MAC_BROADCAST, 6) == 0) return;
  char m[18];
  macATexto(info->des_addr, m);
  snprintf(textoEvento, sizeof(textoEvento), "  -> PONG unicast a %s: %s", m,
           estado == ESP_NOW_SEND_SUCCESS ? "ENTREGADO (ACK OK)" : "FALLO (sin ACK)");
  hayEvento = true;
}

void alRecibir(const esp_now_recv_info_t *info, const uint8_t *datos, int len) {
  if (len != sizeof(Paquete)) return;  // paquete de otro sketch: se ignora
  Paquete p;
  memcpy(&p, datos, sizeof(p));

  char m[18];
  macATexto(info->src_addr, m);
  int rssi = info->rx_ctrl ? info->rx_ctrl->rssi : 0;

  if (strncmp(p.tipo, "PING", 4) == 0) {
    snprintf(textoEvento, sizeof(textoEvento), "PING #%lu recibido de %s (RSSI %d dBm)",
             (unsigned long)p.contador, m, rssi);
    memcpy(macPingPendiente, info->src_addr, 6);
    hayPingPendiente = true;
  } else if (strncmp(p.tipo, "PONG", 4) == 0) {
    snprintf(textoEvento, sizeof(textoEvento), "PONG recibido de %s (RSSI %d dBm) -> UNICAST FUNCIONA",
             m, rssi);
  }
  hayEvento = true;
}

bool agregarPeer(const uint8_t *mac) {
  if (esp_now_is_peer_exist(mac)) return true;
  esp_now_peer_info_t peer = {};
  memcpy(peer.peer_addr, mac, 6);
  peer.channel = CANAL_ESPNOW;
  peer.ifidx = WIFI_IF_STA;
  peer.encrypt = false;
  esp_err_t r = esp_now_add_peer(&peer);
  if (r != ESP_OK) {
    Serial.printf("Error agregando peer: %s\n", esp_err_to_name(r));
    return false;
  }
  return true;
}

void setup() {
  Serial.begin(115200);
  delay(2000);  // tiempo para que abra el USB CDC del C3

  // --- Radio: modo estacion, sin conectarse a ningun router ---
  WiFi.mode(WIFI_STA);
  WiFi.disconnect();
  esp_wifi_set_ps(WIFI_PS_NONE);

  // --- CLAVE en el C3 SuperMini: bajar la potencia de transmision ---
  WiFi.setTxPower(WIFI_POWER_8_5dBm);

  esp_wifi_set_channel(CANAL_ESPNOW, WIFI_SECOND_CHAN_NONE);

  esp_wifi_get_mac(WIFI_IF_STA, miMac);
  uint8_t canal;
  wifi_second_chan_t sec;
  esp_wifi_get_channel(&canal, &sec);

  char m[18];
  macATexto(miMac, m);
  Serial.println("\n==============================================");
  Serial.printf("MAC Wi-Fi STA de ESTA placa: %s\n", m);
  Serial.printf("Para pegar en el codigo: {0x%02X, 0x%02X, 0x%02X, 0x%02X, 0x%02X, 0x%02X}\n",
                miMac[0], miMac[1], miMac[2], miMac[3], miMac[4], miMac[5]);
  Serial.printf("Canal actual: %d\n", canal);
  Serial.println("==============================================");

  esp_err_t r = esp_now_init();
  if (r != ESP_OK) {
    Serial.printf("Error iniciando ESP-NOW: %s\n", esp_err_to_name(r));
    while (true) delay(1000);
  }
  esp_now_register_send_cb(alEnviar);
  esp_now_register_recv_cb(alRecibir);
  agregarPeer(MAC_BROADCAST);

  Serial.println("Listo. Mandando PING cada 2 s...");
}

void loop() {
  if (hayEvento) {
    hayEvento = false;
    Serial.println(textoEvento);
  }

  // Responder al ultimo PING con un PONG unicast
  if (hayPingPendiente) {
    hayPingPendiente = false;
    uint8_t destino[6];
    memcpy(destino, macPingPendiente, 6);
    if (agregarPeer(destino)) {
      Paquete p = {"PONG", 0};
      esp_err_t r = esp_now_send(destino, (uint8_t *)&p, sizeof(p));
      if (r != ESP_OK) Serial.printf("esp_now_send PONG error: %s\n", esp_err_to_name(r));
    }
  }

  if (millis() - ultimoPing >= INTERVALO_PING_MS) {
    ultimoPing = millis();
    Paquete p = {"PING", ++contadorPing};
    esp_err_t r = esp_now_send(MAC_BROADCAST, (uint8_t *)&p, sizeof(p));
    if (r != ESP_OK) Serial.printf("esp_now_send PING error: %s\n", esp_err_to_name(r));
  }
}
