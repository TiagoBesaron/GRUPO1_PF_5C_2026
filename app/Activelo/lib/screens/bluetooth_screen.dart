import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
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
  StreamSubscription<bool>? _isScanningSubscription;

  @override
  void initState() {
    super.initState();

    // Escuchamos los resultados del escáner en ambas plataformas
    _scanSubscription = FlutterBluePlus.scanResults.listen(
      (results) {
        if (mounted) {
          setState(() {
            scanResults = results;
          });
        }
      },
      onError: (e) => debugPrint("Error en stream scanResults: $e"),
    );

    // En celulares (Android/iOS) escuchamos el estado nativo
    if (!kIsWeb) {
      _isScanningSubscription = FlutterBluePlus.isScanning.listen((scanning) {
        if (mounted) {
          setState(() {
            isScanning = scanning;
          });
        }
      });

      _startScan();
    }
  }

  Future<void> _startScan() async {
    if (isScanning || isConnecting) return;

    setState(() {
      scanResults.clear();
      isScanning = true;
    });

    try {
      // Solo en móviles detenemos escaneos previos
      if (!kIsWeb && FlutterBluePlus.isScanningNow) {
        try {
          await FlutterBluePlus.stopScan();
        } catch (_) {}
      }

      // Iniciar búsqueda
      await FlutterBluePlus.startScan(
        withServices: [Guid("4fa8691a-0393-40a3-974f-0759e09f114d")],
        timeout: const Duration(seconds: 8),
      );

      if (mounted) {
        setState(() {
          scanResults = FlutterBluePlus.lastScanResults;
        });
      }
    } catch (e) {
      // Capturamos la cancelación de Chrome sin romper la ejecución
      debugPrint('Escaneo finalizado o cancelado por el usuario: $e');
    } finally {
      // Apaga el indicador de carga SIEMPRE en la interfaz
      if (mounted) {
        setState(() {
          isScanning = false;
        });
      }
    }
  }

  Future<void> _stopScan() async {
    // 1. Reseteamos el estado visual de la app inmediatamente
    if (mounted) {
      setState(() {
        isScanning = false;
      });
    }

    // 2. En Web NO llamamos a stopScan() para evitar el error "already stopped"
    if (!kIsWeb) {
      try {
        if (FlutterBluePlus.isScanningNow) {
          await FlutterBluePlus.stopScan();
        }
      } catch (e) {
        debugPrint('Error en stopScan nativo: $e');
      }
    }
  }

  Future<void> _conectarDispositivo(BluetoothDevice device) async {
    await _stopScan();
    if (mounted) {
      setState(() => isConnecting = true);
    }

    try {
      await ref.read(bluetoothProvider.notifier).conectar(device);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "¡Conectado exitosamente a ${device.platformName.isNotEmpty ? device.platformName : 'ESP32'}!"),
            backgroundColor: Colors.green,
          ),
        );
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

  Future<void> _desconectarDispositivo() async {
    await ref.read(bluetoothProvider.notifier).desconectar();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Dispositivo desconectado"),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  void dispose() {
    _isScanningSubscription?.cancel();
    _scanSubscription?.cancel();
    if (!kIsWeb) {
      try {
        if (FlutterBluePlus.isScanningNow) {
          FlutterBluePlus.stopScan();
        }
      } catch (_) {}
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final btState = ref.watch(bluetoothProvider);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (btState.conectado && btState.device != null) ...[
                Card(
                  color: isDark ? const Color(0xFF1B3A2B) : const Color(0xFFE8F5E9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.green, width: 1.5),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.bluetooth_connected, color: Colors.green, size: 30),
                    title: Text(
                      btState.device!.platformName.isNotEmpty
                          ? btState.device!.platformName
                          : 'ESP32 Activelo',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('ID: ${btState.device!.remoteId}'),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _desconectarDispositivo,
                      child: const Text('Desconectar'),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
              ],

              if (isScanning || isConnecting)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: LinearProgressIndicator(
                    color: Colors.orange,
                    backgroundColor: Color(0xFFFFE0B2),
                  ),
                ),

              const Text(
                "Dispositivos disponibles:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),

              Expanded(
                child: scanResults.isEmpty
                    ? Center(
                        child: Text(
                          isScanning
                              ? 'Buscando pods cercanos...'
                              : 'Presioná el botón de abajo para buscar pods.',
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: scanResults.length,
                        itemBuilder: (context, index) {
                          final result = scanResults[index];
                          final device = result.device;
                          final deviceName = device.platformName.isNotEmpty
                              ? device.platformName
                              : 'Pod Activelo';

                          final isThisConnected = btState.conectado &&
                              btState.device?.remoteId == device.remoteId;

                          return Card(
                            elevation: 1,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              leading: const Icon(Icons.bluetooth, color: Colors.blue),
                              title: Text(
                                deviceName,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('ID: ${device.remoteId}'),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isThisConnected ? Colors.green : Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: isConnecting || isThisConnected
                                    ? null
                                    : () => _conectarDispositivo(device),
                                child: Text(isThisConnected ? 'Conectado' : 'Conectar'),
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
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  icon: Icon(isScanning ? Icons.close : Icons.search),
                  onPressed: isScanning ? _stopScan : _startScan,
                  label: Text(
                    isScanning ? 'CANCELAR BÚSQUEDA' : 'BUSCAR DISPOSITIVOS',
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