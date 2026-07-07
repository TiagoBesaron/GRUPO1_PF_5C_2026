import 'package:flutter/material.dart';


// Pantalla encargada de permitir al usuario editar
// sus datos personales.
class EditProfileScreen extends StatelessWidget {

  const EditProfileScreen({super.key});


  @override
  Widget build(BuildContext context) {


    // Controladores utilizados para obtener el texto ingresado
    // por el usuario en los campos del formulario.
    final nombre = TextEditingController();

    final edad = TextEditingController();



    return Scaffold(


      // Barra superior de la pantalla.
      appBar: AppBar(
        title: const Text(
          'Editar perfil',
        ),
      ),



      body: Column(

        children: [



          // Campo de entrada para modificar el nombre del usuario.
          TextField(

            controller: nombre,

            decoration: const InputDecoration(

              hintText: 'Nombre',

            ),

          ),




          // Campo de entrada para modificar la edad del usuario.
          TextField(

            controller: edad,

            decoration: const InputDecoration(

              hintText: 'Edad',

            ),

          ),




          const SizedBox(height:20),




          // Botón encargado de confirmar los cambios realizados.
          // Actualmente no tiene lógica asociada
          ElevatedButton(

            onPressed: () {},

            child: const Text(
              'Modificar',
            ),

          )


        ],

      ),

    );


  }

}