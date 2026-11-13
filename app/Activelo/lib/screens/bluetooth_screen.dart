import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../l10n/app_localizations.dart';
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
      if (!kIsWeb && FlutterBluePlus.isScanningNow) {
        try {
          await FlutterBluePlus.stopScan();
        } catch (_) {}
      }

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
      debugPrint('Escaneo finalizado o cancelado por el usuario: $e');
    } finally {
      if (mounted) {
        setState(() {
          isScanning = false;
        });
      }
    }
  }

  Future<void> _stopScan() async {
    if (mounted) {
      setState(() {
        isScanning = false;
      });
    }

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

  void _mostrarAvisoFlotante({
    required String mensaje,
    required IconData icono,
    required Color colorFondo,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 76),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: colorFondo,
          elevation: 6,
          duration: const Duration(seconds: 4),
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icono,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  mensaje,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  Future<void> _conectarDispositivo(
      BluetoothDevice device, AppLocalizations loc) async {
    await _stopScan();
    if (mounted) {
      setState(() => isConnecting = true);
    }

    final nombre =
        device.platformName.isNotEmpty ? device.platformName : 'Pod Activelo';

    try {
      await ref.read(bluetoothProvider.notifier).conectar(device);
      _mostrarAvisoFlotante(
        mensaje: loc.conectadoExitosamente(nombre),
        icono: Icons.bluetooth_connected_rounded,
        colorFondo: Colors.green.shade700,
      );
    } catch (e) {
      debugPrint("Detalle técnico del fallo BLE: $e");
      _mostrarAvisoFlotante(
        mensaje: "No ha sido posible conectarse a $nombre",
        icono: Icons.bluetooth_disabled_rounded,
        colorFondo: Colors.red.shade700,
      );
    } finally {
      if (mounted) {
        setState(() => isConnecting = false);
      }
    }
  }

  Future<void> _desconectarDispositivo(AppLocalizations loc) async {
    await ref.read(bluetoothProvider.notifier).desconectar();
    _mostrarAvisoFlotante(
      mensaje: loc.dispositivoDesconectado,
      icono: Icons.bluetooth_disabled_rounded,
      colorFondo: Colors.orange.shade800,
    );
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
    final loc = AppLocalizations.of(context);
    final btState = ref.watch(bluetoothProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.conectarBluetooth),
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
                  color: isDark
                      ? const Color(0xFF1B3A2B)
                      : const Color(0xFFE8F5E9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.green, width: 1.5),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.bluetooth_connected,
                        color: Colors.green, size: 30),
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
                      onPressed: () => _desconectarDispositivo(loc),
                      child: Text(loc.desconectar),
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

              Text(
                loc.dispositivosDisponibles,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),

              Expanded(
                child: scanResults.isEmpty
                    ? Center(
                        child: Text(
                          isScanning
                              ? loc.buscandoPods
                              : loc.presionaBotonBuscar,
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
                              leading: const Icon(Icons.bluetooth,
                                  color: Colors.blue),
                              title: Text(
                                deviceName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('ID: ${device.remoteId}'),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isThisConnected
                                      ? Colors.green
                                      : Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: isConnecting || isThisConnected
                                    ? null
                                    : () => _conectarDispositivo(device, loc),
                                child: Text(isThisConnected
                                    ? loc.conectado
                                    : loc.conectar),
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
                    isScanning ? loc.cancelarBusqueda : loc.buscarDispositivos,
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