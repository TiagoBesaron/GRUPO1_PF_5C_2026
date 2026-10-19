import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class TiemposScreen extends StatelessWidget {
  const TiemposScreen({super.key});

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return "--/--/----";
    int ms = timestamp is int ? timestamp : (int.tryParse(timestamp.toString()) ?? 0);
    if (ms == 0) return "--/--/----";

    DateTime dt = DateTime.fromMillisecondsSinceEpoch(ms);
    String dia = dt.day.toString().padLeft(2, '0');
    String mes = dt.month.toString().padLeft(2, '0');
    String anio = dt.year.toString();
    String hora = dt.hour.toString().padLeft(2, '0');
    String min = dt.minute.toString().padLeft(2, '0');

    return "$dia/$mes/$anio - $hora:$min hs";
  }

  String _getModoEtiqueta(String? modo) {
    switch (modo) {
      case 'rondas':
        return 'Por Rondas';
      case 'tiempo':
        return 'Por Tiempo';
      case 'manual':
        return 'Modo Manual';
      default:
        return 'Entrenamiento';
    }
  }

  Color _getModoColor(String? modo) {
    switch (modo) {
      case 'rondas':
        return Colors.blue;
      case 'tiempo':
        return Colors.orange;
      case 'manual':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Sesiones'),
        centerTitle: true,
      ),
      body: user == null
          ? const Center(
              child: Text("Debés iniciar sesión para ver tu historial."),
            )
          : StreamBuilder<DatabaseEvent>(
              stream: FirebaseDatabase.instance
                  .ref('usuarios/${user.uid}/sesiones')
                  .onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData ||
                    snapshot.data!.snapshot.value == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history,
                            size: 64,
                            color: isDark ? Colors.grey[600] : Colors.grey[400]),
                        const SizedBox(height: 12),
                        Text(
                          "Aún no tenés sesiones registradas.",
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final List<Map<String, dynamic>> sesiones = [];

                try {
                  final rawData =
                      snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

                  rawData.forEach((key, value) {
                    if (value is Map) {
                      final tiemposRaw = value['tiempos'];
                      List<double> listaTiempos = [];

                      if (tiemposRaw is List) {
                        listaTiempos = tiemposRaw
                            .map((t) => (t as num).toDouble())
                            .toList();
                      }

                      sesiones.add({
                        'id': key,
                        'modo': value['modo'] ?? 'rondas',
                        'promedio_seg': (value['promedio_seg'] as num?)?.toDouble() ?? 0.0,
                        'tiempos': listaTiempos,
                        'timestamp': value['timestamp'] ?? 0,
                      });
                    }
                  });

                  // Ordenar de más reciente a más antigua
                  sesiones.sort((a, b) => (b['timestamp'] as num)
                      .compareTo(a['timestamp'] as num));
                } catch (e) {
                  debugPrint("Error al procesar el historial: $e");
                }

                if (sesiones.isEmpty) {
                  return const Center(
                    child: Text("No se encontraron registros válidos."),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: sesiones.length,
                  itemBuilder: (context, index) {
                    final sesion = sesiones[index];
                    final List<double> tiempos = sesion['tiempos'];
                    final String modoStr = sesion['modo'];
                    final double promedio = sesion['promedio_seg'];

                    double? mejorTiempo = tiempos.isNotEmpty
                        ? tiempos.reduce((a, b) => a < b ? a : b)
                        : null;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: isDark
                              ? Colors.grey.shade800
                              : Colors.grey.shade200,
                        ),
                      ),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor:
                              _getModoColor(modoStr).withValues(alpha: 0.15),
                          child: Icon(
                            Icons.timer_outlined,
                            color: _getModoColor(modoStr),
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(
                              _getModoEtiqueta(modoStr),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getModoColor(modoStr)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "${tiempos.length} toques",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _getModoColor(modoStr),
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDate(sesion['timestamp']),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                "Prom: ${promedio.toStringAsFixed(3)}s",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        children: [
                          Container(
                            color: isDark
                                ? const Color(0xFF181818)
                                : const Color(0xFFFAFAFA),
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Resumen rápido de la sesión
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildMiniStat(
                                      label: "Mejor Toque",
                                      value: mejorTiempo != null
                                          ? "${mejorTiempo.toStringAsFixed(3)}s"
                                          : "--",
                                      color: Colors.green,
                                    ),
                                    _buildMiniStat(
                                      label: "Promedio",
                                      value: "${promedio.toStringAsFixed(3)}s",
                                      color: Colors.blueAccent,
                                    ),
                                    _buildMiniStat(
                                      label: "Total Toques",
                                      value: "${tiempos.length}",
                                      color: Colors.orange,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Divider(),
                                const SizedBox(height: 8),

                                const Text(
                                  "Desglose por toque:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Grilla de tiempos desglosados
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: List.generate(tiempos.length, (i) {
                                    final tiempoItem = tiempos[i];
                                    final esElMejor =
                                        tiempoItem == mejorTiempo;

                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: esElMejor
                                            ? Colors.green.withValues(alpha: 0.15)
                                            : (isDark
                                                ? Colors.grey.shade800
                                                : Colors.grey.shade200),
                                        borderRadius: BorderRadius.circular(8),
                                        border: esElMejor
                                            ? Border.all(
                                                color: Colors.green, width: 1)
                                            : null,
                                      ),
                                      child: Text(
                                        "#${i + 1}: ${tiempoItem.toStringAsFixed(3)}s",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: esElMejor
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: esElMejor
                                              ? Colors.green
                                              : null,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildMiniStat({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}