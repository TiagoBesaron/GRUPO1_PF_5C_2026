#include <WiFi.h>
#include <esp_now.h>

#include <Adafruit_NeoPixel.h>


// =====================================================
// NEOPIXEL
// =====================================================

#define PIN 21
#define NUMPIXELS 24

Adafruit_NeoPixel tira(
  NUMPIXELS,
  PIN,
  NEO_GRB + NEO_KHZ800
);


// =====================================================
// MAC DEL CENTRAL
// =====================================================

uint8_t centralMAC[] = {
  0xE0,
  0x72,
  0xA1,
  0x72,
  0xDA,
  0x54
};


// =====================================================
// RADAR
// =====================================================

#define SENSOR_PIN 4

bool movimientoAnterior = LOW;

unsigned long ultimoMovimiento = 0;

const unsigned long tiempoAntirrebote = 500;


// =====================================================
// ENTRENAMIENTO
// =====================================================

bool entrenamientoActivo = false;

unsigned long inicioEntrenamiento = 0;


// =====================================================
// LED
// =====================================================

bool tiraEncendida = false;

int colorActual = 0;

unsigned long tiempoAnteriorColor = 0;

const unsigned long intervaloColor = 1000;


// =====================================================
// OBTENER MAC PROPIA
// =====================================================

String obtenerMAC() {

  return WiFi.macAddress();
}


// =====================================================
// LEDS
// =====================================================

void apagarLeds() {

  for (int i = 0; i < NUMPIXELS; i++) {

    tira.setPixelColor(
      i,
      0,
      0,
      0
    );
  }

  tira.show();
}


void encenderColor(
  int r,
  int g,
  int b
) {

  for (int i = 0; i < NUMPIXELS; i++) {

    tira.setPixelColor(
      i,
      tira.Color(
        r,
        g,
        b
      )
    );
  }

  tira.show();
}


void cambiarColor() {

  if (colorActual == 0) {

    encenderColor(
      255,
      0,
      0
    );
  }

  else if (colorActual == 1) {

    encenderColor(
      0,
      255,
      0
    );
  }

  else {

    encenderColor(
      0,
      0,
      255
    );
  }


  colorActual++;


  if (colorActual > 2) {

    colorActual = 0;
  }
}


// =====================================================
// ENVIAR AL CENTRAL
// =====================================================

void enviarAlCentral(
  const char *mensaje
) {

  esp_err_t resultado =
    esp_now_send(
      centralMAC,
      (uint8_t *)mensaje,
      strlen(mensaje) + 1
    );


  if (resultado == ESP_OK) {

    Serial.print(
      "Enviado al central: "
    );

    Serial.println(
      mensaje
    );
  }

  else {

    Serial.print(
      "Error enviando: "
    );

    Serial.println(
      resultado
    );
  }
}


// =====================================================
// EMPEZAR ENTRENAMIENTO
// =====================================================

void iniciarEntrenamiento() {

  entrenamientoActivo = true;

  inicioEntrenamiento = millis();

  tiraEncendida = true;


  encenderColor(
    255,
    0,
    0
  );


  Serial.println(
    "ENTRENAMIENTO INICIADO"
  );
}


// =====================================================
// DETENER ENTRENAMIENTO
// =====================================================

void detenerEntrenamiento() {

  entrenamientoActivo = false;

  tiraEncendida = false;

  apagarLeds();


  Serial.println(
    "ENTRENAMIENTO DETENIDO"
  );
}


// =====================================================
// RECIBIR ESP-NOW
// =====================================================

void recibirESPNow(
  const esp_now_recv_info_t *info,
  const uint8_t *data,
  int len
) {

  char mensaje[100];


  if (len >= sizeof(mensaje)) {

    len = sizeof(mensaje) - 1;
  }


  memcpy(
    mensaje,
    data,
    len
  );


  mensaje[len] = '\0';


  String comando =
    String(mensaje);


  Serial.print(
    "Mensaje recibido: "
  );

  Serial.println(
    comando
  );


  if (comando == "EMPEZAR") {

    iniciarEntrenamiento();
  }


  else if (comando == "DETENER") {

    detenerEntrenamiento();
  }


  else if (comando == "APAGAR") {

    entrenamientoActivo = false;

    tiraEncendida = false;

    apagarLeds();
  }


  else if (comando == "ENCENDER") {

    tiraEncendida = true;

    cambiarColor();
  }


  else if (comando == "REACCION") {

    entrenamientoActivo = false;

    tiraEncendida = false;

    apagarLeds();
  }
}


