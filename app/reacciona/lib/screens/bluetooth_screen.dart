import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../provider/bluetooth_provider.dart';

class BluetoothScreen extends ConsumerStatefulWidget {
  const BluetoothScreen({super.key});

  @override
  ConsumerState<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends ConsumerState<BluetoothScreen> {
  List<ScanResult> dispositivos = [];
  StreamSubscription<List<ScanResult>>? scanSubscription;
  bool buscando = false;

  @override
  void dispose() {
    scanSubscription?.cancel();
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  Future<void> buscarDispositivos() async {
    dispositivos.clear();

    setState(() {
      buscando = true;
    });

    scanSubscription?.cancel();

    scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      if (mounted) {
        setState(() {
          dispositivos = results;
        });
      }
    });

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    if (mounted) {
      setState(() {
        buscando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bluetooth = ref.watch(bluetoothProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bluetooth"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              bluetooth.conectado
                  ? Icons.bluetooth_connected
                  : Icons.bluetooth,
              color: bluetooth.conectado ? Colors.green : Colors.red,
              size: 120,
            ),
            const SizedBox(height: 20),
            const Text(
              "LED Trainer",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              bluetooth.conectado
                  ? "Dispositivo conectado"
                  : "No hay ningún dispositivo conectado",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: buscando ? null : buscarDispositivos,
                icon: buscando
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.search),
                label: Text(
                  buscando ? "Buscando..." : "Buscar dispositivos",
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: bluetooth.conectado
                    ? () async {
                        await ref
                            .read(bluetoothProvider.notifier)
                            .desconectar();
                      }
                    : null,
                icon: const Icon(Icons.link_off),
                label: const Text("Desconectar"),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: dispositivos.isEmpty
                  ? const Center(
                      child: Text("No se encontraron dispositivos"),
                    )
                  : ListView.builder(
                      itemCount: dispositivos.length,
                      itemBuilder: (context, index) {
                        final resultado = dispositivos[index];
                        final device = resultado.device;

                        return Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.memory,
                              color: Colors.blue,
                            ),
                            title: Text(
                              device.platformName.isEmpty
                                  ? "Sin nombre"
                                  : device.platformName,
                            ),
                            subtitle: Text(device.remoteId.str),
                            trailing: ElevatedButton(
                              child: const Text("Conectar"),
                              onPressed: () async {
                                await ref
                                    .read(bluetoothProvider.notifier)
                                    .conectar(device);
                                if (context.mounted) {
                                  context.pop();
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}