import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

// UUIDs en minúsculas para compatibilidad estándar de Flutter Blue Plus
final Guid serviceUuid = Guid("4fa8691a-0393-40a3-974f-0759e09f114d");
final Guid characteristicUuidRx = Guid("87b54dba-055b-4321-8525-2b2a239385c7"); // Escritura a ESP32
final Guid characteristicUuidTx = Guid("d7b54dba-055b-4321-8525-2b2a239385c8"); // Notificación desde ESP32

final bluetoothProvider =
    StateNotifierProvider<BluetoothNotifier, BluetoothState>(
  (ref) => BluetoothNotifier(),
);

class BluetoothState {
  final BluetoothDevice? device;
  final bool conectado;
  final String ultimoTiempo;
  final BluetoothCharacteristic? characteristicRx;

  const BluetoothState({
    this.device,
    this.conectado = false,
    this.ultimoTiempo = "0.000 s",
    this.characteristicRx,
  });

  BluetoothState copyWith({
    BluetoothDevice? device,
    bool? conectado,
    String? ultimoTiempo,
    BluetoothCharacteristic? characteristicRx,
    bool limpiarDevice = false,
  }) {
    return BluetoothState(
      device: limpiarDevice ? null : device ?? this.device,
      conectado: conectado ?? this.conectado,
      ultimoTiempo: ultimoTiempo ?? this.ultimoTiempo,
      characteristicRx: characteristicRx ?? this.characteristicRx,
    );
  }
}

class BluetoothNotifier extends StateNotifier<BluetoothState> {
  BluetoothNotifier() : super(const BluetoothState());

  StreamSubscription<BluetoothConnectionState>? _subscription;
  StreamSubscription<List<int>>? _notifySubscription;

  Future<void> conectar(BluetoothDevice device) async {
    try {
      if (state.device != null && state.device!.remoteId != device.remoteId) {
        await desconectar();
      }

      await device.connect();

      List<BluetoothService> services = await device.discoverServices();
      BluetoothCharacteristic? rxChar;

      for (var service in services) {
        if (service.uuid == serviceUuid) {
          for (var char in service.characteristics) {
            // Suscribirse a Notificaciones (Lecturas del ESP32)
            if (char.uuid == characteristicUuidTx) {
              await char.setNotifyValue(true);

              _notifySubscription = char.onValueReceived.listen((value) async {
                String mensaje = utf8.decode(value);
                if (mensaje.startsWith("REACCION:")) {
                  String msStr = mensaje.replaceAll("REACCION:", "");
                  int ms = int.tryParse(msStr) ?? 0;
                  double segundos = ms / 1000.0;

                  state = state.copyWith(
                    ultimoTiempo: "${segundos.toStringAsFixed(3)} s",
                  );

                  // Guardar en Firebase directamente bajo el usuario autenticado
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    final ref = FirebaseDatabase.instance
                        .ref("usuarios/${user.uid}/tiempos");
                    await ref.push().set({
                      "tiempoMs": ms,
                      "tiempoSeg": segundos,
                      "timestamp": ServerValue.timestamp,
                    });
                  }
                }
              });
            }
            // Guardar característica para enviar órdenes al ESP32
            if (char.uuid == characteristicUuidRx) {
              rxChar = char;
            }
          }
        }
      }

      state = state.copyWith(
        device: device,
        conectado: true,
        characteristicRx: rxChar,
      );

      _subscription = device.connectionState.listen((estado) {
        if (estado != BluetoothConnectionState.connected) {
          desconectar();
        }
      });
    } catch (error) {
      state = const BluetoothState();
      rethrow;
    }
  }

  Future<void> enviarComando(String comando) async {
    if (state.conectado && state.characteristicRx != null) {
      await state.characteristicRx!.write(utf8.encode(comando));
    }
  }

  Future<void> desconectar() async {
    try {
      await _notifySubscription?.cancel();
      await _subscription?.cancel();
      if (state.device != null) {
        await state.device!.disconnect();
      }
    } catch (_) {
      // Ignora errores si ya estaba desconectado
    } finally {
      state = const BluetoothState();
    }
  }

  @override
  void dispose() {
    _notifySubscription?.cancel();
    _subscription?.cancel();
  }
}