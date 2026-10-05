import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../provider/bluetooth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bluetoothState = ref.watch(bluetoothProvider);
    final conectado = bluetoothState.conectado;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("LED Trainer"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "¡Hola, ${user?.email?.split('@')[0] ?? 'Atleta'}! 👋",
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: Icon(
                  conectado ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                  color: conectado ? Colors.green : Colors.red,
                  size: 35,
                ),
                title: const Text("Estado del ESP32", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(conectado ? "Conectado por BLE" : "Desconectado"),
                trailing: IconButton(
                  icon: Icon(conectado ? Icons.link_off : Icons.bluetooth),
                  onPressed: () {
                    if (conectado) {
                      ref.read(bluetoothProvider.notifier).desconectar();
                    } else {
                      context.push('/bluetooth');
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.timer, color: Colors.blue, size: 45),
                    const SizedBox(height: 10),
                    const Text("Última Reacción", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(
                      bluetoothState.ultimoTiempo,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: conectado
                    ? () => context.push('/config_entrenamiento')
                    : null,
                icon: const Icon(Icons.settings),
                label: Text(
                  conectado ? "CONFIGURAR ENTRENAMIENTO" : "CONECTAR ESP32 PARA ENTRENAR",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Card(
              child: ListTile(
                leading: const Icon(Icons.history),
                title: const Text("Historial de tiempos"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => context.push('/tiempos'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}