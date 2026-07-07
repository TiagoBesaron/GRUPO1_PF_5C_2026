import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/bluetooth_provider.dart';



// ConsumerStatefulWidget permite usar Riverpod dentro de una pantalla
// que además necesita manejar estados propios, como el escaneo Bluetooth.
class BluetoothScreen extends ConsumerStatefulWidget {

  const BluetoothScreen({super.key});


  @override
  ConsumerState<BluetoothScreen> createState() =>
      _BluetoothScreenState();

}




class _BluetoothScreenState extends ConsumerState<BluetoothScreen> {


  // Lista donde se almacenan los dispositivos encontrados durante el escaneo Bluetooth.
  List<ScanResult> dispositivos = [];



  // Suscripción encargada de recibir continuamente los resultados del escaneo BLE.
  StreamSubscription<List<ScanResult>>? scanSubscription;



  // Indica si actualmente se está realizando una búsqueda.
  // Se utiliza para bloquear el botón y mostrar el indicador de carga.
  bool buscando = false;




  @override
  void dispose() {


    // Cancela la escucha del escaneo para liberar recursos.
    scanSubscription?.cancel();



    // Detiene cualquier escaneo Bluetooth activo al salir de la pantalla.
    FlutterBluePlus.stopScan();


    super.dispose();

  }





  // Inicia la búsqueda de dispositivos Bluetooth cercanos.
  //
  // Obtiene los dispositivos BLE encontrados mediante flutter_blue_plus
  // y actualiza la lista mostrada en pantalla.
  Future<void> buscarDispositivos() async {


    dispositivos.clear();



    setState(() {

      buscando = true;

    });



    // Evita tener múltiples escuchas del escaneo al mismo tiempo.
    scanSubscription?.cancel();



    // Recibe los dispositivos detectados durante el escaneo.
    scanSubscription =
        FlutterBluePlus.scanResults.listen((results) {


      setState(() {


        dispositivos = results;


      });


    });




    // Realiza un escaneo durante 5 segundos.
    await FlutterBluePlus.startScan(

      timeout: const Duration(seconds: 5),

    );



    await Future.delayed(

      const Duration(seconds: 5),

    );



    setState(() {

      buscando = false;

    });


  }





  @override
  Widget build(BuildContext context) {


    // Obtiene el estado actual del Bluetooth desde Riverpod.
    // Permite actualizar la interfaz cuando cambia la conexión.
    final bluetooth = ref.watch(bluetoothProvider);



    return Scaffold(


      appBar: AppBar(

        title: const Text("Bluetooth"),

        centerTitle: true,

      ),




      body: Padding(

        padding: const EdgeInsets.all(20),


        child: Column(


          children: [



            // Indicador visual del estado de conexión.
            // Cambia según si existe conexión con el ESP32.
            Icon(

              bluetooth.conectado

                  ? Icons.bluetooth_connected

                  : Icons.bluetooth,


              color:

              bluetooth.conectado

                  ? Colors.green

                  : Colors.red,


              size:120,

            ),





            const SizedBox(height:20),




            const Text(

              "LED Trainer",

              style:TextStyle(

                fontSize:30,

                fontWeight:FontWeight.bold,

              ),

            ),





            const SizedBox(height:10),





            Text(

              bluetooth.conectado

                  ? "Dispositivo conectado"

                  : "No hay ningún dispositivo conectado",


              textAlign:TextAlign.center,

            ),





            const SizedBox(height:30),





            // Botón encargado de iniciar el escaneo Bluetooth.
            SizedBox(

              width:double.infinity,

              height:55,


              child:ElevatedButton.icon(


                onPressed:

                buscando

                ? null

                : buscarDispositivos,



                icon: buscando


                    ? const SizedBox(

                        height:20,

                        width:20,

                        child:CircularProgressIndicator(

                          strokeWidth:2,

                          color:Colors.white,

                        ),

                      )


                    : const Icon(Icons.search),



                label:Text(

                  buscando

                  ? "Buscando..."

                  : "Buscar dispositivos",

                ),


              ),

            ),





            const SizedBox(height:10),





            // Botón que utiliza el provider para cerrar
            // la conexión con el ESP32.
            SizedBox(

              width:double.infinity,

              height:55,


              child:ElevatedButton.icon(


                onPressed:

                bluetooth.conectado

                ? () async {


                    await ref

                    .read(bluetoothProvider.notifier)

                    .desconectar();


                  }


                : null,



                icon:const Icon(Icons.link_off),



                label:const Text(
                  "Desconectar",
                ),


              ),

            ),





            const SizedBox(height:20),





            // Lista de dispositivos encontrados.
            // Cada elemento permite seleccionar un ESP32
            // e iniciar la conexión mediante Riverpod.
            Expanded(


              child:dispositivos.isEmpty


              ? const Center(

                  child:Text(

                    "No se encontraron dispositivos",

                  ),

                )



              : ListView.builder(



                  itemCount:dispositivos.length,



                  itemBuilder:(context,index){



                    final resultado =
                        dispositivos[index];



                    final device =
                        resultado.device;




                    return Card(



                      child:ListTile(



                        leading:const Icon(

                          Icons.memory,

                          color:Colors.blue,

                        ),




                        title:Text(

                          device.platformName.isEmpty

                          ? "Sin nombre"

                          : device.platformName,

                        ),




                        subtitle:Text(

                          device.remoteId.str,

                        ),





                        // Al presionar conectar se envía
                        // el dispositivo seleccionado al provider,
                        // que realiza la conexión real.
                        trailing:ElevatedButton(


                          child:const Text(
                            "Conectar",
                          ),



                          onPressed:() async {



                            await ref

                            .read(

                              bluetoothProvider

                              .notifier,

                            )

                            .conectar(device);



                          },

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