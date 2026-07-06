import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // DATOS DE PRUEBA
    const String nombre = "Tiago";
    const String mejorTiempo = "0.398 s";
    const String ultimoTiempo = "0.421 s";
    const String promedio = "0.414 s";
    const bool conectado = true;

    return Scaffold(
      appBar: AppBar(
        title: const Text("LED Trainer"),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Entrenamiento iniciado"),
            ),
          );
        },
        icon: const Icon(Icons.play_arrow),
        label: const Text("Entrenar"),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              break;

            case 1:
              context.go('/tiempos');
              break;

            case 2:
              context.go('/settings');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Inicio",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: "Tiempos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Ajustes",
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "¡Hola, $nombre! 👋",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: ListTile(
                leading: Icon(
                  conectado
                      ? Icons.bluetooth_connected
                      : Icons.bluetooth_disabled,
                  color: conectado ? Colors.green : Colors.red,
                  size: 35,
                ),
                title: const Text(
                  "Estado del dispositivo",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  conectado
                      ? "ESP32 conectado"
                      : "ESP32 desconectado",
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [

                Expanded(
                  child: _statCard(
                    "Mejor",
                    mejorTiempo,
                    Icons.emoji_events,
                    Colors.amber,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _statCard(
                    "Último",
                    ultimoTiempo,
                    Icons.timer,
                    Colors.blue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            _wideCard(
              "Promedio",
              promedio,
              Icons.bar_chart,
              Colors.green,
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Entrenamiento iniciado"),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text(
                  "COMENZAR ENTRENAMIENTO",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Accesos rápidos",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Card(
              child: ListTile(
                leading: const Icon(Icons.history),
                title: const Text("Ver historial de tiempos"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  context.push('/tiempos');
                },
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Mi perfil"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  context.push('/editProfile');
                },
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Configuración"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  context.push('/settings');
                },
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Última sesión",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Card(
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Intentos"),
                        Text(
                          "15",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Récord"),
                        Text(
                          "0.398 s",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Fecha"),
                        Text(
                          "03/07/2026",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }

  Widget _statCard(
      String titulo,
      String valor,
      IconData icono,
      Color color,
      ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Icon(
              icono,
              color: color,
              size: 40,
            ),
            const SizedBox(height: 10),
            Text(
              titulo,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              valor,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _wideCard(
      String titulo,
      String valor,
      IconData icono,
      Color color,
      ) {
    return Card(
      child: ListTile(
        leading: Icon(
          icono,
          color: color,
          size: 35,
        ),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          valor,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}