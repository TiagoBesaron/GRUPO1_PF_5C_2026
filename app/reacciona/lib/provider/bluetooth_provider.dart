import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

final Guid serviceUuid = Guid("4fa8691a-0393-40a3-974f-0759e09f114d");
final Guid characteristicUuidRx = Guid("87b54dba-055b-4321-8525-2b2a239385c7");
final Guid characteristicUuidTx = Guid("d7b54dba-055b-4321-8525-2b2a239385c8");

final bluetoothProvider =
    StateNotifierProvider<BluetoothNotifier, BluetoothState>(
  (ref) => BluetoothNotifier(),
);

class BluetoothState {
  final BluetoothDevice? device;
  final bool conectado;
  final String ultimoTiempo;
  final int reactionTicket;
  final BluetoothCharacteristic? characteristicRx;

  const BluetoothState({
    this.device,
    this.conectado = false,
    this.ultimoTiempo = "0.000 s",
    this.reactionTicket = 0,
    this.characteristicRx,
  });

  BluetoothState copyWith({
    BluetoothDevice? device,
    bool? conectado,
    String? ultimoTiempo,
    int? reactionTicket,
    BluetoothCharacteristic? characteristicRx,
    bool limpiarDevice = false,
  }) {
    return BluetoothState(
      device: limpiarDevice ? null : device ?? this.device,
      conectado: conectado ?? this.conectado,
      ultimoTiempo: ultimoTiempo ?? this.ultimoTiempo,
      reactionTicket: reactionTicket ?? this.reactionTicket,
      characteristicRx: characteristicRx ?? this.characteristicRx,
    );
  }
}

class BluetoothNotifier extends StateNotifier<BluetoothState> {
  BluetoothNotifier() : super(const BluetoothState());

  StreamSubscription<BluetoothConnectionState>? _connectionStateSub;
  StreamSubscription<List<int>>? _notifySubscription;

  Future<void> conectar(BluetoothDevice device) async {
    await desconectar();

    try {
      // Intentar conexión
      await device.connect(timeout: const Duration(seconds: 6));

      // Escuchar estado de conexión física
      _connectionStateSub = device.connectionState.listen((connState) {
        if (connState == BluetoothConnectionState.disconnected) {
          _limpiarEstado();
        }
      });

      await Future.delayed(const Duration(milliseconds: 300));

      // Descubrir servicios y características
      List<BluetoothService> services = await device.discoverServices();
      BluetoothCharacteristic? rxChar;

      for (var service in services) {
        if (service.uuid == serviceUuid) {
          for (var char in service.characteristics) {
            if (char.uuid == characteristicUuidTx) {
              try {
                await char.setNotifyValue(true).timeout(const Duration(seconds: 4));
              } catch (e) {
                debugPrint("Error setNotifyValue: $e");
              }

              await _notifySubscription?.cancel();
              _notifySubscription = char.onValueReceived.listen((value) async {
                String mensaje = utf8.decode(value).trim();
                debugPrint("Notificación BLE recibida: $mensaje");

                // Permite procesar formatos como "REACCION:350", "REACCION:1:350", "REACCION_1:350", etc.
                if (mensaje.toUpperCase().contains("REACCION")) {
                  final matches = RegExp(r'\d+').allMatches(mensaje);
                  if (matches.isNotEmpty) {
                    // El último número de la cadena corresponde a los milisegundos de reacción
                    int ms = int.tryParse(matches.last.group(0)!) ?? 0;

                    if (ms > 0) {
                      double segundos = ms / 1000.0;

                      state = state.copyWith(
                        ultimoTiempo: "${segundos.toStringAsFixed(3)} s",
                        reactionTicket: state.reactionTicket + 1,
                      );

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
                  }
                }
              });
            }
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
    } catch (error) {
      await desconectar();
      rethrow;
    }
  }

  Future<void> enviarComando(String comando) async {
    try {
      if (state.conectado && state.characteristicRx != null) {
        await state.characteristicRx!.write(utf8.encode(comando));
      }
    } catch (e) {
      debugPrint("Error al enviar comando BLE: $e");
    }
  }

  Future<void> desconectar() async {
    try {
      await _notifySubscription?.cancel();
      _notifySubscription = null;

      await _connectionStateSub?.cancel();
      _connectionStateSub = null;

      if (state.device != null) {
        await state.device!.disconnect();
      }
    } catch (e) {
      debugPrint("Error al desconectar: $e");
    } finally {
      _limpiarEstado();
    }
  }

  void _limpiarEstado() {
    state = const BluetoothState();
  }

  @override
  void dispose() {
    _notifySubscription?.cancel();
    _connectionStateSub?.cancel();
    super.dispose();
  }
}