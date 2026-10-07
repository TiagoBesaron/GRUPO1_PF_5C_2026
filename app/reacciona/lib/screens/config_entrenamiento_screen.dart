import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum ModoEntrenamiento { rondas, tiempo }

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

  final List<String> _coloresDisponibles = [
    'Verde',
    'Rojo',
    'Azul',
    'Amarillo',
    'Aleatorio'
  ];

  void _navegarAEntrenamiento() {
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
      case 'Verde':
      default:
        rgbBase = [0, 255, 0];
        break;
    }

    final config = {
      'modo': _modo == ModoEntrenamiento.rondas ? 'rondas' : 'tiempo',
      'rondasTotal': _modo == ModoEntrenamiento.rondas ? _rondas : 5,
      'tiempoLimiteSeg': _tiempoLimiteSeg,
      'colorAleatorio': _colorSeleccionado == 'Aleatorio',
      'rgbBase': rgbBase,
    };

    context.push('/entrenamiento-activo', extra: config);
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
              child: RadioGroup<ModoEntrenamiento>(
                groupValue: _modo,
                onChanged: (val) {
                  if (val != null) setState(() => _modo = val);
                },
                child: Column(
                  children: const [
                    RadioListTile<ModoEntrenamiento>(
                      title: Text('Por Rondas'),
                      subtitle: Text('Completa un número fijo de toques'),
                      value: ModoEntrenamiento.rondas,
                    ),
                    Divider(height: 1),
                    RadioListTile<ModoEntrenamiento>(
                      title: Text('Por Tiempo'),
                      subtitle: Text('Toca la mayor cantidad antes de que venza el tiempo'),
                      value: ModoEntrenamiento.tiempo,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _modo == ModoEntrenamiento.rondas
                  ? 'Parámetros de Rondas'
                  : 'Parámetros de Tiempo',
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
                        max: 50,
                        divisions: 9,
                        label: '$_rondas rondas',
                        onChanged: (val) {
                          setState(() => _rondas = val.round());
                        },
                      ),
                    ] else ...[
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
                child: DropdownButtonFormField<String>(
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