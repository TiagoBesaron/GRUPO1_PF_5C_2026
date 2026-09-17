import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// Provider global encargado de administrar el estado Bluetooth.
final bluetoothProvider =
    StateNotifierProvider<BluetoothNotifier, BluetoothState>(
  (ref) => BluetoothNotifier(),
);


// Estado actual de Bluetooth.
class BluetoothState {

  final BluetoothDevice? device;

  final bool conectado;


  const BluetoothState({
    this.device,
    this.conectado = false,
  });


  BluetoothState copyWith({
    BluetoothDevice? device,
    bool? conectado,
    bool limpiarDevice = false,
  }) {

    return BluetoothState(

      device: limpiarDevice
          ? null
          : device ?? this.device,

      conectado:
          conectado ?? this.conectado,
    );
  }
}


// Controlador encargado de administrar la conexión Bluetooth.
class BluetoothNotifier
    extends StateNotifier<BluetoothState> {

  BluetoothNotifier()
      : super(const BluetoothState());


  // Escucha el estado de conexión.
  StreamSubscription<BluetoothConnectionState>?
      _subscription;


  // Conecta un dispositivo BLE.
  Future<void> conectar(
      BluetoothDevice device) async {

    try {

      // Si ya existe otro dispositivo conectado,
      // se desconecta antes de conectar el nuevo.
      if (state.device != null &&
          state.device!.remoteId != device.remoteId) {

        await desconectar();
      }


      // Evita conectar nuevamente si ya está conectado.
      if (state.device?.remoteId == device.remoteId &&
          state.conectado) {

        return;
      }


      // Cancela una suscripción anterior.
      await _subscription?.cancel();
      _subscription = null;


      // Realiza la conexión.
      await device.connect();


      // Guarda el dispositivo conectado.
      state = state.copyWith(
        device: device,
        conectado: true,
      );


      // Escucha cambios en la conexión.
      _subscription =
          device.connectionState.listen((estado) {

        if (estado ==
            BluetoothConnectionState.connected) {

          state = state.copyWith(
            device: device,
            conectado: true,
          );

        } else {

          // Si se desconecta, elimina también
          // el dispositivo guardado.
          state = state.copyWith(
            conectado: false,
            limpiarDevice: true,
          );
        }
      });


    } catch (error) {

      // Si la conexión falla, dejamos el estado limpio.
      state = const BluetoothState();

      print(
        "Error al conectar Bluetooth: $error",
      );

      // Reenviamos el error para que la pantalla
      // pueda mostrar un mensaje al usuario.
      rethrow;
    }
  }


  // Desconecta el dispositivo actual.
  Future<void> desconectar() async {

    try {

      // Cancela primero la escucha.
      await _subscription?.cancel();
      _subscription = null;


      // Desconecta el dispositivo.
      if (state.device != null) {

        await state.device!.disconnect();
      }


    } catch (error) {

      print(
        "Error al desconectar Bluetooth: $error",
      );


    } finally {

      // Siempre dejamos el estado limpio.
      state = const BluetoothState();
    }
  }


  // Libera los recursos cuando el provider deja de utilizarse.
  @override
  void dispose() {

    _subscription?.cancel();

    super.dispose();
  }
}