// =====================================================
// RADAR
// =====================================================

void comprobarRadar() {

  bool movimiento =
    digitalRead(SENSOR_PIN);


  unsigned long ahora =
    millis();


  if (
    movimiento == HIGH &&
    movimientoAnterior == LOW
  ) {

    if (
      ahora -
      ultimoMovimiento >
      tiempoAntirrebote
    ) {

      ultimoMovimiento =
        ahora;


      if (entrenamientoActivo) {

        unsigned long tiempo =
          ahora -
          inicioEntrenamiento;


        Serial.print(
          "Reaccion: "
        );

        Serial.print(
          tiempo
        );

        Serial.println(
          " ms"
        );


        char mensaje[100];


        sprintf(
          mensaje,
          "REACCION:%lu|MAC:%s",
          tiempo,
          obtenerMAC().c_str()
        );


        enviarAlCentral(
          mensaje
        );


        entrenamientoActivo =
          false;


        tiraEncendida =
          false;


        apagarLeds();
      }
    }
  }


  movimientoAnterior =
    movimiento;
}


// =====================================================
// CAMBIO AUTOMATICO DE COLOR
// =====================================================

void actualizarColores() {

  if (
    !tiraEncendida ||
    entrenamientoActivo
  ) {

    return;
  }


  unsigned long ahora =
    millis();


  if (
    ahora -
    tiempoAnteriorColor >=
    intervaloColor
  ) {

    tiempoAnteriorColor =
      ahora;

    cambiarColor();
  }
}


// =====================================================
// CONFIGURAR ESP-NOW
// =====================================================

void configurarESPNow() {

  if (
    esp_now_init() != ESP_OK
  ) {

    Serial.println(
      "ERROR INICIANDO ESP-NOW"
    );

    return;
  }


  esp_now_register_recv_cb(
    recibirESPNow
  );


  esp_now_peer_info_t peerInfo = {};


  memcpy(
    peerInfo.peer_addr,
    centralMAC,
    6
  );


  peerInfo.channel = 0;

  peerInfo.encrypt = false;


  if (
    !esp_now_is_peer_exist(
      centralMAC
    )
  ) {

    esp_err_t resultado =
      esp_now_add_peer(
        &peerInfo
      );


    if (
      resultado == ESP_OK
    ) {

      Serial.println(
        "Central agregado correctamente"
      );
    }

    else {

      Serial.print(
        "Error agregando central: "
      );

      Serial.println(
        resultado
      );
    }
  }
}


// =====================================================
// SETUP
// =====================================================

void setup() {

  Serial.begin(
    115200
  );


  // =============================================
  // WIFI
  // =============================================

  WiFi.mode(
    WIFI_STA
  );


  // =============================================
  // OBTENER MAC AUTOMATICAMENTE
  // =============================================

  String mac =
    obtenerMAC();


  Serial.println();

  Serial.println(
    "================================"
  );

  Serial.println(
    "LED TRAINER - PERIFERICO"
  );

  Serial.println(
    "================================"
  );


  Serial.print(
    "MAC DEL PERIFERICO: "
  );

  Serial.println(
    mac
  );


  // =============================================
  // NEOPIXEL
  // =============================================

  tira.begin();

  tira.setBrightness(
    200
  );

  apagarLeds();


  // =============================================
  // RADAR
  // =============================================

  pinMode(
    SENSOR_PIN,
    INPUT
  );


  // =============================================
  // ESP-NOW
  // =============================================

  configurarESPNow();


  Serial.println();

  Serial.println(
    "PERIFERICO LISTO"
  );

  Serial.println();
}


// =====================================================
// LOOP
// =====================================================

void loop() {

  comprobarRadar();

  actualizarColores();
}