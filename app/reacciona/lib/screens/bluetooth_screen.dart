import 'package:flutter/material.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  bool _buscando = false;
  bool _conectado = false;
  String? _dispositivoConectado;

  // Lista de dispositivos BLE detectados
  final List<Map<String, String>> _dispositivosEncontrados = [];

  void _iniciarBusqueda() async {
    setState(() {
      _buscando = true;
      _dispositivosEncontrados.clear();
    });

    // Simulamos un escaneo de 3 segundos sin inventar dispositivos falsos
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    setState(() {
      _buscando = false;
      // Aquí se completará con la lista real cuando integres 'flutter_blue_plus'
    });
  }

  void _cancelarBusqueda() {
    setState(() {
      _buscando = false;
    });
  }

  void _conectarDispositivo(String nombre) {
    setState(() {
      _conectado = true;
      _dispositivoConectado = nombre;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Conectado a $nombre"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _desconectarDispositivo() {
    setState(() {
      _conectado = false;
      _dispositivoConectado = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Dispositivo desconectado"),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth BLE'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // TARJETA DE ESTADO DE CONEXIÓN
              Card(
                color: _conectado ? Colors.green.shade50 : Colors.red.shade50,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        _conectado
                            ? Icons.bluetooth_connected
                            : Icons.bluetooth_disabled,
                        size: 40,
                        color: _conectado ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _conectado ? "Conectado" : "Desconectado",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _conectado
                                    ? Colors.green.shade900
                                    : Colors.red.shade900,
                              ),
                            ),
                            Text(
                              _conectado
                                  ? (_dispositivoConectado ?? "ESP32 Vinculado")
                                  : "Sin dispositivo vinculado",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      if (_conectado)
                        IconButton(
                          icon: const Icon(Icons.link_off, color: Colors.red),
                          onPressed: _desconectarDispositivo,
                          tooltip: "Desconectar",
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // BOTÓN BUSCAR / CANCELAR
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _buscando ? _cancelarBusqueda : _iniciarBusqueda,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _buscando ? Colors.orange : Colors.blue,
                  ),
                  icon: _buscando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.search),
                  label: Text(
                    _buscando ? "CANCELAR BÚSQUEDA" : "BUSCAR DISPOSITIVOS BLE",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // LISTADO DE DISPOSITIVOS ENCONTRADOS
              const Text(
                "Dispositivos Disponibles",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: _dispositivosEncontrados.isEmpty
                    ? Center(
                        child: Text(
                          _buscando
                              ? "Buscando dispositivos BLE cercanos..."
                              : "No se encontraron dispositivos. Encendé tu ESP32 y tocá en buscar.",
                          style: const TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: _dispositivosEncontrados.length,
                        itemBuilder: (context, index) {
                          final dev = _dispositivosEncontrados[index];
                          final esElConectado =
                              _conectado && _dispositivoConectado == dev["nombre"];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: const Icon(
                                Icons.developer_board,
                                color: Colors.blue,
                              ),
                              title: Text(
                                dev["nombre"] ?? "Dispositivo BLE",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "MAC: ${dev["id"]} | Señal: ${dev["rssi"]}",
                              ),
                              trailing: ElevatedButton(
                                onPressed: esElConectado
                                    ? null
                                    : () => _conectarDispositivo(dev["nombre"]!),
                                child: Text(
                                  esElConectado ? "Conectado" : "Conectar",
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}