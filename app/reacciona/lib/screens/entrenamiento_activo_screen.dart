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
  ConsumerState<EntrenamientoActivoScreen> createState() => _EntrenamientoActivoScreenState();
}

class _EntrenamientoActivoScreenState extends ConsumerState<EntrenamientoActivoScreen> {
  int rondaActual = 0;
  late int rondasTotal;
  List<double> tiemposObtenidos = [];
  bool esperandoSensor = false;
  bool enPausaEntreRondas = false;
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
    rondasTotal = widget.config['rondasTotal'];
    WidgetsBinding.instance.addPostFrameCallback((_) => iniciarSiguienteRonda());
  }

  List<int> obtenerRGBRonda() {
    if (widget.config['colorAleatorio'] == true) {
      return listaRGB[Random().nextInt(listaRGB.length)];
    }
    return List<int>.from(widget.config['rgbBase']);
  }

  Future<void> iniciarSiguienteRonda() async {
    if (rondaActual >= rondasTotal) {
      finalizarEntrenamiento();
      return;
    }

    setState(() {
      rondaActual++;
      enPausaEntreRondas = true;
      esperandoSensor = false;
      estadoTexto = "¡Atento! El LED se encenderá pronto...";
    });

    int tiempoEsperaMs = 1500 + Random().nextInt(2500);
    await Future.delayed(Duration(milliseconds: tiempoEsperaMs));

    if (!mounted) return;

    List<int> rgb = obtenerRGBRonda();
    String comando = "EMPEZAR:${rgb[0]},${rgb[1]},${rgb[2]}";

    ref.read(bluetoothProvider.notifier).enviarComando(comando);

    setState(() {
      enPausaEntreRondas = false;
      esperandoSensor = true;
      estadoTexto = "¡PASA LA MANO POR EL SENSOR!";
    });
  }

  void procesarTiempoRespuesta(String ultimoTiempoStr) {
    if (!esperandoSensor) return;

    double tiempoSeg = double.tryParse(ultimoTiempoStr.replaceAll(" s", "")) ?? 0.0;
    tiemposObtenidos.add(tiempoSeg);

    setState(() {
      esperandoSensor = false;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) iniciarSiguienteRonda();
    });
  }

  Future<void> finalizarEntrenamiento() async {
    double promedio = tiemposObtenidos.isEmpty
        ? 0
        : tiemposObtenidos.reduce((a, b) => a + b) / tiemposObtenidos.length;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = FirebaseDatabase.instance.ref("usuarios/${user.uid}/sesiones");
      await ref.push().set({
        "rondas": rondasTotal,
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
        content: Text("Completaste $rondasTotal rondas.\nPromedio: ${promedio.toStringAsFixed(3)} s"),
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
      if (prev?.ultimoTiempo != next.ultimoTiempo && esperandoSensor) {
        procesarTiempoRespuesta(next.ultimoTiempo);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Ronda $rondaActual de $rondasTotal"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                esperandoSensor ? Icons.bolt : Icons.timer,
                size: 80,
                color: esperandoSensor ? Colors.amber : Colors.blue,
              ),
              const SizedBox(height: 20),
              Text(
                estadoTexto,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              if (tiemposObtenidos.isNotEmpty) ...[
                Text(
                  "Último tiempo: ${tiemposObtenidos.last.toStringAsFixed(3)} s",
                  style: const TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}