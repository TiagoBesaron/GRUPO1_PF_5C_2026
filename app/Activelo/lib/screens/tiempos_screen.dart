import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class TiemposScreen extends StatefulWidget {
  const TiemposScreen({super.key});

  @override
  State<TiemposScreen> createState() => _TiemposScreenState();
}

class _TiemposScreenState extends State<TiemposScreen> {
  String _perfilFiltroId = 'todos'; // 'todos', 'principal', o ID de Firebase

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
      case 'bicolor':
        return 'Modo Bicolor';
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
      case 'bicolor':
        return Colors.teal;
      case 'manual':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _editarNotasSesion(String sesionId, String notasActuales) {
    final controller = TextEditingController(text: notasActuales);
    final user = FirebaseAuth.instance.currentUser;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Anotaciones de la Sesión'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Observaciones de la sesión',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (user != null) {
                await FirebaseDatabase.instance
                    .ref('usuarios/${user.uid}/sesiones/$sesionId')
                    .update({'notas_sesion': controller.text.trim()});
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('GUARDAR'),
          ),
        ],
      ),
    );
  }

  Widget _buildBarraFiltroUsuarios(User user, bool isDark) {
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance
          .ref('usuarios/${user.uid}/perfiles')
          .onValue,
      builder: (context, snapshot) {
        List<Map<String, String>> perfiles = [
          {'id': 'todos', 'nombre': 'Todos'},
          {'id': 'principal', 'nombre': 'Perfil Principal'},
        ];

        if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
          try {
            final raw = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            raw.forEach((key, value) {
              if (value is Map) {
                perfiles.add({
                  'id': key.toString(),
                  'nombre': value['nombre']?.toString() ?? 'Usuario',
                });
              }
            });
          } catch (e) {
            debugPrint("Error leyendo perfiles para filtro: $e");
          }
        }

        return Container(
          height: 52,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: perfiles.length,
            itemBuilder: (context, index) {
              final p = perfiles[index];
              final isSelected = _perfilFiltroId == p['id'];

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(p['nombre']!),
                  selected: isSelected,
                  selectedColor: Colors.blueAccent,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.grey[300] : Colors.black87),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _perfilFiltroId = p['id']!;
                      });
                    }
                  },
                ),
              );
            },
          ),
        );
      },
    );
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
          : Column(
              children: [
                _buildBarraFiltroUsuarios(user, isDark),
                const Divider(height: 1),
                Expanded(
                  child: StreamBuilder<DatabaseEvent>(
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
                            final perfilId = value['perfil_id'] ?? 'principal';

                            if (_perfilFiltroId == 'todos' || perfilId == _perfilFiltroId) {
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
                                'errores': (value['errores'] as num?)?.toInt() ?? 0,
                                'perfil_id': perfilId,
                                'perfil_nombre': value['perfil_nombre'] ?? '',
                                'notas_sesion': value['notas_sesion'] ?? '',
                                'timestamp': value['timestamp'] ?? 0,
                              });
                            }
                          }
                        });

                        sesiones.sort((a, b) => (b['timestamp'] as num)
                            .compareTo(a['timestamp'] as num));
                      } catch (e) {
                        debugPrint("Error al procesar el historial: $e");
                      }

                      if (sesiones.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.filter_alt_off,
                                  size: 48,
                                  color: isDark ? Colors.grey[600] : Colors.grey[400]),
                              const SizedBox(height: 12),
                              Text(
                                "No hay sesiones para este usuario.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
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
                          final int errores = sesion['errores'];
                          final String usuarioNombre = sesion['perfil_nombre'];
                          final String notas = sesion['notas_sesion'];

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
                                    _getModoColor(modoStr).withOpacity(0.15),
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
                                          .withOpacity(0.1),
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (usuarioNombre.isNotEmpty && usuarioNombre != "Uso Personal") ...[
                                      Text(
                                        "Usuario: $usuarioNombre",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? Colors.blue.shade200 : Colors.blue.shade800,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                    ],
                                    Row(
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
                                            label: "Errores",
                                            value: "$errores",
                                            color: errores > 0 ? Colors.redAccent : Colors.grey,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      const Divider(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Anotaciones de la sesión:",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.edit_note, color: Colors.blueAccent),
                                            onPressed: () => _editarNotasSesion(
                                              sesion['id'],
                                              notas,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        notas.isNotEmpty
                                            ? notas
                                            : "Sin anotaciones ingresadas.",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontStyle: notas.isEmpty ? FontStyle.italic : FontStyle.normal,
                                          color: notas.isEmpty ? Colors.grey : null,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      const Divider(),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "Desglose por toque válido:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
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
                                                  ? Colors.green.withOpacity(0.15)
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
                ),
              ],
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