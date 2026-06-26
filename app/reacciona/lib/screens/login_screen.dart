import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final email = TextEditingController();
    final pass = TextEditingController();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text('Iniciar sesión', style: TextStyle(fontSize: 30)),

            SizedBox(height: 20),

            TextField(
              controller: email,
              decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            TextField(
              controller: pass,
              decoration: InputDecoration(
                hintText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                context.go('/home');
              },
              child: Text('Ingresar'),
            ),

            TextButton(
              onPressed: () {
                context.go('/register');
              },
              child: Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}

