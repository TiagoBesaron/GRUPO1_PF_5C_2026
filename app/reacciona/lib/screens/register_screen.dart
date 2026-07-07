import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



// Pantalla encargada del registro de nuevos usuarios.
// Permite ingresar los datos necesarios para crear un perfil
// dentro de la aplicación LED Trainer.
class RegisterScreen extends StatelessWidget {

  const RegisterScreen({super.key});


  @override
  Widget build(BuildContext context) {


    // Controladores utilizados para obtener la información
    // ingresada por el usuario en el formulario.
    final nombre = TextEditingController();

    final edad = TextEditingController();

    final email = TextEditingController();

    final pass = TextEditingController();



    return Scaffold(



      // Barra superior de la pantalla de registro.
      appBar: AppBar(

        title: const Text(
          'Registrarse',
        ),

      ),





      body: Column(

        children: [



          // Campo para ingresar el nombre del usuario.
          TextField(

            controller:nombre,

            decoration:const InputDecoration(

              hintText:'Nombre',

            ),

          ),





          // Campo utilizado para almacenar la edad del usuario.
          TextField(

            controller:edad,

            decoration:const InputDecoration(

              hintText:'Edad',

            ),

          ),





          // Campo para ingresar el correo electrónico.
          TextField(

            controller:email,

            decoration:const InputDecoration(

              hintText:'Email',

            ),

          ),





          // Campo para ingresar la contraseña.
          TextField(

            controller:pass,

            decoration:const InputDecoration(

              hintText:'Contraseña',

            ),

          ),





          const SizedBox(height:20),





          // Botón encargado de finalizar el registro.
          // Actualmente solamente navega hacia la pantalla principal.
          // En una implementación completa debería validar
          // los datos y crear el usuario.
          ElevatedButton(

            onPressed:(){


              context.go('/home');


            },


            child:
                const Text(
                  'Registrar',
                ),


          )


        ],

      ),


    );


  }

}