import 'package:flutter/material.dart';



// Pantalla encargada de mostrar el historial de tiempos
// obtenidos durante las sesiones de entrenamiento.
// Actualmente utiliza datos simulados
class TiemposScreen extends StatelessWidget {

  const TiemposScreen({super.key});


  @override
  Widget build(BuildContext context) {


    return Scaffold(



      // Barra superior de la pantalla de tiempos.
      appBar: AppBar(

        title: const Text(
          'Tiempos',
        ),

      ),





      // Lista donde se mostrarán los registros
      // de tiempos realizados por el usuario.
      body: ListView.builder(



        // Cantidad actual de elementos de prueba.
        // Posteriormente dependerá de la cantidad
        // de entrenamientos almacenados.
        itemCount:5,



        itemBuilder:(context,index){



          // Cada elemento representa un registro
          // individual de entrenamiento.
          return ListTile(

            title:Text(
              'Tiempo ${index + 1}',
            ),

          );


        },

      ),


    );


  }

}