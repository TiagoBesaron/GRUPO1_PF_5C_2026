import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Inicio')),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text('Nombre de la persona'),

          SizedBox(height: 20),

          Text('Mejor tiempo'),
          Container(height: 50, width: 200, color: Colors.grey),

          SizedBox(height: 20),

          Text('Tiempo actual'),
          Container(height: 50, width: 200, color: Colors.grey),

          SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              context.push('/tiempos');
            },
            child: Text('Ver tiempos'),
          )
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Ajustes"),
        ],
        onTap: (index) {
          if (index == 1) {
            context.go('/settings');
          }
        },
      ),
    );
  }
}

