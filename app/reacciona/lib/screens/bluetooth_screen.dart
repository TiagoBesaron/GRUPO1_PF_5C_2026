import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {

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
      setState(() {
        dispositivos = results;
      });
    });

    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 5),
    );

    await Future.delayed(const Duration(seconds: 5));

    setState(() {
      buscando = false;
    });
  }

  Future<void> conectar(BluetoothDevice device) async {

    try {

      await device.connect();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${device.platformName} conectado"),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al conectar: $e"),
        ),
      );

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Bluetooth"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            const Icon(
              Icons.bluetooth,
              size: 120,
              color: Colors.blue,
            ),

            const SizedBox(height: 15),

            const Text(
              "LED Trainer",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Buscá y conectate a tu ESP32",
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
                  buscando
                      ? "Buscando..."
                      : "Buscar dispositivos",
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(

              child: dispositivos.isEmpty

                  ? const Center(
                      child: Text(
                        "No hay dispositivos encontrados",
                      ),
                    )

                  : ListView.builder(

                      itemCount: dispositivos.length,

                      itemBuilder: (context, index) {

                        final resultado = dispositivos[index];
                        final device = resultado.device;

                        return Card(

                          child: ListTile(

                            leading: const Icon(
                              Icons.bluetooth,
                              color: Colors.blue,
                            ),

                            title: Text(
                              device.platformName.isEmpty
                                  ? "Dispositivo sin nombre"
                                  : device.platformName,
                            ),

                            subtitle: Text(
                              device.remoteId.str,
                            ),

                            trailing: ElevatedButton(
                              onPressed: () => conectar(device),
                              child: const Text("Conectar"),
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