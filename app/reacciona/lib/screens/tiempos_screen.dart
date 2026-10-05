import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class TiemposScreen extends StatelessWidget {
  const TiemposScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final ref = FirebaseDatabase.instance.ref("usuarios/${user?.uid}/tiempos");

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Tiempos')),
      body: StreamBuilder(
        stream: ref.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
            return const Center(child: Text("Aún no tienes tiempos registrados"));
          }

          Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          List<Map<String, dynamic>> lista = [];

          map.forEach((key, value) {
            lista.add(Map<String, dynamic>.from(value));
          });

          // Ordenar por más reciente
          lista.sort((a, b) => (b['timestamp'] ?? 0).compareTo(a['timestamp'] ?? 0));

          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final item = lista[index];
              return ListTile(
                leading: const Icon(Icons.timer, color: Colors.blue),
                title: Text("${item['tiempo_seg']} segundos"),
                subtitle: Text("${item['tiempo_ms']} ms"),
              );
            },
          );
        },
      ),
    );
  }
}