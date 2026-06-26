import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final nombre = TextEditingController();
    final edad = TextEditingController();
    final email = TextEditingController();
    final pass = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Registrarse')),

      body: Column(
        children: [

          TextField(controller: nombre, decoration: InputDecoration(hintText: 'Nombre')),
          TextField(controller: edad, decoration: InputDecoration(hintText: 'Edad')),
          TextField(controller: email, decoration: InputDecoration(hintText: 'Email')),
          TextField(controller: pass, decoration: InputDecoration(hintText: 'Contraseña')),

          SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              context.go('/home');
            },
            child: Text('Registrar'),
          )
        ],
      ),
    );
  }
}

