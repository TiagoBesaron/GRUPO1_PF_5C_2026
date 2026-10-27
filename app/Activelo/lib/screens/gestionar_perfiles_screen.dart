import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../provider/perfil_provider.dart';

class GestionarPerfilesScreen extends ConsumerStatefulWidget {
  const GestionarPerfilesScreen({super.key});

  @override
  ConsumerState<GestionarPerfilesScreen> createState() =>
      _GestionarPerfilesScreenState();
}

class _GestionarPerfilesScreenState
    extends ConsumerState<GestionarPerfilesScreen> {
  void _mostrarDialogoNuevoPerfil(
      [String? id, String? nombreActual, String? notasActuales]) {
    final nombreController = TextEditingController(text: nombreActual ?? '');
    final notasController = TextEditingController(text: notasActuales ?? '');
    final user = FirebaseAuth.instance.currentUser;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(id == null ? 'Nuevo Usuario' : 'Editar Usuario'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre Completo',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notasController,
              decoration: const InputDecoration(
                labelText: 'Notas / Observaciones',
                prefixIcon: Icon(Icons.notes),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () async {
              final nombre = nombreController.text.trim();
              final notas = notasController.text.trim();
              if (nombre.isEmpty || user == null) return;

              final ref = FirebaseDatabase.instance
                  .ref('usuarios/${user.uid}/perfiles');

              if (id == null) {
                await ref.push().set({
                  'nombre': nombre,
                  'notas': notas,
                  'created_at': ServerValue.timestamp,
                });
              } else {
                await ref.child(id).update({
                  'nombre': nombre,
                  'notas': notas,
                });
              }

              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('GUARDAR'),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _calcularMetricasUsuario(
      Map<dynamic, dynamic>? rawSesiones, String perfilId) {
    if (rawSesiones == null) {
      return {
        'mejorPromedio': null,
        'mejorTiempo': null,
        'mejorTiempoUltima': null,
        'promedioUltima': null,
      };
    }

    List<Map<String, dynamic>> sesionesUsuario = [];

    rawSesiones.forEach((key, value) {
      if (value is Map) {
        final pid = value['perfil_id'] ?? 'principal';
        if (pid == perfilId) {
          final listTiemposRaw = value['tiempos'];
          List<double> tiempos = [];
          if (listTiemposRaw is List) {
            tiempos =
                listTiemposRaw.map((t) => (t as num).toDouble()).toList();
          }

          sesionesUsuario.add({
            'promedio_seg': (value['promedio_seg'] as num?)?.toDouble() ?? 0.0,
            'tiempos': tiempos,
            'timestamp': (value['timestamp'] as num?)?.toInt() ?? 0,
          });
        }
      }
    });

    if (sesionesUsuario.isEmpty) {
      return {
        'mejorPromedio': null,
        'mejorTiempo': null,
        'mejorTiempoUltima': null,
        'promedioUltima': null,
      };
    }

    // Ordenar de más reciente a más antigua
    sesionesUsuario.sort((a, b) =>
        (b['timestamp'] as num).compareTo(a['timestamp'] as num));

    final ultimaSesion = sesionesUsuario.first;
    final double promedioUltima = ultimaSesion['promedio_seg'];

    final List<double> tiemposUltima = ultimaSesion['tiempos'];
    final double? mejorTiempoUltima = tiemposUltima.isNotEmpty
        ? tiemposUltima.reduce((a, b) => a < b ? a : b)
        : null;

    final double mejorPromedio = sesionesUsuario
        .map((s) => s['promedio_seg'] as double)
        .reduce((a, b) => a < b ? a : b);

    List<double> todosLosTiempos = [];
    for (var s in sesionesUsuario) {
      todosLosTiempos.addAll(s['tiempos'] as List<double>);
    }

    final double? mejorTiempo = todosLosTiempos.isNotEmpty
        ? todosLosTiempos.reduce((a, b) => a < b ? a : b)
        : null;

    return {
      'mejorPromedio': mejorPromedio,
      'mejorTiempo': mejorTiempo,
      'mejorTiempoUltima': mejorTiempoUltima,
      'promedioUltima': promedioUltima,
    };
  }

  Widget _buildGridMetricas(Map<String, dynamic> stats, bool isDark) {
    String fmt(num? val) =>
        (val != null && val > 0) ? "${val.toStringAsFixed(3)} s" : "-- s";

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12, top: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252525) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildItemMetrica(
                  label: "Mejor Promedio",
                  value: fmt(stats['mejorPromedio']),
                  icon: Icons.star,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildItemMetrica(
                  label: "Mejor Tiempo",
                  value: fmt(stats['mejorTiempo']),
                  icon: Icons.bolt,
                  color: Colors.orangeAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildItemMetrica(
                  label: "Mejor (Últ. Sesión)",
                  value: fmt(stats['mejorTiempoUltima']),
                  icon: Icons.timer,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildItemMetrica(
                  label: "Prom. (Últ. Sesión)",
                  value: fmt(stats['promedioUltima']),
                  icon: Icons.bar_chart,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemMetrica({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final perfilActivo = ref.watch(perfilActivoProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarDialogoNuevoPerfil(),
        icon: const Icon(Icons.person_add),
        label: const Text('Agregar'),
      ),
      body: user == null
          ? const Center(child: Text('Iniciá sesión para gestionar perfiles.'))
          : StreamBuilder<DatabaseEvent>(
              stream: FirebaseDatabase.instance
                  .ref('usuarios/${user.uid}/sesiones')
                  .onValue,
              builder: (context, snapshotSesiones) {
                final Map<dynamic, dynamic>? rawSesiones =
                    snapshotSesiones.hasData &&
                            snapshotSesiones.data!.snapshot.value != null
                        ? snapshotSesiones.data!.snapshot.value
                            as Map<dynamic, dynamic>
                        : null;

                return StreamBuilder<DatabaseEvent>(
                  stream: FirebaseDatabase.instance
                      .ref('usuarios/${user.uid}/perfiles')
                      .onValue,
                  builder: (context, snapshotPerfiles) {
                    if (snapshotPerfiles.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final List<Map<String, dynamic>> perfiles = [];

                    if (snapshotPerfiles.hasData &&
                        snapshotPerfiles.data!.snapshot.value != null) {
                      final raw = snapshotPerfiles.data!.snapshot.value
                          as Map<dynamic, dynamic>;
                      raw.forEach((key, value) {
                        if (value is Map) {
                          perfiles.add({
                            'id': key,
                            'nombre': value['nombre'] ?? 'Sin nombre',
                            'notas': value['notas'] ?? '',
                          });
                        }
                      });
                    }

                    final statsPrincipal =
                        _calcularMetricasUsuario(rawSesiones, 'principal');

                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          color: isDark
                              ? Colors.grey.shade900
                              : Colors.blue.shade50,
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline,
                                  color: Colors.blueAccent),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Seleccioná el usuario que entrenará en esta sesión.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark
                                        ? Colors.grey.shade300
                                        : Colors.grey.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: perfilActivo == null
                                  ? Colors.blueAccent
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: perfilActivo == null
                                      ? Colors.blueAccent
                                      : Colors.grey.shade400,
                                  child: const Icon(Icons.person,
                                      color: Colors.white),
                                ),
                                title: const Text(
                                  'Perfil Principal (Propietario)',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: const Text(
                                    'Sin usuario asignado explícitamente'),
                                trailing: perfilActivo == null
                                    ? const Icon(Icons.check_circle,
                                        color: Colors.green)
                                    : null,
                                onTap: () {
                                  ref
                                      .read(perfilActivoProvider.notifier)
                                      .deseleccionar();
                                  Navigator.pop(context);
                                },
                              ),
                              _buildGridMetricas(statsPrincipal, isDark),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        Expanded(
                          child: perfiles.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Aún no cargaste usuarios.\nTocá en "Agregar" para crear uno.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  itemCount: perfiles.length,
                                  itemBuilder: (context, index) {
                                    final item = perfiles[index];
                                    final esSeleccionado =
                                        perfilActivo?.id == item['id'];
                                    final statsItem = _calcularMetricasUsuario(
                                        rawSesiones, item['id']);

                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        side: BorderSide(
                                          color: esSeleccionado
                                              ? Colors.blueAccent
                                              : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: esSeleccionado
                                                  ? Colors.blueAccent
                                                  : Colors.blue.shade100,
                                              child: Text(
                                                item['nombre'][0]
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: esSeleccionado
                                                      ? Colors.white
                                                      : Colors.blue.shade900,
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              item['nombre'],
                                              style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold),
                                            ),
                                            subtitle: item['notas'].isNotEmpty
                                                ? Text(item['notas'])
                                                : null,
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons.edit_outlined,
                                                      size: 20),
                                                  onPressed: () =>
                                                      _mostrarDialogoNuevoPerfil(
                                                    item['id'],
                                                    item['nombre'],
                                                    item['notas'],
                                                  ),
                                                ),
                                                if (esSeleccionado)
                                                  const Icon(Icons.check_circle,
                                                      color: Colors.green),
                                              ],
                                            ),
                                            onTap: () {
                                              ref
                                                  .read(perfilActivoProvider
                                                      .notifier)
                                                  .seleccionarPerfil(
                                                    item['id'],
                                                    item['nombre'],
                                                    notas: item['notas'],
                                                  );
                                              Navigator.pop(context);
                                            },
                                          ),
                                          _buildGridMetricas(statsItem, isDark),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
    );
  }
}