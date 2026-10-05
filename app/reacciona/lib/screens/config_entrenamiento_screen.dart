import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfigEntrenamientoScreen extends StatefulWidget {
  const ConfigEntrenamientoScreen({super.key});

  @override
  State<ConfigEntrenamientoScreen> createState() => _ConfigEntrenamientoScreenState();
}

class _ConfigEntrenamientoScreenState extends State<ConfigEntrenamientoScreen> {
  int rondas = 5;
  bool rondasAleatorias = false;

  String colorSeleccionado = 'Verde';
  bool colorAleatorio = false;

  final Map<String, List<int>> coloresRGB = {
    'Verde': [0, 255, 0],
    'Rojo': [255, 0, 0],
    'Azul': [0, 0, 255],
    'Amarillo': [255, 255, 0],
    'Violeta': [128, 0, 128],
    'Cian': [0, 255, 255],
  };

  void iniciar() {
    int rondasFinales = rondasAleatorias ? (Random().nextInt(6) + 3) : rondas;

    context.push('/entrenamiento_activo', extra: {
      'rondasTotal': rondasFinales,
      'colorNombre': colorSeleccionado,
      'colorAleatorio': colorAleatorio,
      'rgbBase': coloresRGB[colorSeleccionado] ?? [0, 255, 0],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configurar Entrenamiento")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Cantidad de Rondas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            SwitchListTile(
              title: const Text("Rondas Aleatorias (entre 3 y 8)"),
              value: rondasAleatorias,
              onChanged: (val) => setState(() => rondasAleatorias = val),
            ),

            if (!rondasAleatorias) ...[
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: rondas.toDouble(),
                      min: 1,
                      max: 20,
                      divisions: 19,
                      label: "$rondas rondas",
                      onChanged: (val) => setState(() => rondas = val.toInt()),
                    ),
                  ),
                  Text("$rondas rondas", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ],

            const Divider(height: 40),

            const Text("Color de los LEDs", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            SwitchListTile(
              title: const Text("Color Aleatorio por Ronda"),
              subtitle: const Text("Cambia de color en cada encendido"),
              value: colorAleatorio,
              onChanged: (val) => setState(() => colorAleatorio = val),
            ),

            if (!colorAleatorio) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: coloresRGB.keys.map((nombreColor) {
                  final esSeleccionado = colorSeleccionado == nombreColor;
                  final rgb = coloresRGB[nombreColor]!;
                  final colorDisplay = Color.fromRGBO(rgb[0], rgb[1], rgb[2], 1.0);

                  return ChoiceChip(
                    label: Text(nombreColor),
                    selected: esSeleccionado,
                    avatar: CircleAvatar(backgroundColor: colorDisplay),
                    onSelected: (selected) {
                      if (selected) setState(() => colorSeleccionado = nombreColor);
                    },
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: iniciar,
                icon: const Icon(Icons.play_arrow, size: 28),
                label: const Text("¡INICIAR RUTINA!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}