import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// Provider global encargado de administrar el estado Bluetooth.
// Permite que cualquier pantalla de la aplicación pueda consultar
// si el ESP32 está conectado y acceder a las funciones de conexión.
final bluetoothProvider =
    StateNotifierProvider<BluetoothNotifier, BluetoothState>(
  (ref) => BluetoothNotifier(),
);



// Clase que representa el estado actual de la conexión Bluetooth.
// Guarda:
// - El dispositivo conectado.
// - Si existe una conexión activa con el ESP32.
//
// Al cambiar este estado, Riverpod actualiza automáticamente las pantallas que estén utilizando este provider.
class BluetoothState {

  final BluetoothDevice? device;

  final bool conectado;


  const BluetoothState({

    this.device,

    this.conectado = false,

  });



  // Permite crear una copia del estado modificando solamente
  // los valores necesarios sin perder la información existente.
  BluetoothState copyWith({

    BluetoothDevice? device,

    bool? conectado,

  }) {

    return BluetoothState(

      device: device ?? this.device,

      conectado: conectado ?? this.conectado,

    );

  }
}





// Controlador encargado de modificar el estado Bluetooth.
// Se comunica con flutter_blue_plus para realizar las conexiones
// reales con dispositivos BLE como el ESP32.
class BluetoothNotifier extends StateNotifier<BluetoothState> {


  BluetoothNotifier()
      : super(const BluetoothState());



  // Guarda la suscripción al estado de conexión del dispositivo.
  // Permite detectar cuando el ESP32 se conecta o desconecta.
  StreamSubscription<BluetoothConnectionState>? _subscription;




  // Realiza la conexión con un dispositivo Bluetooth seleccionado.
  // Recibe el BluetoothDevice encontrado durante el escaneo y establece la comunicación con el ESP32.
  Future<void> conectar(BluetoothDevice device) async {


    try {


      // Inicia la conexión Bluetooth.
      await device.connect();



      // Actualiza el estado indicando que existe un dispositivo conectado.
      state = state.copyWith(

        device: device,

        conectado: true,

      );



      // Cancela una escucha anterior para evitar múltiples suscripciones.
      _subscription?.cancel();



      // Escucha cambios en la conexión del dispositivo.
      // Si el ESP32 pierde conexión, la aplicación se actualiza automáticamente.
      _subscription = device.connectionState.listen((estado) {


        state = state.copyWith(

          conectado:
              estado == BluetoothConnectionState.connected,

        );


      });


    } catch (error) {


      // Captura errores de conexión Bluetooth.
      print(error);


    }

  }





  // Finaliza la conexión con el ESP32 y limpia el estado actual.
  Future<void> desconectar() async {


    // Comprueba si existe un dispositivo conectado.
    if (state.device != null) {


      // Cierra la conexión Bluetooth.
      await state.device!.disconnect();

    }



    // Detiene la escucha del estado de conexión.
    await _subscription?.cancel();



    // Restablece el estado inicial: sin dispositivo conectado.
    state = const BluetoothState();

  }

}