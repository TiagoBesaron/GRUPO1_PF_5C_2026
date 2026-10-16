import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../provider/bluetooth_provider.dart';

enum ModoEntrenamiento { rondas, tiempo, manual }

class ConfigEntrenamientoScreen extends ConsumerStatefulWidget {
  const ConfigEntrenamientoScreen({super.key});

  @override
  ConsumerState<ConfigEntrenamientoScreen> createState() =>
      _ConfigEntrenamientoScreenState();
}

class _ConfigEntrenamientoScreenState
    extends ConsumerState<ConfigEntrenamientoScreen> {
  ModoEntrenamiento _modo = ModoEntrenamiento.rondas;
  int _rondas = 10;
  int _tiempoLimiteSeg = 30;
  String _colorSeleccionado = 'Verde';

  int _customR = 242;
  int _customG = 21;
  int _customB = 242;

  final List<String> _coloresDisponibles = [
    'Verde',
    'Rojo',
    'Azul',
    'Amarillo',
    'Personalizado',
    'Aleatorio'
  ];

  void _navegarAEntrenamiento() {
    final btState = ref.read(bluetoothProvider);

    if (!btState.conectado) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Debés conectar el ESP32 por Bluetooth antes de iniciar la rutina.',
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'CONECTAR',
            textColor: Colors.white,
            onPressed: () => context.push('/bluetooth'),
          ),
        ),
      );
      return;
    }

    List<int> rgbBase;
    switch (_colorSeleccionado) {
      case 'Rojo':
        rgbBase = [255, 0, 0];
        break;
      case 'Azul':
        rgbBase = [0, 0, 255];
        break;
      case 'Amarillo':
        rgbBase = [255, 255, 0];
        break;
      case 'Personalizado':
        rgbBase = [_customR, _customG, _customB];
        break;
      case 'Verde':
      default:
        rgbBase = [0, 255, 0];
        break;
    }

    String modoStr = 'rondas';
    if (_modo == ModoEntrenamiento.tiempo) modoStr = 'tiempo';
    if (_modo == ModoEntrenamiento.manual) modoStr = 'manual';

    final config = {
      'modo': modoStr,
      'rondasTotal': _modo == ModoEntrenamiento.rondas ? _rondas : 0,
      'tiempoLimiteSeg': _tiempoLimiteSeg,
      'colorAleatorio': _colorSeleccionado == 'Aleatorio',
      'rgbBase': rgbBase,
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
                inactiveTrackColor: activeColor.withOpacity(0.2),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurar Entrenamiento'),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecciona el Modo',
              style: TextStyle(
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
              child: Column(
                children: [
                  RadioListTile<ModoEntrenamiento>(
                    title: const Text('Por Rondas'),
                    subtitle: const Text('Completa un número fijo de toques'),
                    value: ModoEntrenamiento.rondas,
                    groupValue: _modo,
                    onChanged: (val) {
                      if (val != null) setState(() => _modo = val);
                    },
                  ),
                  const Divider(height: 1),
                  RadioListTile<ModoEntrenamiento>(
                    title: const Text('Por Tiempo'),
                    subtitle: const Text('Toca la mayor cantidad antes de que venza el tiempo'),
                    value: ModoEntrenamiento.tiempo,
                    groupValue: _modo,
                    onChanged: (val) {
                      if (val != null) setState(() => _modo = val);
                    },
                  ),
                  const Divider(height: 1),
                  RadioListTile<ModoEntrenamiento>(
                    title: const Text('Modo Manual'),
                    subtitle: const Text('Controlá la luz directamente desde la app'),
                    value: ModoEntrenamiento.manual,
                    groupValue: _modo,
                    onChanged: (val) {
                      if (val != null) setState(() => _modo = val);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _modo == ModoEntrenamiento.rondas
                  ? 'Parámetros de Rondas'
                  : (_modo == ModoEntrenamiento.tiempo
                      ? 'Parámetros de Tiempo'
                      : 'Modo Manual'),
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
                    if (_modo == ModoEntrenamiento.rondas) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Cantidad de Rondas:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                        label: '$_rondas rondas',
                        onChanged: (val) {
                          setState(() => _rondas = val.round());
                        },
                      ),
                    ] else if (_modo == ModoEntrenamiento.tiempo) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tiempo Límite:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                      const Row(
                        children: [
                          Icon(Icons.touch_app, color: Colors.blueAccent, size: 28),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'En el Modo Manual podés encender y apagar el pod en cualquier momento con los botones de la pantalla.',
                              style: TextStyle(fontSize: 15),
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
            const Text(
              'Color de los LEDs',
              style: TextStyle(
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
                    DropdownButtonFormField<String>(
                      initialValue: _colorSeleccionado,
                      decoration: const InputDecoration(
                        labelText: 'Seleccionar Color Base',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.palette),
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
                      const Text(
                        'Ajuste de Color RGB:',
                        style: TextStyle(
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
                          const Text(
                            'Vista previa: ',
                            style: TextStyle(fontWeight: FontWeight.w500),
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
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _navegarAEntrenamiento,
                icon: const Icon(Icons.play_arrow, size: 28),
                label: const Text(
                  'INICIAR RUTINA',
                  style: TextStyle(
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