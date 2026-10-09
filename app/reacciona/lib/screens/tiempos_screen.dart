import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class TiemposScreen extends StatelessWidget {
  const TiemposScreen({super.key});

  String _formatFecha(dynamic timestamp) {
    if (timestamp == null || timestamp is! num) return "Fecha reciente";
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp.toInt());
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Tiempos'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: user == null
            ? const Center(child: Text("Debes iniciar sesión para ver tus tiempos"))
            : StreamBuilder<DatabaseEvent>(
                stream: FirebaseDatabase.instance
                    .ref('usuarios/${user.uid}/tiempos')
                    .onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Ocurrió un error al cargar los datos"),
                    );
                  }

                  final data = snapshot.data?.snapshot.value;

                  if (data == null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.timer_off_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Aún no tenés registros de entrenamiento.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Realizá una sesión para ver tus resultados acá.",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  final Map<dynamic, dynamic> mapTiempos =
                      data as Map<dynamic, dynamic>;
                  final List<Map<String, dynamic>> listaHistorial = [];

                  mapTiempos.forEach((key, value) {
                    if (value is Map) {
                      listaHistorial.add({
                        "id": key,
                        "tiempoMs": value["tiempoMs"] ?? 0,
                        "timestamp": value["timestamp"] ?? 0,
                      });
                    }
                  });

                  listaHistorial.sort((a, b) =>
                      (a["timestamp"] as num).compareTo(b["timestamp"] as num));

                  final historialInvertido = listaHistorial.reversed.toList();

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: historialInvertido.length,
                    itemBuilder: (context, index) {
                      final item = historialInvertido[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.amber.shade100,
                            child: const Icon(Icons.bolt, color: Colors.amber),
                          ),
                          title: Text(
                            "Intento #${historialInvertido.length - index}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(_formatFecha(item["timestamp"])),
                          trailing: Text(
                            "${item["tiempoMs"]} ms",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}