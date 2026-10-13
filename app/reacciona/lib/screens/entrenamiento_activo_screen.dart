import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:go_router/go_router.dart';
import '../provider/bluetooth_provider.dart';

class EntrenamientoActivoScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> config;

  const EntrenamientoActivoScreen({super.key, required this.config});

  @override
  ConsumerState<EntrenamientoActivoScreen> createState() =>
      _EntrenamientoActivoScreenState();
}

class _EntrenamientoActivoScreenState
    extends ConsumerState<EntrenamientoActivoScreen> {
  int rondaActual = 0;
  late int rondasTotal;
  late String modo;
  List<double> tiemposObtenidos = [];
  bool esperandoSensor = false;
  bool enPausaEntreRondas = false;
  bool ledEncendido = false;
  bool sesionTerminada = false;
  
  // Identificador del Pod que se encuentra encendido (0 = Central, 1 = Periférico)
  int podActivoActual = 0;
  
  String estadoTexto = "Preparándote...";

  final List<List<int>> listaRGB = [
    [0, 255, 0],   // Verde
    [255, 0, 0],   // Rojo
    [0, 0, 255],   // Azul
    [255, 255, 0], // Amarillo
    [128, 0, 128], // Violeta
  ];

  @override
  void initState() {
    super.initState();
    modo = widget.config['modo'] ?? 'rondas';
    rondasTotal = widget.config['rondasTotal'] ?? 10;

    if (modo == 'manual') {
      estadoTexto = "Modo Manual: Presioná 'ENCENDER' para activar un pod.";
    } else {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => iniciarSiguienteRonda());
    }
  }

  List<int> obtenerRGBRonda() {
    if (widget.config['colorAleatorio'] == true) {
      return listaRGB[Random().nextInt(listaRGB.length)];
    }
    return List<int>.from(widget.config['rgbBase'] ?? [0, 255, 0]);
  }

  Future<void> iniciarSiguienteRonda() async {
    if (sesionTerminada) return;

    if (modo != 'manual' && rondaActual >= rondasTotal) {
      finalizarEntrenamiento();
      return;
    }

    setState(() {
      rondaActual++;
      enPausaEntreRondas = true;
      esperandoSensor = false;
      estadoTexto = "¡Atento!";
    });

    // Espera aleatoria ultra rápida (entre 0.3s y 0.8s)
    int tiempoEsperaMs = 300 + Random().nextInt(500);
    await Future.delayed(Duration(milliseconds: tiempoEsperaMs));

    if (!mounted || sesionTerminada) return;

    _encenderLedManual();
  }

  void _encenderLedManual() {
    if (sesionTerminada) return;

    List<int> rgb = obtenerRGBRonda();
    
    // Selección aleatoria entre Pod 0 (Central) y Pod 1 (Periférico ESP-NOW)
    int podElegido = Random().nextInt(2); // Genera 0 o 1

    // Formato de comando para Master + ESP-NOW: EMPEZAR:POD_ID,R,G,B
    String comando = "EMPEZAR:$podElegido,${rgb[0]},${rgb[1]},${rgb[2]}";

    ref.read(bluetoothProvider.notifier).enviarComando(comando);

    setState(() {
      enPausaEntreRondas = false;
      esperandoSensor = true;
      ledEncendido = true;
      podActivoActual = podElegido;
      estadoTexto = "¡PASA LA MANO POR EL POD $podElegido!";
    });
  }

  void _apagarLedManual() {
    // Comando de apagar enviado al Pod que está activo actualmente
    String comando = "EMPEZAR:$podActivoActual,0,0,0";
    ref.read(bluetoothProvider.notifier).enviarComando(comando);

    setState(() {
      esperandoSensor = false;
      ledEncendido = false;
      estadoTexto = "LED Apagado manualmente.";
    });
  }

  void procesarTiempoRespuesta(String ultimoTiempoStr) {
    if (!esperandoSensor || sesionTerminada) return;

    double tiempoSeg =
        double.tryParse(ultimoTiempoStr.replaceAll(" s", "")) ?? 0.0;
    tiemposObtenidos.add(tiempoSeg);

    setState(() {
      esperandoSensor = false;
      ledEncendido = false;
      estadoTexto =
          "¡Toque en Pod $podActivoActual! (${tiempoSeg.toStringAsFixed(3)} s)";
    });

    if (modo != 'manual') {
      // Pausa pos-toque mínima de 200 ms antes de preparar la siguiente ronda
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted && !sesionTerminada) iniciarSiguienteRonda();
      });
    }
  }

  // Notificación y detención por pérdida de conexión Bluetooth con el Central
  void _mostrarErrorDesconexion() {
    if (sesionTerminada || !mounted) return;

    setState(() {
      sesionTerminada = true;
      esperandoSensor = false;
      ledEncendido = false;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.bluetooth_disabled, color: Colors.redAccent),
            SizedBox(width: 8),
            Text("Desconectado"),
          ],
        ),
        content: const Text(
          "Se interrumpió la conexión Bluetooth con el Pod Central. La sesión se ha detenido.",
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/home');
            },
            child: const Text("Volver al Inicio"),
          ),
        ],
      ),
    );
  }

  Future<void> finalizarEntrenamiento() async {
    if (sesionTerminada) return;
    setState(() => sesionTerminada = true);

    double promedio = tiemposObtenidos.isEmpty
        ? 0
        : tiemposObtenidos.reduce((a, b) => a + b) / tiemposObtenidos.length;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null && tiemposObtenidos.isNotEmpty) {
      final ref =
          FirebaseDatabase.instance.ref("usuarios/${user.uid}/sesiones");
      await ref.push().set({
        "rondas": modo == 'manual' ? tiemposObtenidos.length : rondasTotal,
        "modo": modo,
        "promedio_seg": promedio,
        "tiempos": tiemposObtenidos,
        "timestamp": ServerValue.timestamp,
      });
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("¡Entrenamiento Finalizado! 🏆"),
        content: Text(
          "Toques registrados: ${tiemposObtenidos.length}\n"
          "Promedio: ${promedio.toStringAsFixed(3)} s",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/home');
            },
            child: const Text("Aceptar"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<BluetoothState>(bluetoothProvider, (prev, next) {
      // 1. Detectar desconexión BLE
      if (prev?.conectado == true && !next.conectado) {
        _mostrarErrorDesconexion();
        return;
      }

      // 2. Procesar llegada de tiempo de reacción
      if (prev?.ultimoTiempo != next.ultimoTiempo && esperandoSensor) {
        procesarTiempoRespuesta(next.ultimoTiempo);
      }
    });

    List<int> currentRgb = widget.config['rgbBase'] ?? [0, 255, 0];
    Color currentColor = Color.fromRGBO(
        currentRgb[0], currentRgb[1], currentRgb[2], 1.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          modo == 'manual'
              ? "Modo Manual (Toques: ${tiemposObtenidos.length})"
              : "Ronda $rondaActual de $rondasTotal",
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Chip indicador de Pod Activo
              if (ledEncendido) ...[
                Chip(
                  avatar: const Icon(Icons.sensors, color: Colors.white, size: 18),
                  label: Text(
                    "POD ACTIVO: $podActivoActual",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                const SizedBox(height: 16),
              ],

              // Representación visual del Pod encendido
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ledEncendido ? currentColor : Colors.grey.shade300,
                  boxShadow: ledEncendido
                      ? [
                          BoxShadow(
                            color: currentColor.withValues(alpha: 0.6),
                            blurRadius: 20,
                            spreadRadius: 5,
                          )
                        ]
                      : [],
                ),
                child: Icon(
                  ledEncendido ? Icons.lightbulb : Icons.lightbulb_outline,
                  size: 60,
                  color: ledEncendido ? Colors.white : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                estadoTexto,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              if (tiemposObtenidos.isNotEmpty) ...[
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          "Último tiempo: ${tiemposObtenidos.last.toStringAsFixed(3)} s",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Total de toques: ${tiemposObtenidos.length}",
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Botones de control manual
              if (modo == 'manual') ...[
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: ledEncendido ? null : _encenderLedManual,
                          icon: const Icon(Icons.power_settings_new),
                          label: const Text(
                            "ENCENDER",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: !ledEncendido ? null : _apagarLedManual,
                          icon: const Icon(Icons.power_off),
                          label: const Text(
                            "APAGAR",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],

              // Botón Finalizar Sesión
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: finalizarEntrenamiento,
                  icon: const Icon(Icons.stop_circle_outlined,
                      color: Colors.redAccent),
                  label: const Text(
                    "FINALIZAR SESIÓN",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}