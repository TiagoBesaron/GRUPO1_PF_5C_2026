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
  void _mostrarDialogoNuevoPerfil([String? id, String? nombreActual, String? notasActuales]) {
    final nombreController = TextEditingController(text: nombreActual ?? '');
    final notasController = TextEditingController(text: notasActuales ?? '');
    final user = FirebaseAuth.instance.currentUser;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(id == null ? 'Nuevo Paciente / Atleta' : 'Editar Paciente'),
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
                labelText: 'Notas / Diagnóstico (Ej: Lesión rodilla)',
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

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final perfilActivo = ref.watch(perfilActivoProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes y Atletas'),
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
                  .ref('usuarios/${user.uid}/perfiles')
                  .onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final List<Map<String, dynamic>> perfiles = [];

                if (snapshot.hasData &&
                    snapshot.data!.snapshot.value != null) {
                  final raw =
                      snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
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

                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      color: isDark ? Colors.grey.shade900 : Colors.blue.shade50,
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Colors.blueAccent),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Seleccioná el paciente que entrenará en esta sesión.',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: perfilActivo == null
                            ? Colors.blueAccent
                            : Colors.grey.shade400,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      title: const Text(
                        'Perfil Principal (Propietario)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text('Sin atleta asignado explícitamente'),
                      trailing: perfilActivo == null
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () {
                        ref.read(perfilActivoProvider.notifier).deseleccionar();
                        Navigator.pop(context);
                      },
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: perfiles.isEmpty
                          ? const Center(
                              child: Text(
                                'Aún no cargaste atletas ni pacientes.\nTocá en "Agregar" para crear uno.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: perfiles.length,
                              itemBuilder: (context, index) {
                                final item = perfiles[index];
                                final esSeleccionado =
                                    perfilActivo?.id == item['id'];

                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: esSeleccionado
                                          ? Colors.blueAccent
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: esSeleccionado
                                          ? Colors.blueAccent
                                          : Colors.blue.shade100,
                                      child: Text(
                                        item['nombre'][0].toUpperCase(),
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
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: item['notas'].isNotEmpty
                                        ? Text(item['notas'])
                                        : null,
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit_outlined,
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
                                          .read(perfilActivoProvider.notifier)
                                          .seleccionarPerfil(
                                            item['id'],
                                            item['nombre'],
                                            notas: item['notas'],
                                          );
                                      Navigator.pop(context);
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}