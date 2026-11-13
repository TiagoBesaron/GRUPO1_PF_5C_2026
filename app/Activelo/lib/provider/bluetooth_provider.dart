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
  final int desconexionInesperadaTicket;
  final BluetoothCharacteristic? characteristicRx;

  const BluetoothState({
    this.device,
    this.conectado = false,
    this.ultimoTiempo = "0.000 s",
    this.reactionTicket = 0,
    this.desconexionInesperadaTicket = 0,
    this.characteristicRx,
  });

  BluetoothState copyWith({
    BluetoothDevice? device,
    bool? conectado,
    String? ultimoTiempo,
    int? reactionTicket,
    int? desconexionInesperadaTicket,
    BluetoothCharacteristic? characteristicRx,
    bool limpiarDevice = false,
  }) {
    return BluetoothState(
      device: limpiarDevice ? null : device ?? this.device,
      conectado: conectado ?? this.conectado,
      ultimoTiempo: ultimoTiempo ?? this.ultimoTiempo,
      reactionTicket: reactionTicket ?? this.reactionTicket,
      desconexionInesperadaTicket:
          desconexionInesperadaTicket ?? this.desconexionInesperadaTicket,
      characteristicRx: characteristicRx ?? this.characteristicRx,
    );
  }
}

class BluetoothNotifier extends StateNotifier<BluetoothState> {
  BluetoothNotifier() : super(const BluetoothState()) {
    _escucharEstadoAdapter();
  }

  StreamSubscription<BluetoothConnectionState>? _connectionStateSub;
  StreamSubscription<List<int>>? _notifySubscription;
  StreamSubscription<BluetoothAdapterState>? _adapterStateSub;
  Timer? _watchdogTimer;

  void _escucharEstadoAdapter() {
    _adapterStateSub = FlutterBluePlus.adapterState.listen((adapterState) {
      if (adapterState != BluetoothAdapterState.on && state.conectado) {
        debugPrint("Bluetooth desactivado en el dispositivo. Desconectando...");
        desconectar(inesperada: true);
      }
    });
  }

  Future<void> conectar(BluetoothDevice device) async {
    await desconectar();

    try {
      await device.connect(
        timeout: const Duration(seconds: 6),
        autoConnect: false,
      );

      _connectionStateSub = device.connectionState.listen((connState) {
        if (connState == BluetoothConnectionState.disconnected) {
          debugPrint(
              "Dispositivo desconectado detectado por connectionState stream.");
          desconectar(inesperada: true);
        }
      });

      await Future.delayed(const Duration(milliseconds: 300));

      List<BluetoothService> services = await device.discoverServices();
      BluetoothCharacteristic? rxChar;

      for (var service in services) {
        if (service.uuid == serviceUuid) {
          for (var char in service.characteristics) {
            if (char.uuid == characteristicUuidTx) {
              try {
                await char
                    .setNotifyValue(true)
                    .timeout(const Duration(seconds: 4));
              } catch (e) {
                debugPrint("Error setNotifyValue: $e");
              }

              await _notifySubscription?.cancel();
              _notifySubscription = char.onValueReceived.listen(
                (value) async {
                  String mensaje = utf8.decode(value).trim();
                  debugPrint("Notificación BLE recibida: $mensaje");

                  if (mensaje.toUpperCase().contains("REACCION")) {
                    final matches = RegExp(r'\d+').allMatches(mensaje);
                    if (matches.isNotEmpty) {
                      int ms = int.tryParse(matches.last.group(0)!) ?? 0;

                      if (ms > 0) {
                        double segundos = ms / 1000.0;

                        state = state.copyWith(
                          ultimoTiempo: "${segundos.toStringAsFixed(3)} s",
                          reactionTicket: state.reactionTicket + 1,
                        );

                        try {
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
                        } catch (e) {
                          debugPrint("Error al guardar tiempo individual: $e");
                        }
                      }
                    }
                  }
                },
                onError: (e) {
                  debugPrint("Error en canal de notificaciones BLE: $e");
                  desconectar(inesperada: true);
                },
              );
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

      // Vigilancia periódica por si el ESP32 se apaga sin avisar
      _watchdogTimer?.cancel();
      _watchdogTimer = Timer.periodic(const Duration(seconds: 2), (_) {
        if (!device.isConnected) {
          debugPrint("Watchdog: ESP32 apagado o fuera de alcance.");
          desconectar(inesperada: true);
        }
      });
    } catch (error) {
      await desconectar();
      rethrow;
    }
  }

  Future<void> enviarComando(String comando) async {
    if (!state.conectado || state.characteristicRx == null) return;

    if (state.device != null && !state.device!.isConnected) {
      await desconectar(inesperada: true);
      return;
    }

    try {
      await state.characteristicRx!
          .write(utf8.encode(comando))
          .timeout(const Duration(seconds: 3));
    } catch (e) {
      debugPrint("Fallo al escribir comando BLE (Pod posiblemente apagado): $e");
      await desconectar(inesperada: true);
    }
  }

  Future<void> desconectar({bool inesperada = false}) async {
    final estabaConectado = state.conectado;
    final dev = state.device;
    final notifySub = _notifySubscription;
    final connSub = _connectionStateSub;

    _notifySubscription = null;
    _connectionStateSub = null;
    _watchdogTimer?.cancel();
    _watchdogTimer = null;

    // 1. Limpiamos el estado primero para que la UI responda al instante y no se trabe
    _limpiarEstado(inesperada: inesperada && estabaConectado);

    // 2. Cerramos streams y conexión física con timeout para no colgarse si el ESP32 está apagado
    try {
      await notifySub?.cancel().timeout(const Duration(seconds: 1));
    } catch (_) {}

    try {
      await connSub?.cancel().timeout(const Duration(seconds: 1));
    } catch (_) {}

    if (dev != null) {
      try {
        await dev.disconnect().timeout(const Duration(seconds: 2));
      } catch (e) {
        debugPrint("Timeout o error al desconectar (ESP32 apagado): $e");
      }
    }
  }

  void _limpiarEstado({bool inesperada = false}) {
    state = BluetoothState(
      desconexionInesperadaTicket:
          state.desconexionInesperadaTicket + (inesperada ? 1 : 0),
    );
  }

  @override
  void dispose() {
    _watchdogTimer?.cancel();
    _adapterStateSub?.cancel();
    _notifySubscription?.cancel();
    _connectionStateSub?.cancel();
    super.dispose();
  }
}