import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
import '../provider/bluetooth_provider.dart';
import '../provider/sound_provider.dart';

enum ModoEntrenamiento { rondas, tiempo, manual, bicolor }

class ConfigEntrenamientoScreen extends ConsumerStatefulWidget {
  const ConfigEntrenamientoScreen({super.key});

  @override
  ConsumerState<ConfigEntrenamientoScreen> createState() =>
      _ConfigEntrenamientoScreenState();
}

class _ConfigEntrenamientoScreenState
    extends ConsumerState<ConfigEntrenamientoScreen> {
  ModoEntrenamiento _modo = ModoEntrenamiento.rondas;
  int _cantidadPods = 4;
  int _rondas = 10;
  int _tiempoLimiteSeg = 30;

  String _colorSeleccionado = 'Verde';
  String _colorSeleccionado2 = 'Rojo';

  int _intensidad = 100;
  double _tiempoEntrePodsSeg = 1.0;
  double _tiempoDistractorSeg = 2.0;

  int _customR = 242;
  int _customG = 21;
  int _customB = 242;

  final List<String> _coloresDisponibles = [
    'Rojo',
    'Naranja',
    'Amarillo',
    'Verde',
    'Azul',
    'Celeste',
    'Violeta',
    'Personalizado',
    'Aleatorio'
  ];

  final List<String> _coloresBicolor = [
    'Rojo',
    'Naranja',
    'Amarillo',
    'Verde',
    'Azul',
    'Celeste',
    'Violeta',
  ];

  List<int> _colorNameToRGB(String color) {
    switch (color) {
      case 'Rojo':
        return [255, 0, 0];
      case 'Naranja':
        return [255, 128, 0];
      case 'Amarillo':
        return [255, 255, 0];
      case 'Verde':
        return [0, 255, 0];
      case 'Azul':
        return [0, 0, 255];
      case 'Celeste':
        return [0, 191, 255];
      case 'Violeta':
        return [128, 0, 128];
      default:
        return [0, 255, 0];
    }
  }

  void _cambiarModo(ModoEntrenamiento nuevoModo) {
    setState(() {
      _modo = nuevoModo;
      if (_modo == ModoEntrenamiento.bicolor) {
        if (!_coloresBicolor.contains(_colorSeleccionado)) {
          _colorSeleccionado = 'Verde';
        }
        if (_colorSeleccionado == _colorSeleccionado2) {
          _colorSeleccionado2 = _colorSeleccionado == 'Rojo' ? 'Verde' : 'Rojo';
        }
      }
    });
  }

  void _navegarAEntrenamiento(AppLocalizations loc) {
    final btState = ref.read(bluetoothProvider);
    final messenger = ScaffoldMessenger.of(context);

    messenger.clearSnackBars();

    if (!btState.conectado) {
      messenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Expanded(
                child: Text(loc.errorBluetoothRequerido),
              ),
              TextButton(
                onPressed: () {
                  messenger.hideCurrentSnackBar();
                  context.push('/bluetooth');
                },
                child: Text(
                  loc.conectar,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_modo == ModoEntrenamiento.bicolor &&
        _colorSeleccionado == _colorSeleccionado2) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(loc.errorBicolorColoresIguales),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    ref.read(soundServiceProvider).playStart();

    List<int> rgbBase;
    if (_colorSeleccionado == 'Personalizado') {
      rgbBase = [_customR, _customG, _customB];
    } else {
      rgbBase = _colorNameToRGB(_colorSeleccionado);
    }

    List<int> rgbBase2 = _colorNameToRGB(_colorSeleccionado2);

    String modoStr = 'rondas';
    if (_modo == ModoEntrenamiento.tiempo) modoStr = 'tiempo';
    if (_modo == ModoEntrenamiento.manual) modoStr = 'manual';
    if (_modo == ModoEntrenamiento.bicolor) modoStr = 'bicolor';

    final config = {
      'modo': modoStr,
      'cantidadPods': _cantidadPods,
      'rondasTotal': (_modo == ModoEntrenamiento.rondas || _modo == ModoEntrenamiento.bicolor) ? _rondas : 0,
      'tiempoLimiteSeg': _tiempoLimiteSeg,
      'colorAleatorio': _colorSeleccionado == 'Aleatorio',
      'rgbBase': rgbBase,
      'rgbBase2': rgbBase2,
      'intensidad': _intensidad,
      'tiempoEntrePodsSeg': _tiempoEntrePodsSeg,
      'tiempoDistractorSeg': _tiempoDistractorSeg,
    };

    context.push('/entrenamiento-activo', extra: config);
  }

  Widget _buildRgbSlider({
    required String label,
    required int value,
    required Color activeColor,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: activeColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 60,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54, width: 1.5),
              borderRadius: BorderRadius.circular(4),
              color: Theme.of(context).cardColor,
            ),
            child: Text(
              '$value',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: activeColor,
                thumbColor: activeColor,
                inactiveTrackColor: activeColor.withValues(alpha: 0.2),
              ),
              child: Slider(
                value: value.toDouble(),
                min: 0,
                max: 255,
                divisions: 255,
                label: '$value',
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.configurarEntrenamiento),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.cantidadPodsActivos,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.sensors, color: Colors.blueAccent),
                        const SizedBox(width: 12),
                        Text(
                          loc.podsAUtilizar,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    DropdownButton<int>(
                      value: _cantidadPods,
                      borderRadius: BorderRadius.circular(12),
                      underline: const SizedBox(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                      items: [1, 2, 3, 4, 5, 6].map((numPods) {
                        return DropdownMenuItem<int>(
                          value: numPods,
                          child: Text('$numPods Pod${numPods > 1 ? "s" : ""}'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _cantidadPods = val);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              loc.seleccionaElModo,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: RadioGroup<ModoEntrenamiento>(
                groupValue: _modo,
                onChanged: (val) {
                  if (val != null) _cambiarModo(val);
                },
                child: Column(
                  children: [
                    RadioListTile<ModoEntrenamiento>(
                      title: Text(loc.porRondas),
                      subtitle: Text(loc.completaNumeroFijo),
                      value: ModoEntrenamiento.rondas,
                    ),
                    const Divider(height: 1),
                    RadioListTile<ModoEntrenamiento>(
                      title: Text(loc.porTiempo),
                      subtitle: Text(loc.tocaMayorCantidad),
                      value: ModoEntrenamiento.tiempo,
                    ),
                    const Divider(height: 1),
                    RadioListTile<ModoEntrenamiento>(
                      title: Text(loc.modoBicolor),
                      subtitle: Text(loc.desactivaColor1),
                      value: ModoEntrenamiento.bicolor,
                    ),
                    const Divider(height: 1),
                    RadioListTile<ModoEntrenamiento>(
                      title: Text(loc.modoManual),
                      subtitle: Text(loc.controlaLuzDirectamente),
                      value: ModoEntrenamiento.manual,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              _modo == ModoEntrenamiento.rondas || _modo == ModoEntrenamiento.bicolor
                  ? loc.parametrosRondas
                  : (_modo == ModoEntrenamiento.tiempo
                      ? loc.parametrosTiempo
                      : loc.modoManual),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_modo == ModoEntrenamiento.rondas || _modo == ModoEntrenamiento.bicolor) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            loc.cantidadRondas,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Chip(
                            label: Text(
                              '$_rondas',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _rondas.toDouble(),
                        min: 5,
                        max: 30,
                        divisions: 25,
                        label: '$_rondas',
                        onChanged: (val) {
                          setState(() => _rondas = val.round());
                        },
                      ),
                    ] else if (_modo == ModoEntrenamiento.tiempo) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            loc.tiempoLimite,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Chip(
                            label: Text(
                              '$_tiempoLimiteSeg seg',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _tiempoLimiteSeg.toDouble(),
                        min: 10,
                        max: 120,
                        divisions: 11,
                        label: '$_tiempoLimiteSeg seg',
                        onChanged: (val) {
                          setState(() => _tiempoLimiteSeg = val.round());
                        },
                      ),
                    ] else ...[
                      Row(
                        children: [
                          const Icon(Icons.touch_app, color: Colors.blueAccent, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              loc.mensajeModoManual,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            if (_modo == ModoEntrenamiento.bicolor) ...[
              Text(
                loc.tiempoLimiteColor2,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.block, color: Colors.redAccent),
                              const SizedBox(width: 8),
                              Text(
                                loc.tiempoParaIgnorar,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Chip(
                            label: Text(
                              '${_tiempoDistractorSeg.toStringAsFixed(1)}s',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: Colors.redAccent,
                          thumbColor: Colors.redAccent,
                          inactiveTrackColor: Colors.redAccent.withValues(alpha: 0.2),
                        ),
                        child: Slider(
                          value: _tiempoDistractorSeg,
                          min: 1.0,
                          max: 5.0,
                          divisions: 40,
                          label: '${_tiempoDistractorSeg.toStringAsFixed(1)}s',
                          onChanged: (val) {
                            setState(() => _tiempoDistractorSeg = val);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            if (_modo != ModoEntrenamiento.manual) ...[
              Text(
                loc.intervaloEntrePods,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.timer_outlined, color: Colors.blueAccent),
                              const SizedBox(width: 8),
                              Text(
                                loc.pausaEntreToques,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Chip(
                            label: Text(
                              '${_tiempoEntrePodsSeg.toStringAsFixed(1)}s',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: Colors.blueAccent,
                          thumbColor: Colors.blueAccent,
                          inactiveTrackColor: Colors.blueAccent.withValues(alpha: 0.2),
                        ),
                        child: Slider(
                          value: _tiempoEntrePodsSeg,
                          min: 0.2,
                          max: 5.0,
                          divisions: 48,
                          label: '${_tiempoEntrePodsSeg.toStringAsFixed(1)}s',
                          onChanged: (val) {
                            setState(() => _tiempoEntrePodsSeg = val);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            Text(
              _modo == ModoEntrenamiento.bicolor ? loc.coloresBicolor : loc.colorLeds,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _modo == ModoEntrenamiento.bicolor
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            initialValue: _coloresBicolor.contains(_colorSeleccionado)
                                ? _colorSeleccionado
                                : 'Verde',
                            decoration: InputDecoration(
                              labelText: loc.color1ATocar,
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.palette, color: Colors.blueAccent),
                            ),
                            items: _coloresBicolor.map((color) {
                              return DropdownMenuItem(
                                value: color,
                                child: Text(color),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _colorSeleccionado = val);
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            initialValue: _coloresBicolor.contains(_colorSeleccionado2)
                                ? _colorSeleccionado2
                                : 'Rojo',
                            decoration: InputDecoration(
                              labelText: loc.color2NoTocar,
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.block, color: Colors.redAccent),
                            ),
                            items: _coloresBicolor.map((color) {
                              return DropdownMenuItem(
                                value: color,
                                child: Text(color),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _colorSeleccionado2 = val);
                            },
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            initialValue: _coloresDisponibles.contains(_colorSeleccionado)
                                ? _colorSeleccionado
                                : 'Verde',
                            decoration: InputDecoration(
                              labelText: loc.seleccionarColorBase,
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.palette),
                            ),
                            items: _coloresDisponibles.map((color) {
                              return DropdownMenuItem(
                                value: color,
                                child: Text(color),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _colorSeleccionado = val);
                              }
                            },
                          ),
                          if (_colorSeleccionado == 'Personalizado') ...[
                            const SizedBox(height: 20),
                            Text(
                              loc.ajusteColorRgb,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildRgbSlider(
                              label: 'R',
                              value: _customR,
                              activeColor: Colors.red,
                              onChanged: (val) => setState(() => _customR = val.round()),
                            ),
                            _buildRgbSlider(
                              label: 'G',
                              value: _customG,
                              activeColor: Colors.green,
                              onChanged: (val) => setState(() => _customG = val.round()),
                            ),
                            _buildRgbSlider(
                              label: 'B',
                              value: _customB,
                              activeColor: Colors.blue,
                              onChanged: (val) => setState(() => _customB = val.round()),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  loc.vistaPrevia,
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(_customR, _customG, _customB, 1.0),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.black26, width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromRGBO(_customR, _customG, _customB, 0.4),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              loc.intensidadLeds,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.brightness_6, color: Colors.orangeAccent),
                            const SizedBox(width: 8),
                            Text(
                              loc.brilloIntensidad,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Chip(
                          label: Text(
                            '$_intensidad%',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orangeAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: Colors.orangeAccent,
                        thumbColor: Colors.orangeAccent,
                        inactiveTrackColor: Colors.orangeAccent.withValues(alpha: 0.2),
                      ),
                      child: Slider(
                        value: _intensidad.toDouble(),
                        min: 10,
                        max: 100,
                        divisions: 18,
                        label: '$_intensidad%',
                        onChanged: (val) {
                          setState(() => _intensidad = val.round());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () => _navegarAEntrenamiento(loc),
                icon: const Icon(Icons.play_arrow, size: 28),
                label: Text(
                  loc.iniciarRutina,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}