import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
import '../provider/bluetooth_provider.dart';
import '../provider/perfil_provider.dart';
import '../provider/user_mode_provider.dart';
import '../provider/sound_provider.dart';

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
  late int cantidadPods;
  late int tiempoLimiteSeg;
  int tiempoRestanteSeg = 0;

  Timer? _timerTiempo;
  Timer? _timerIntervaloPods;
  Timer? _timerCuentaRegresiva;
  Timer? _timerGraciaFinal;
  final Map<int, Timer> _timersDistractor = {};

  int cuentaRegresiva = 3;
  bool enCuentaRegresiva = false;
  bool enTiempoFinalGracia = false;
  int segundosGraciaRestantes = 10;

  // Nueva opción: Si es true solo se enciende 1 pod a la vez (debe apagarse para pasar al siguiente)
  bool soloUnoAlaVez = false;

  late String modo;
  List<double> tiemposObtenidos = [];
  int cantidadErrores = 0;
  bool sesionTerminada = false;

  // Manejo de estado multi-pod encendido
  final Set<int> podsEncendidos = {};
  final Map<int, List<int>> podColores = {};
  final Map<int, bool> podIsColor1 = {};
  final Map<int, DateTime> podTiemposEncendido = {};

  String estadoTexto = "";

  final List<List<int>> listaRGB = [
    [255, 0, 0],
    [255, 128, 0],
    [255, 255, 0],
    [0, 255, 0],
    [0, 0, 255],
    [0, 191, 255],
    [128, 0, 128],
  ];

  @override
  void initState() {
    super.initState();
    modo = widget.config['modo'] ?? 'rondas';
    cantidadPods = widget.config['cantidadPods'] ?? 3;
    rondasTotal = widget.config['rondasTotal'] ?? 10;
    tiempoLimiteSeg = widget.config['tiempoLimiteSeg'] ?? 30;
    soloUnoAlaVez = widget.config['soloUnoAlaVez'] ?? false;

    if (modo == 'manual') {
      enCuentaRegresiva = false;
      estadoTexto = "Modo Manual: Toca un Pod en pantalla para encenderlo";
    } else {
      _iniciarCuentaRegresiva();
    }
  }

  void _iniciarCuentaRegresiva() {
    setState(() {
      enCuentaRegresiva = true;
      cuentaRegresiva = 3;
    });

    _timerCuentaRegresiva?.cancel();
    _timerCuentaRegresiva =
        Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || sesionTerminada) {
        timer.cancel();
        return;
      }

      if (cuentaRegresiva > 1) {
        setState(() {
          cuentaRegresiva--;
        });
      } else {
        timer.cancel();
        setState(() {
          enCuentaRegresiva = false;
        });

        ref.read(soundServiceProvider).playStart();

        if (modo == 'tiempo') {
          tiempoRestanteSeg = tiempoLimiteSeg;
          _iniciarCronometro();
        }
        _iniciarBucleIntervalos();
      }
    });
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
        _iniciarFaseGracia10Segundos();
      } else {
        setState(() {
          tiempoRestanteSeg--;
        });
      }
    });
  }

  List<int> obtenerRGBRonda(bool esColor1) {
    double factorIntensidad =
        ((widget.config['intensidad'] ?? 100) as num) / 100.0;
    List<int> rawRgb;

    if (modo == 'bicolor') {
      List<int> c1 = List<int>.from(widget.config['rgbBase'] ?? [0, 255, 0]);
      List<int> c2 = List<int>.from(widget.config['rgbBase2'] ?? [255, 0, 0]);
      rawRgb = esColor1 ? c1 : c2;
    } else if (widget.config['colorAleatorio'] == true) {
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

  void _iniciarBucleIntervalos() {
    double delaySeg =
        ((widget.config['tiempoEntrePodsSeg'] ?? 1.0) as num).toDouble();
    int intervaloMs = (delaySeg * 1000).round();

    _intentarEncenderSiguientePod();

    if (modo == 'manual') return;

    _timerIntervaloPods?.cancel();
    _timerIntervaloPods =
        Timer.periodic(Duration(milliseconds: intervaloMs), (timer) {
      if (!mounted || sesionTerminada || enTiempoFinalGracia) {
        timer.cancel();
        return;
      }

      if (modo == 'rondas' || modo == 'bicolor') {
        if (rondaActual >= rondasTotal) {
          timer.cancel();
          _iniciarFaseGracia10Segundos();
          return;
        }
      }

      _intentarEncenderSiguientePod();
    });
  }

  void _intentarEncenderSiguientePod() {
    if (sesionTerminada || enTiempoFinalGracia) return;
    final loc = AppLocalizations.of(context);

    // Si está activa la opción "Uno a Uno", no encender otro pod hasta apagar el activo
    if (soloUnoAlaVez && podsEncendidos.isNotEmpty) {
      return;
    }

    List<int> podsDisponibles = [];
    for (int i = 0; i < cantidadPods; i++) {
      if (!podsEncendidos.contains(i)) {
        podsDisponibles.add(i);
      }
    }

    if (modo == 'rondas' || modo == 'bicolor') {
      if (rondaActual >= rondasTotal) {
        _timerIntervaloPods?.cancel();
        _iniciarFaseGracia10Segundos();
        return;
      }
      setState(() {
        rondaActual++;
      });
    }

    // Si todos los pods están encendidos en modo simultáneo -> Suma Error por saturación
    if (podsDisponibles.isEmpty) {
      setState(() {
        cantidadErrores++;
        estadoTexto = "¡Pods saturados! (+1 Error)";
      });
      return;
    }

    int podElegido = podsDisponibles[Random().nextInt(podsDisponibles.length)];
    bool esColor1 = true;
    if (modo == 'bicolor') {
      esColor1 = Random().nextBool();
    }

    List<int> rgb = obtenerRGBRonda(esColor1);

    String comando = "EMPEZAR:$podElegido,${rgb[0]},${rgb[1]},${rgb[2]}";
    ref.read(bluetoothProvider.notifier).enviarComando(comando);

    setState(() {
      podsEncendidos.add(podElegido);
      podColores[podElegido] = rgb;
      podIsColor1[podElegido] = esColor1;
      podTiemposEncendido[podElegido] = DateTime.now();

      if (modo == 'bicolor') {
        estadoTexto = esColor1
            ? loc.tocaPodColor1(podElegido + 1)
            : loc.noTocarColor2(podElegido + 1);
      } else {
        estadoTexto = loc.pasaManoPorPod(podElegido + 1);
      }
    });

    if (modo == 'bicolor' && !esColor1) {
      double distractorSeg =
          ((widget.config['tiempoDistractorSeg'] ?? 2.0) as num).toDouble();
      int distractorMs = (distractorSeg * 1000).round();

      _timersDistractor[podElegido]?.cancel();
      _timersDistractor[podElegido] =
          Timer(Duration(milliseconds: distractorMs), () {
        if (mounted && podsEncendidos.contains(podElegido) && !sesionTerminada) {
          _apagarPodSilencioso(podElegido);
          setState(() {
            estadoTexto = loc.excelenteColorIgnorado;
          });
        }
      });
    }
  }

  void _apagarPodSilencioso(int podIndex) {
    _timersDistractor[podIndex]?.cancel();
    _timersDistractor.remove(podIndex);

    String comando = "EMPEZAR:$podIndex,0,0,0";
    ref.read(bluetoothProvider.notifier).enviarComando(comando);

    setState(() {
      podsEncendidos.remove(podIndex);
      podColores.remove(podIndex);
      podIsColor1.remove(podIndex);
      podTiemposEncendido.remove(podIndex);
    });
  }

  void _apagarTodosLosPods() {
    for (int pod in podsEncendidos.toList()) {
      _apagarPodSilencioso(pod);
    }
  }

  void _togglePodManual(int podIndex) {
    if (sesionTerminada || enTiempoFinalGracia) return;

    if (podsEncendidos.contains(podIndex)) {
      _tocaped(podIndex);
    } else {
      if (soloUnoAlaVez && podsEncendidos.isNotEmpty) {
        setState(() {
          estadoTexto = "Debes apagar el pod encendido antes de activar otro";
        });
        return;
      }

      if (podsEncendidos.length >= cantidadPods) {
        setState(() {
          cantidadErrores++;
          estadoTexto = "¡Todos los pods encendidos! (+1 Error)";
        });
        return;
      }

      List<int> rgb = obtenerRGBRonda(true);
      String comando = "EMPEZAR:$podIndex,${rgb[0]},${rgb[1]},${rgb[2]}";
      ref.read(bluetoothProvider.notifier).enviarComando(comando);

      setState(() {
        podsEncendidos.add(podIndex);
        podColores[podIndex] = rgb;
        podTiemposEncendido[podIndex] = DateTime.now();
        estadoTexto = "Pod ${podIndex + 1} encendido";
      });
    }
  }

  void _tocaped(int podIndex) {
    if (!podsEncendidos.contains(podIndex) || sesionTerminada) return;
    final loc = AppLocalizations.of(context);

    DateTime? horaInicio = podTiemposEncendido[podIndex];
    double tiempoSeg = horaInicio != null
        ? DateTime.now().difference(horaInicio).inMilliseconds / 1000.0
        : 0.0;

    bool esColor1 = podIsColor1[podIndex] ?? true;

    _apagarPodSilencioso(podIndex);

    if (modo == 'bicolor') {
      if (esColor1) {
        tiemposObtenidos.add(tiempoSeg);
        setState(() {
          estadoTexto = loc.toqueEnPod(podIndex + 1, tiempoSeg.toStringAsFixed(3));
        });
      } else {
        setState(() {
          cantidadErrores++;
          estadoTexto = loc.errorTocasteColor2(podIndex + 1);
        });
      }
    } else {
      tiemposObtenidos.add(tiempoSeg);
      setState(() {
        estadoTexto = loc.toqueEnPod(podIndex + 1, tiempoSeg.toStringAsFixed(3));
      });
    }

    // En modo "Uno a Uno", al apagar el pod se dispara de inmediato el siguiente
    if (soloUnoAlaVez && modo != 'manual' && !enTiempoFinalGracia) {
      _intentarEncenderSiguientePod();
    }
  }

  void procesarTiempoRespuesta(String ultimoTiempoStr) {
    if (podsEncendidos.isEmpty || sesionTerminada) return;

    int podAfectado = podsEncendidos.first;
    _tocaped(podAfectado);
  }

  void _solicitarFinalizacionSesion() {
    if (enTiempoFinalGracia || sesionTerminada) return;

    if (podsEncendidos.isNotEmpty) {
      _iniciarFaseGracia10Segundos();
    } else {
      finalizarEntrenamiento();
    }
  }

  void _iniciarFaseGracia10Segundos() {
    _timerIntervaloPods?.cancel();
    if (enTiempoFinalGracia || sesionTerminada) return;

    setState(() {
      enTiempoFinalGracia = true;
      segundosGraciaRestantes = 10;
      estadoTexto = "¡Fase Final (+10s)! Apaga los pods activos.";
    });

    _timerGraciaFinal?.cancel();
    _timerGraciaFinal = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || sesionTerminada) {
        timer.cancel();
        return;
      }

      if (segundosGraciaRestantes > 1) {
        setState(() {
          segundosGraciaRestantes--;
        });
      } else {
        timer.cancel();
        setState(() {
          segundosGraciaRestantes = 0;
        });

        int podsQuedaronPrendidos = podsEncendidos.length;
        if (podsQuedaronPrendidos > 0) {
          cantidadErrores += podsQuedaronPrendidos;
        }

        finalizarEntrenamiento();
      }
    });
  }

  void _mostrarErrorDesconexion() {
    if (sesionTerminada || !mounted) return;

    final loc = AppLocalizations.of(context);
    _timerCuentaRegresiva?.cancel();
    _timerTiempo?.cancel();
    _timerIntervaloPods?.cancel();
    _timerGraciaFinal?.cancel();

    setState(() {
      sesionTerminada = true;
    });

    _apagarTodosLosPods();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.bluetooth_disabled, color: Colors.redAccent),
            const SizedBox(width: 8),
            Text(loc.desconectado),
          ],
        ),
        content: Text(loc.errorDesconexionMensaje),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/home');
            },
            child: Text(loc.volverAlInicio),
          ),
        ],
      ),
    );
  }

  Future<void> finalizarEntrenamiento() async {
    if (sesionTerminada) return;
    final loc = AppLocalizations.of(context);

    _timerCuentaRegresiva?.cancel();
    _timerTiempo?.cancel();
    _timerIntervaloPods?.cancel();
    _timerGraciaFinal?.cancel();

    setState(() => sesionTerminada = true);

    _apagarTodosLosPods();
    ref.read(soundServiceProvider).playFinish();

    double promedio = tiemposObtenidos.isEmpty
        ? 0
        : tiemposObtenidos.reduce((a, b) => a + b) / tiemposObtenidos.length;

    final user = FirebaseAuth.instance.currentUser;
    final perfilActivo = ref.read(perfilActivoProvider);
    final esModoProfesional = ref.read(modoProfesionalProvider);

    final notasController = TextEditingController();

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(loc.entrenamientoFinalizado),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (esModoProfesional) ...[
                Text(
                  loc.usuario(perfilActivo?.nombre ?? loc.perfilPrincipal),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
              ],
              Text(loc.toquesValidos(tiemposObtenidos.length)),
              Text(loc.promedioSegundos(promedio.toStringAsFixed(3))),
              Text(loc.erroresCometidos(cantidadErrores)),
              const SizedBox(height: 16),

              TextField(
                controller: notasController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: loc.anotacionesSesionOpcional,
                  hintText: loc.hintAnotaciones,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.note_add_outlined),
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (user != null &&
                  (tiemposObtenidos.isNotEmpty || cantidadErrores > 0)) {
                final refBD = FirebaseDatabase.instance
                    .ref("usuarios/${user.uid}/sesiones");
                await refBD.push().set({
                  "rondas": tiemposObtenidos.length,
                  "modo": modo,
                  "cantidad_pods": cantidadPods,
                  "promedio_seg": promedio,
                  "tiempos": tiemposObtenidos,
                  "errores": cantidadErrores,
                  "solo_uno_a_la_vez": soloUnoAlaVez,
                  "perfil_id": esModoProfesional
                      ? (perfilActivo?.id ?? "principal")
                      : "principal",
                  "perfil_nombre": esModoProfesional
                      ? (perfilActivo?.nombre ?? "Perfil Principal")
                      : "Uso Personal",
                  "notas_sesion": notasController.text.trim(),
                  "timestamp": ServerValue.timestamp,
                });
              }

              if (context.mounted) {
                Navigator.pop(context);
                context.go('/home');
              }
            },
            child: Text(loc.guardarYFinalizar),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timerCuentaRegresiva?.cancel();
    _timerTiempo?.cancel();
    _timerIntervaloPods?.cancel();
    _timerGraciaFinal?.cancel();
    for (var t in _timersDistractor.values) {
      t.cancel();
    }
    _apagarTodosLosPods();
    super.dispose();
  }

  String _getTituloAppBar(AppLocalizations loc) {
    if (enCuentaRegresiva) {
      return loc.aparatoListo;
    } else if (enTiempoFinalGracia) {
      return "Fase Final: ${segundosGraciaRestantes}s";
    } else if (modo == 'manual') {
      return loc.modoManualToques(tiemposObtenidos.length);
    } else if (modo == 'tiempo') {
      return loc.tiempoRestanteToques(tiemposObtenidos.length, tiempoRestanteSeg);
    } else if (modo == 'bicolor') {
      return loc.bicolorRonda(rondaActual, rondasTotal);
    } else {
      return loc.rondaDe(rondaActual, rondasTotal);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    ref.listen<BluetoothState>(bluetoothProvider, (prev, next) {
      if (prev?.conectado == true && !next.conectado) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _mostrarErrorDesconexion();
        });
        return;
      }

      if (prev?.reactionTicket != next.reactionTicket && podsEncendidos.isNotEmpty) {
        procesarTiempoRespuesta(next.ultimoTiempo);
      }
    });

    List<int> defaultRgb = obtenerRGBRonda(true);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final perfilActivo = ref.watch(perfilActivoProvider);
    final esModoProfesional = ref.watch(modoProfesionalProvider);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          _timerCuentaRegresiva?.cancel();
          _timerTiempo?.cancel();
          _timerIntervaloPods?.cancel();
          _timerGraciaFinal?.cancel();
          _apagarTodosLosPods();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_getTituloAppBar(loc)),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (esModoProfesional) ...[
                  Chip(
                    avatar: const Icon(Icons.person, size: 16),
                    label: Text(
                      perfilActivo?.nombre ?? loc.perfilPrincipal,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    backgroundColor:
                        isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                  ),
                  const SizedBox(height: 12),
                ],

                // Control selector: Simultáneo vs Uno a Uno (Secuencial)
                if (!enCuentaRegresiva && !enTiempoFinalGracia) ...[
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment<bool>(
                        value: false,
                        label: Text("Simultáneo"),
                        icon: Icon(Icons.style_outlined),
                      ),
                      ButtonSegment<bool>(
                        value: true,
                        label: Text("Uno a Uno"),
                        icon: Icon(Icons.touch_app_outlined),
                      ),
                    ],
                    selected: {soloUnoAlaVez},
                    onSelectionChanged: (Set<bool> newSelection) {
                      setState(() {
                        soloUnoAlaVez = newSelection.first;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                if (enTiempoFinalGracia) ...[
                  Chip(
                    avatar: const Icon(Icons.hourglass_bottom, color: Colors.white, size: 18),
                    label: Text(
                      "Tiempo final: ${segundosGraciaRestantes}s",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                  const SizedBox(height: 16),
                ] else if (modo == 'tiempo' && !enCuentaRegresiva) ...[
                  Chip(
                    avatar:
                        const Icon(Icons.timer, color: Colors.white, size: 18),
                    label: Text(
                      loc.tiempoRestante(tiempoRestanteSeg),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: tiempoRestanteSeg <= 5
                        ? Colors.redAccent
                        : Colors.orange,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                  ),
                  const SizedBox(height: 16),
                ],

                if (enCuentaRegresiva) ...[
                  Container(
                    width: 140,
                    height: 140,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orangeAccent.withValues(alpha: 0.15),
                      border: Border.all(color: Colors.orangeAccent, width: 4),
                    ),
                    child: Text(
                      "$cuentaRegresiva",
                      style: const TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent,
                      ),
                    ),
                  ),
                ] else ...[
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: List.generate(cantidadPods, (index) {
                      bool isPodOn = podsEncendidos.contains(index);
                      List<int> pRgb = podColores[index] ?? defaultRgb;
                      Color pColor = Color.fromRGBO(pRgb[0], pRgb[1], pRgb[2], 1.0);

                      return _buildPodSquare(
                        podIndex: index,
                        label: "${index + 1}",
                        isActive: isPodOn,
                        activeColor: pColor,
                        isDark: isDark,
                        loc: loc,
                      );
                    }),
                  ),
                ],

                const SizedBox(height: 24),

                Text(
                  estadoTexto.isEmpty ? loc.preparate : estadoTexto,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          isDark ? Colors.grey.shade800 : Colors.grey.shade300,
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
                      Text(
                        loc.ultimoTiempoValido,
                        style: const TextStyle(
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
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            loc.toquesValidos(tiemposObtenidos.length),
                            style: TextStyle(
                              fontSize: 13,
                              color:
                                  isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              loc.erroresCometidos(cantidadErrores),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: _solicitarFinalizacionSesion,
                    icon: const Icon(Icons.stop_circle_outlined,
                        color: Colors.redAccent),
                    label: Text(
                      loc.finalizarSesion,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: Colors.redAccent, width: 1.5),
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
      ),
    );
  }

  Widget _buildPodSquare({
    required int podIndex,
    required String label,
    required bool isActive,
    required Color activeColor,
    required bool isDark,
    required AppLocalizations loc,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _togglePodManual(podIndex),
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 85,
          height: 85,
          decoration: BoxDecoration(
            color: isActive
                ? activeColor
                : (isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade100),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isActive
                  ? activeColor
                  : (isDark ? Colors.grey.shade700 : Colors.black26),
              width: 2.5,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.6),
                      blurRadius: 16,
                      spreadRadius: 2,
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
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: isActive
                      ? Colors.white
                      : (isDark ? Colors.white : Colors.black),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isActive ? loc.encendido : loc.podLabel(podIndex + 1),
                style: TextStyle(
                  fontSize: 10,
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