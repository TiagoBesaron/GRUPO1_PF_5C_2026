import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


// Pantalla inicial de acceso a la aplicación.
// Permite al usuario ingresar sus credenciales antes
// de acceder al sistema LED Trainer.
class LoginScreen extends StatelessWidget {

  const LoginScreen({super.key});


  @override
  Widget build(BuildContext context) {


    // Controladores encargados de obtener la información
    // ingresada por el usuario en los campos de texto.
    // Actualmente la validación es simulada.
    // En una versión final se pueden utilizar para validar
    // usuarios mediante Firebase.
    final email = TextEditingController();

    final pass = TextEditingController();



    return Scaffold(


      body: Center(


        child: Column(

          mainAxisAlignment:
              MainAxisAlignment.center,


          children: [



            // Título principal de la pantalla.
            const Text(

              'Iniciar sesión',

              style: TextStyle(

                fontSize:30,

              ),

            ),



            const SizedBox(height:20),




            // Campo donde el usuario ingresa su correo electrónico.
            TextField(

              controller: email,


              decoration: const InputDecoration(

                hintText:'Email',

                border:OutlineInputBorder(),

              ),

            ),




            const SizedBox(height:20),





            // Campo donde el usuario ingresa su contraseña.
            TextField(

              controller: pass,


              decoration: const InputDecoration(

                hintText:'Contraseña',

                border:OutlineInputBorder(),

              ),

            ),




            const SizedBox(height:20),





            // Botón de ingreso.
            // Actualmente solamente redirige a la pantalla principal.
            ElevatedButton(

              onPressed:(){


                context.go('/home');


              },


              child:
                  const Text('Ingresar'),

            ),




            // Permite acceder a la pantalla de registro
            // cuando el usuario todavía no posee una cuenta.
            TextButton(

              onPressed:(){


                context.go('/register');


              },


              child:
                  const Text('Registrarse'),

            ),


          ],

        ),

      ),


    );


  }

}