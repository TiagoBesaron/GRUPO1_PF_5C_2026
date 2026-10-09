import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../provider/bluetooth_provider.dart';

class BluetoothScreen extends ConsumerStatefulWidget {
  const BluetoothScreen({super.key});

  @override
  ConsumerState<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends ConsumerState<BluetoothScreen> {
  bool isScanning = false;
  bool isConnecting = false;
  List<ScanResult> scanResults = [];
  StreamSubscription<List<ScanResult>>? _scanSubscription;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  Future<void> _startScan() async {
    await _scanSubscription?.cancel();

    setState(() {
      scanResults.clear();
      isScanning = true;
    });

    _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      if (mounted) {
        setState(() {
          scanResults = results;
        });
      }
    });

    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    } catch (e) {
      debugPrint('Error en escaneo BLE: $e');
    }

    if (mounted) {
      setState(() {
        isScanning = false;
      });
    }
  }

  Future<void> _stopScan() async {
    await FlutterBluePlus.stopScan();
    await _scanSubscription?.cancel();
    if (mounted) {
      setState(() {
        isScanning = false;
      });
    }
  }

  Future<void> _conectarDispositivo(BluetoothDevice device) async {
    await _stopScan();
    setState(() => isConnecting = true);

    try {
      await ref.read(bluetoothProvider.notifier).conectar(device);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("¡Conectado exitosamente a ${device.platformName.isNotEmpty ? device.platformName : 'ESP32'}!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, device);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al conectar: $e"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isConnecting = false);
      }
    }
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conectar Bluetooth'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (isScanning || isConnecting)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: LinearProgressIndicator(
                    color: Colors.orange,
                    backgroundColor: Color(0xFFFFE0B2),
                  ),
                ),
              Expanded(
                child: scanResults.isEmpty
                    ? Center(
                        child: Text(
                          isScanning
                              ? 'Buscando dispositivos cercanos...'
                              : 'No se encontraron dispositivos.',
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: scanResults.length,
                        itemBuilder: (context, index) {
                          final result = scanResults[index];
                          final deviceName = result.device.platformName.isNotEmpty
                              ? result.device.platformName
                              : 'Dispositivo sin nombre';

                          return Card(
                            elevation: 1,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              leading: const Icon(Icons.bluetooth, color: Colors.blue),
                              title: Text(
                                deviceName,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('ID: ${result.device.remoteId}'),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: isConnecting
                                    ? null
                                    : () => _conectarDispositivo(result.device),
                                child: const Text('Conectar'),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: isScanning ? _stopScan : _startScan,
                  child: Text(
                    isScanning ? 'CANCELAR BÚSQUEDA' : 'BUSCAR NUEVAMENTE',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: Colors.white,
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