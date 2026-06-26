import 'package:flutter/material.dart';

class TiemposScreen extends StatelessWidget {
  const TiemposScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Tiempos')),

      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Tiempo ${index + 1}'),
          );
        },
      ),
    );
  }
}

