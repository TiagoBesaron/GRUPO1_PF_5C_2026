import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final nombre = TextEditingController();
    final edad = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Editar perfil')),

      body: Column(
        children: [

          TextField(controller: nombre, decoration: InputDecoration(hintText: 'Nombre')),
          TextField(controller: edad, decoration: InputDecoration(hintText: 'Edad')),

          SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {},
            child: Text('Modificar'),
          )
        ],
      ),
    );
  }
}

