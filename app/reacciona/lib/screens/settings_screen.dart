import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



// Pantalla de configuración de la aplicación.
// Desde esta sección el usuario puede acceder a opciones
// relacionadas con su cuenta y la gestión de la sesión.
class SettingsScreen extends StatelessWidget {

  const SettingsScreen({super.key});


  @override
  Widget build(BuildContext context) {


    return Scaffold(



      // Barra superior de la pantalla de ajustes.
      appBar: AppBar(

        title: const Text(
          'Ajustes',
        ),

      ),





      body: Column(

        mainAxisAlignment:
            MainAxisAlignment.center,


        children: [



          // Botón que permite acceder a la edición
          // de los datos personales del usuario.
          // Utiliza GoRouter para cambiar de pantalla
          // manteniendo una navegación organizada.
          ElevatedButton(

            onPressed:(){


              context.push('/editProfile');


            },


            child:const Text(
              'Editar perfil',
            ),


          ),





          // Botón para cerrar la sesión actual.
          // Actualmente solamente vuelve a la pantalla
          // de inicio de sesión.
          ElevatedButton(

            onPressed:(){


              context.go('/login');


            },


            child:const Text(
              'Cerrar sesión',
            ),


          ),


        ],


      ),


    );


  }

}