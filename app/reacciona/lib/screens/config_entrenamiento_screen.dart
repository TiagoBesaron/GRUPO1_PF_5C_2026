import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum ModoEntrenamiento { rondas, tiempo }

class ConfigEntrenamientoScreen extends StatefulWidget {
  final bool isEsp32Connected;

  const ConfigEntrenamientoScreen({
    super.key,
    this.isEsp32Connected = false,
  });

  @override
  State<ConfigEntrenamientoScreen> createState() =>
      _ConfigEntrenamientoScreenState();
}

class _ConfigEntrenamientoScreenState
    extends State<ConfigEntrenamientoScreen> {
  ModoEntrenamiento _modo = ModoEntrenamiento.rondas;
  int _rondas = 5;
  int _tiempoLimiteSeg = 30;
  String _colorSeleccionado = 'Verde';

  final List<Map<String, dynamic>> _coloresDisponibles = [
    {'nombre': 'Verde', 'color': Colors.green},
    {'nombre': 'Rojo', 'color': Colors.red},
    {'nombre': 'Azul', 'color': Colors.blue},
    {'nombre': 'Amarillo', 'color': Colors.amber},
    {'nombre': 'Aleatorio', 'color': Colors.purpleAccent},
  ];

  void _iniciarRutina() {
    if (!widget.isEsp32Connected) {
      _mostrarAdvertenciaDesconectado();
    } else {
      _navegarAEntrenamiento();
    }
  }

  void _navegarAEntrenamiento() {
    final config = {
      'modo': _modo == ModoEntrenamiento.rondas ? 'rondas' : 'tiempo',
      'valor': _modo == ModoEntrenamiento.rondas ? _rondas : _tiempoLimiteSeg,
      'color': _colorSeleccionado,
    };

    context.push('/entrenamiento-activo', extra: config);
  }

  void _mostrarAdvertenciaDesconectado() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(
          Icons.bluetooth_disabled,
          color: Colors.redAccent,
          size: 48,
        ),
        title: const Text(
          'ESP32 Desconectado',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'El dispositivo ESP32 no está conectado por Bluetooth.\n\n¿Deseás conectarlo ahora o iniciar en modo prueba?',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _navegarAEntrenamiento(); // Inicia la rutina en modo prueba
            },
            child: const Text('Modo Prueba'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.push('/bluetooth');
            },
            icon: const Icon(Icons.bluetooth_searching, size: 18),
            label: const Text('Conectar'),
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Ajustes de la Sesión",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // SELECTOR DE MODO
              const Text(
                "Modalidad de objetivo:",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              SegmentedButton<ModoEntrenamiento>(
                segments: const [
                  ButtonSegment<ModoEntrenamiento>(
                    value: ModoEntrenamiento.rondas,
                    label: Text('Por Rondas'),
                    icon: Icon(Icons.flag_outlined),
                  ),
                  ButtonSegment<ModoEntrenamiento>(
                    value: ModoEntrenamiento.tiempo,
                    label: Text('Por Tiempo'),
                    icon: Icon(Icons.timer_outlined),
                  ),
                ],
                selected: {_modo},
                onSelectionChanged: (Set<ModoEntrenamiento> newSelection) {
                  setState(() {
                    _modo = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 24),

              // CONTADOR DINÁMICO
              if (_modo == ModoEntrenamiento.rondas) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Número de rondas:",
                        style: TextStyle(fontSize: 16)),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: _rondas > 1
                              ? () => setState(() => _rondas--)
                              : null,
                        ),
                        Text(
                          "$_rondas",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => setState(() => _rondas++),
                        ),
                      ],
                    ),
                  ],
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Tiempo total de sesión:",
                        style: TextStyle(fontSize: 16)),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: _tiempoLimiteSeg > 5
                              ? () => setState(() => _tiempoLimiteSeg -= 5)
                              : null,
                        ),
                        Text(
                          "$_tiempoLimiteSeg s",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => setState(() => _tiempoLimiteSeg += 5),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
              const Divider(height: 32),

              // SELECCIÓN DE COLOR
              const Text(
                "Color de respuesta:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _coloresDisponibles.map((item) {
                  final String nombre = item['nombre'];
                  final Color color = item['color'];
                  final bool seleccionado = _colorSeleccionado == nombre;

                  return ChoiceChip(
                    label: Text(nombre),
                    avatar: nombre == 'Aleatorio'
                        ? const Icon(Icons.shuffle, size: 18)
                        : CircleAvatar(
                            backgroundColor: color,
                            radius: 8,
                          ),
                    selected: seleccionado,
                    selectedColor: color.withValues(alpha: 0.25),
                    checkmarkColor: color,
                    labelStyle: TextStyle(
                      color: seleccionado ? Colors.black87 : Colors.black54,
                      fontWeight:
                          seleccionado ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (bool selected) {
                      if (selected) {
                        setState(() => _colorSeleccionado = nombre);
                      }
                    },
                  );
                }).toList(),
              ),

              const Spacer(),

              // BOTÓN INICIAR RUTINA
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _iniciarRutina,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text(
                    "INICIAR RUTINA",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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