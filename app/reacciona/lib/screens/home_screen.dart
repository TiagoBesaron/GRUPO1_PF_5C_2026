import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../provider/bluetooth_provider.dart';


// ConsumerWidget permite que la pantalla escuche cambios
// provenientes de Riverpod.
// En este caso se utiliza para actualizar automáticamente
// el estado de conexión con el ESP32.
class HomeScreen extends ConsumerWidget {

  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {


    // Obtiene el estado actual del Bluetooth.
    // Cuando el ESP32 cambia su estado de conexión,
    // esta pantalla se actualiza automáticamente.
    final bluetoothState = ref.watch(bluetoothProvider);


    final conectado = bluetoothState.conectado;



    // Datos temporales utilizados para diseñar la interfaz.
    // Posteriormente serán reemplazados por datos reales
    // obtenidos desde el ESP32 y almacenados en la aplicación.
    const String nombre = "Tiago";

    const String mejorTiempo = "0.398 s";

    const String ultimoTiempo = "0.421 s";

    const String promedio = "0.414 s";



    return Scaffold(


      // Barra superior de la pantalla principal.
      appBar: AppBar(

        title: const Text(
          "LED Trainer",
        ),

        centerTitle: true,

      ),




      // Botón flotante utilizado como acceso rápido
      // para iniciar una sesión de entrenamiento.
      floatingActionButton:
          FloatingActionButton.extended(


        onPressed: () {


          ScaffoldMessenger.of(context)
              .showSnackBar(


            const SnackBar(

              content: Text(
                "Entrenamiento iniciado",
              ),

            ),


          );


        },


        icon: const Icon(
          Icons.play_arrow,
        ),


        label: const Text(
          "Entrenar",
        ),


      ),




      body: SingleChildScrollView(

        padding: const EdgeInsets.all(18),


        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,


          children: [

            Text(

              "¡Hola, $nombre! 👋",

              style: const TextStyle(

                fontSize: 28,

                fontWeight: FontWeight.bold,

              ),

            ),




            const SizedBox(height:20),




            // Tarjeta que muestra el estado de conexión
            // entre la aplicación y el ESP32 mediante Bluetooth.
            Card(

              child: ListTile(


                leading: Icon(

                  conectado

                  ? Icons.bluetooth_connected

                  : Icons.bluetooth_disabled,


                  color:

                  conectado

                  ? Colors.green

                  : Colors.red,


                  size:35,

                ),



                title: const Text(

                  "Estado del dispositivo",

                  style: TextStyle(

                    fontWeight: FontWeight.bold,

                  ),

                ),




                subtitle: Text(

                  conectado

                  ? "ESP32 conectado"

                  : "ESP32 desconectado",

                ),





                // Si está conectado permite desconectar.
                // Si no está conectado dirige a la pantalla
                // de búsqueda Bluetooth.
                trailing: IconButton(


                  icon: Icon(

                    conectado

                    ? Icons.link_off

                    : Icons.bluetooth,

                  ),




                  onPressed: () {


                    if(conectado){


                      ref

                      .read(bluetoothProvider.notifier)

                      .desconectar();


                    }

                    else{


                      context.push('/bluetooth');


                    }


                  },


                ),


              ),

            ),





            // Tarjetas de estadísticas principales.
            // Muestran los resultados obtenidos durante
            // los entrenamientos del usuario.
            const SizedBox(height:20),




            Row(

              children: [


                Expanded(

                  child: _statCard(

                    "Mejor",

                    mejorTiempo,

                    Icons.emoji_events,

                    Colors.amber,

                  ),

                ),



                const SizedBox(width:12),




                Expanded(

                  child: _statCard(

                    "Último",

                    ultimoTiempo,

                    Icons.timer,

                    Colors.blue,

                  ),

                ),


              ],


            ),




            // Muestra el promedio general de rendimiento.
            const SizedBox(height:12),


            _wideCard(

              "Promedio",

              promedio,

              Icons.bar_chart,

              Colors.green,

            ),




            const SizedBox(height:25),




            // Botón principal del sistema.
            // En una versión final iniciará la comunicación
            // con el LED Trainer para comenzar una prueba.
            SizedBox(

              width:double.infinity,

              height:55,


              child: ElevatedButton.icon(


                onPressed:(){


                  ScaffoldMessenger.of(context)

                  .showSnackBar(

                    const SnackBar(

                      content: Text(
                        "Entrenamiento iniciado",
                      ),

                    ),

                  );


                },



                icon: const Icon(
                  Icons.play_arrow,
                ),



                label: const Text(

                  "COMENZAR ENTRENAMIENTO",

                  style: TextStyle(

                    fontSize:17,

                    fontWeight:FontWeight.bold,

                  ),

                ),


              ),

            ),




            const SizedBox(height:30),





            // Accesos secundarios de la aplicación.
            // Permiten navegar hacia las diferentes funciones.
            const Text(

              "Accesos rápidos",

              style: TextStyle(

                fontSize:22,

                fontWeight:FontWeight.bold,

              ),

            ),



            const SizedBox(height:15),




            // Acceso al historial de tiempos.
            Card(

              child: ListTile(

                leading:
                    const Icon(Icons.history),


                title:
                    const Text(
                      "Ver historial de tiempos",
                    ),


                trailing:
                    const Icon(
                      Icons.arrow_forward_ios,
                    ),


                onTap:(){

                  context.push('/tiempos');

                },


              ),

            ),




            // Acceso a la edición del perfil.
            Card(

              child: ListTile(

                leading:
                    const Icon(Icons.person),


                title:
                    const Text(
                      "Mi perfil",
                    ),


                trailing:
                    const Icon(
                      Icons.arrow_forward_ios,
                    ),


                onTap:(){

                  context.push('/editProfile');

                },


              ),

            ),




            // Acceso a la configuración.
            Card(

              child: ListTile(

                leading:
                    const Icon(Icons.settings),


                title:
                    const Text(
                      "Configuración",
                    ),


                trailing:
                    const Icon(
                      Icons.arrow_forward_ios,
                    ),


                onTap:(){

                  context.push('/settings');

                },


              ),

            ),




            const SizedBox(height:25),




            // Resumen de la última sesión realizada.
            // Actualmente utiliza valores de prueba,
            // pero luego se alimentará con datos reales.
            const Text(

              "Última sesión",

              style:TextStyle(

                fontSize:22,

                fontWeight:FontWeight.bold,

              ),

            ),



            const SizedBox(height:10),




            Card(

              child: const Padding(

                padding:EdgeInsets.all(16),


                child:Column(

                  children:[


                    Row(

                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,


                      children:[

                        Text("Intentos"),


                        Text(

                          "15",

                          style:TextStyle(

                            fontWeight:
                                FontWeight.bold,

                          ),

                        ),

                      ],

                    ),



                    SizedBox(height:10),




                    Row(

                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,


                      children:[

                        Text("Récord"),


                        Text(

                          "0.398 s",

                          style:TextStyle(

                            fontWeight:
                                FontWeight.bold,

                          ),

                        ),

                      ],

                    ),




                    SizedBox(height:10),




                    Row(

                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,


                      children:[

                        Text("Fecha"),


                        Text(

                          "03/07/2026",

                          style:TextStyle(

                            fontWeight:
                                FontWeight.bold,

                          ),

                        ),

                      ],

                    ),


                  ],

                ),

              ),

            ),


          ],

        ),

      ),


    );


  }



  // Widget reutilizable para mostrar una estadística.
  // Evita repetir código y mantiene un diseño uniforme.
  Widget _statCard(
      String titulo,
      String valor,
      IconData icono,
      Color color,
      ){

    return Card(

      child:Padding(

        padding:const EdgeInsets.all(18),


        child:Column(

          children:[


            Icon(

              icono,

              color:color,

              size:40,

            ),


            const SizedBox(height:10),



            Text(

              titulo,

              style:const TextStyle(

                fontWeight:FontWeight.bold,

              ),

            ),



            const SizedBox(height:8),



            Text(

              valor,

              style:const TextStyle(

                fontSize:22,

                fontWeight:FontWeight.bold,

              ),

            ),


          ],

        ),

      ),

    );

  }





  // Widget utilizado para mostrar información
  // en formato horizontal.
  Widget _wideCard(
      String titulo,
      String valor,
      IconData icono,
      Color color,
      ){


    return Card(

      child:ListTile(


        leading:Icon(

          icono,

          color:color,

          size:35,

        ),



        title:Text(

          titulo,

          style:const TextStyle(

            fontWeight:FontWeight.bold,

          ),

        ),



        trailing:Text(

          valor,

          style:const TextStyle(

            fontSize:22,

            fontWeight:FontWeight.bold,

          ),

        ),


      ),

    );


  }

}