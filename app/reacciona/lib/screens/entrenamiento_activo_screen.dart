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
  late int tiempoLimiteSeg;
  int tiempoRestanteSeg = 0;
  Timer? _timerTiempo;

  late String modo; // 'rondas', 'tiempo', 'manual'
  List<double> tiemposObtenidos = [];
  bool esperandoSensor = false;
  bool enPausaEntreRondas = false;
  bool ledEncendido = false;
  bool sesionTerminada = false;

  int podActivoActual = -1; // -1 significa ningún pod activo
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
    tiempoLimiteSeg = widget.config['tiempoLimiteSeg'] ?? 30;

    if (modo == 'manual') {
      estadoTexto = "Tocá un cuadrado para encender su Pod";
    } else {
      if (modo == 'tiempo') {
        tiempoRestanteSeg = tiempoLimiteSeg;
        _iniciarCronometro();
      }
      WidgetsBinding.instance
          .addPostFrameCallback((_) => iniciarSiguienteRonda());
    }
  }

  void _iniciarCronometro() {
    _timerTiempo?.cancel();
    _timerTiempo = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || sesionTerminada) {
        timer.cancel();
        return;
      }
      if (tiempoRestanteSeg <= 1) {
        timer.cancel();
        setState(() => tiempoRestanteSeg = 0);
        finalizarEntrenamiento();
      } else {
        setState(() {
          tiempoRestanteSeg--;
        });
      }
    });
  }

  // Obtiene el color base y aplica el % de intensidad seleccionado
  List<int> obtenerRGBRonda() {
    double factorIntensidad =
        ((widget.config['intensidad'] ?? 100) as num) / 100.0;
    List<int> rawRgb;

    if (widget.config['colorAleatorio'] == true) {
      rawRgb = listaRGB[Random().nextInt(listaRGB.length)];
    } else {
      rawRgb = List<int>.from(widget.config['rgbBase'] ?? [0, 255, 0]);
    }

    return [
      (rawRgb[0] * factorIntensidad).round(),
      (rawRgb[1] * factorIntensidad).round(),
      (rawRgb[2] * factorIntensidad).round(),
    ];
  }

  Future<void> iniciarSiguienteRonda() async {
    if (sesionTerminada) return;

    if (modo == 'rondas' && rondaActual >= rondasTotal) {
      finalizarEntrenamiento();
      return;
    }

    setState(() {
      rondaActual++;
      enPausaEntreRondas = true;
      esperandoSensor = false;
      estadoTexto = "¡Atento!";
    });

    int tiempoEsperaMs = 300 + Random().nextInt(500);
    await Future.delayed(Duration(milliseconds: tiempoEsperaMs));

    if (!mounted || sesionTerminada) return;

    int podAleatorio = Random().nextInt(2);
    _encenderPod(podAleatorio);
  }

  void _togglePodManual(int podIndex) {
    if (sesionTerminada) return;

    if (ledEncendido && podActivoActual == podIndex) {
      _apagarPodActual();
    } else {
      _encenderPod(podIndex);
    }
  }

  void _encenderPod(int podIndex) {
    if (sesionTerminada) return;

    List<int> rgb = obtenerRGBRonda();

    String comando = "EMPEZAR:$podIndex,${rgb[0]},${rgb[1]},${rgb[2]}";
    ref.read(bluetoothProvider.notifier).enviarComando(comando);

    setState(() {
      enPausaEntreRondas = false;
      esperandoSensor = true;
      ledEncendido = true;
      podActivoActual = podIndex;
      estadoTexto = "¡Pasa la mano por el Pod ${podIndex + 1}!";
    });
  }

  void _apagarPodActual() {
    if (podActivoActual != -1) {
      String comando = "EMPEZAR:$podActivoActual,0,0,0";
      ref.read(bluetoothProvider.notifier).enviarComando(comando);
    }

    setState(() {
      esperandoSensor = false;
      ledEncendido = false;
      podActivoActual = -1;
      estadoTexto = modo == 'manual'
          ? "Seleccioná un Pod para encender"
          : "LED Apagado.";
    });
  }

  void procesarTiempoRespuesta(String ultimoTiempoStr) {
    if (!esperandoSensor || sesionTerminada) return;

    double tiempoSeg =
        double.tryParse(ultimoTiempoStr.replaceAll(" s", "")) ?? 0.0;
    tiemposObtenidos.add(tiempoSeg);

    int podPrevio = podActivoActual;

    setState(() {
      esperandoSensor = false;
      ledEncendido = false;
      podActivoActual = -1;
      estadoTexto =
          "¡Toque en Pod ${podPrevio + 1}! (${tiempoSeg.toStringAsFixed(3)} s)";
    });

    if (modo != 'manual') {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted && !sesionTerminada) iniciarSiguienteRonda();
      });
    }
  }

  void _mostrarErrorDesconexion() {
    if (sesionTerminada || !mounted) return;

    _timerTiempo?.cancel();
    setState(() {
      sesionTerminada = true;
      esperandoSensor = false;
      ledEncendido = false;
      podActivoActual = -1;
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
    _timerTiempo?.cancel();
    setState(() => sesionTerminada = true);

    _apagarPodActual();

    double promedio = tiemposObtenidos.isEmpty
        ? 0
        : tiemposObtenidos.reduce((a, b) => a + b) / tiemposObtenidos.length;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null && tiemposObtenidos.isNotEmpty) {
      final ref =
          FirebaseDatabase.instance.ref("usuarios/${user.uid}/sesiones");
      await ref.push().set({
        "rondas": tiemposObtenidos.length,
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
  void dispose() {
    _timerTiempo?.cancel();
    super.dispose();
  }

  String _getTituloAppBar() {
    if (modo == 'manual') {
      return "Modo Manual (Toques: ${tiemposObtenidos.length})";
    } else if (modo == 'tiempo') {
      return "Tiempo: ${tiempoRestanteSeg}s | Toques: ${tiemposObtenidos.length}";
    } else {
      return "Ronda $rondaActual de $rondasTotal";
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<BluetoothState>(bluetoothProvider, (prev, next) {
      if (prev?.conectado == true && !next.conectado) {
        _mostrarErrorDesconexion();
        return;
      }

      if (prev?.reactionTicket != next.reactionTicket && esperandoSensor) {
        procesarTiempoRespuesta(next.ultimoTiempo);
      }
    });

    List<int> currentRgb = obtenerRGBRonda();
    Color currentColor = Color.fromRGBO(
        currentRgb[0], currentRgb[1], currentRgb[2], 1.0);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTituloAppBar()),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (modo == 'tiempo') ...[
                Chip(
                  avatar: const Icon(Icons.timer, color: Colors.white, size: 18),
                  label: Text(
                    "TIEMPO RESTANTE: ${tiempoRestanteSeg}s",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor:
                      tiempoRestanteSeg <= 5 ? Colors.redAccent : Colors.orange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
                const SizedBox(height: 16),
              ],

              // VISTA PARA MODO MANUAL (Cuadrados interactivos Pod 1 y Pod 2)
              if (modo == 'manual') ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPodSquare(
                      podIndex: 0,
                      label: "1",
                      isActive: ledEncendido && podActivoActual == 0,
                      activeColor: currentColor,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 20),
                    _buildPodSquare(
                      podIndex: 1,
                      label: "2",
                      isActive: ledEncendido && podActivoActual == 1,
                      activeColor: currentColor,
                      isDark: isDark,
                    ),
                  ],
                ),
              ] else ...[
                // VISTA PARA MODO RONDAS / TIEMPO (Luz circular central)
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
              ],

              const SizedBox(height: 24),

              // ÁREA DE TIEMPO / ESTADO
              Text(
                estadoTexto,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // REGISTRO Y MOSTRADOR DE TIEMPO OBTENIDO
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "TIEMPO",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tiemposObtenidos.isNotEmpty
                          ? "${tiemposObtenidos.last.toStringAsFixed(3)} s"
                          : "-- s",
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    if (tiemposObtenidos.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        "Total toques: ${tiemposObtenidos.length}",
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),

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

  // WIDGET CUADRADO PARA SELECCIÓN DE POD EN MODO MANUAL
  Widget _buildPodSquare({
    required int podIndex,
    required String label,
    required bool isActive,
    required Color activeColor,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _togglePodManual(podIndex),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: isActive
                ? activeColor
                : (isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade100),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive
                  ? activeColor
                  : (isDark ? Colors.grey.shade700 : Colors.black),
              width: 3,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.6),
                      blurRadius: 18,
                      spreadRadius: 3,
                    ),
                  ]
                : [
                    const BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: isActive
                      ? Colors.white
                      : (isDark ? Colors.white : Colors.black),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isActive ? "ENCENDIDO" : "POD ${podIndex + 1}",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? Colors.white.withValues(alpha: 0.9)
                      : (isDark ? Colors.grey[400] : Colors.grey[700]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}