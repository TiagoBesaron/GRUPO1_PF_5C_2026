import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:file_picker/file_picker.dart';
import '../provider/perfil_provider.dart';

class GestionarPerfilesScreen extends ConsumerStatefulWidget {
  const GestionarPerfilesScreen({super.key});

  @override
  ConsumerState<GestionarPerfilesScreen> createState() =>
      _GestionarPerfilesScreenState();
}

class _GestionarPerfilesScreenState
    extends ConsumerState<GestionarPerfilesScreen> {

  Future<String?> _seleccionarFotoBase64() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.bytes != null) {
          final base64Str = base64Encode(file.bytes!);
          final ext = file.name.contains('.')
              ? file.name.split('.').last.toLowerCase()
              : 'jpg';
          final mime = ext == 'png' ? 'image/png' : 'image/jpeg';
          return 'data:$mime;base64,$base64Str';
        }
      }
    } catch (e) {
      debugPrint('Error al seleccionar imagen: $e');
    }
    return null;
  }

  Future<void> _confirmarEliminarPerfil(String id, String nombre) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Eliminar Usuario'),
        content: Text('¿Estás seguro de que deseas eliminar el perfil de "$nombre"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: const Text('ELIMINAR'),
          ),
        ],
      ),
    );

    if (confirmado == true) {
      final perfilActivo = ref.read(perfilActivoProvider);
      if (perfilActivo?.id == id) {
        ref.read(perfilActivoProvider.notifier).deseleccionar();
      }

      await FirebaseDatabase.instance
          .ref('usuarios/${user.uid}/perfiles/$id')
          .remove();
    }
  }

  void _mostrarDialogoNuevoPerfil([
    String? id,
    String? nombreActual,
    String? notasActuales,
    String? photoUrlActual,
  ]) {
    final nombreController = TextEditingController(text: nombreActual ?? '');
    final notasController = TextEditingController(text: notasActuales ?? '');
    final user = FirebaseAuth.instance.currentUser;
    String? fotoTemporal = photoUrlActual;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final avatarImg = _obtenerImagen(fotoTemporal);

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                id == null ? 'Nuevo Usuario' : 'Editar Usuario',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final foto = await _seleccionarFotoBase64();
                        if (foto != null) {
                          setDialogState(() {
                            fotoTemporal = foto;
                          });
                        }
                      },
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 42,
                            backgroundColor: Colors.blue.shade100,
                            backgroundImage: avatarImg,
                            child: avatarImg == null
                                ? const Icon(
                                    Icons.person,
                                    size: 48,
                                    color: Colors.blueAccent,
                                  )
                                : null,
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.blueAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    OutlinedButton.icon(
                      onPressed: () async {
                        final foto = await _seleccionarFotoBase64();
                        if (foto != null) {
                          setDialogState(() {
                            fotoTemporal = foto;
                          });
                        }
                      },
                      icon: const Icon(Icons.upload_file, size: 18),
                      label: Text(
                        fotoTemporal == null ? 'Subir foto' : 'Cambiar foto',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blueAccent,
                        side: const BorderSide(color: Colors.blueAccent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    if (fotoTemporal != null) ...[
                      const SizedBox(height: 4),
                      TextButton.icon(
                        onPressed: () {
                          setDialogState(() {
                            fotoTemporal = null;
                          });
                        },
                        icon: const Icon(Icons.delete_outline,
                            size: 18, color: Colors.redAccent),
                        label: const Text(
                          'Eliminar foto',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),

                    TextField(
                      controller: nombreController,
                      textCapitalization: TextCapitalization.words,
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
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CANCELAR'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
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
                        'photoUrl': fotoTemporal,
                        'created_at': ServerValue.timestamp,
                      });
                    } else {
                      await ref.child(id).update({
                        'nombre': nombre,
                        'notas': notas,
                        'photoUrl': fotoTemporal,
                      });
                    }

                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text('GUARDAR'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  ImageProvider? _obtenerImagen(String? photoUrl) {
    if (photoUrl == null || photoUrl.isEmpty) return null;
    if (photoUrl.startsWith('data:image')) {
      try {
        final base64Str = photoUrl.split(',').last;
        return MemoryImage(base64Decode(base64Str));
      } catch (_) {
        return null;
      }
    }
    return NetworkImage(photoUrl);
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
          } else if (listTiemposRaw is Map) {
            listTiemposRaw.forEach((k, v) {
              if (v is num) tiempos.add(v.toDouble());
            });
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
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        onPressed: () => _mostrarDialogoNuevoPerfil(),
        icon: const Icon(Icons.person_add),
        label: const Text('Agregar'),
      ),
      body: user == null
          ? const Center(child: Text('Iniciá sesión para gestionar perfiles.'))
          : StreamBuilder<DatabaseEvent>(
              stream: FirebaseDatabase.instance
                  .ref('usuarios/${user.uid}')
                  .onValue,
              builder: (context, snapshotUserData) {
                return StreamBuilder<DatabaseEvent>(
                  stream: FirebaseDatabase.instance
                      .ref('usuarios/${user.uid}/sesiones')
                      .onValue,
                  builder: (context, snapshotSesiones) {
                    if (snapshotUserData.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final Map<dynamic, dynamic>? rawSesiones =
                        snapshotSesiones.hasData &&
                                snapshotSesiones.data!.snapshot.value != null
                            ? snapshotSesiones.data!.snapshot.value
                                as Map<dynamic, dynamic>
                            : null;

                    String nombrePrincipal =
                        user.displayName?.trim().isNotEmpty == true
                            ? user.displayName!
                            : 'Perfil Principal (Propietario)';
                    String? photoUrlPrincipal = user.photoURL;

                    final List<Map<String, dynamic>> perfilesSecundarios = [];

                    if (snapshotUserData.hasData &&
                        snapshotUserData.data!.snapshot.value != null) {
                      final rawData = snapshotUserData.data!.snapshot.value;
                      if (rawData is Map) {
                        final userData = Map<String, dynamic>.from(rawData);
                        if (userData['nombre'] != null &&
                            (userData['nombre'] as String).trim().isNotEmpty) {
                          nombrePrincipal = userData['nombre'].toString().trim();
                        }
                        if (userData['photoUrl'] != null &&
                            (userData['photoUrl'] as String).isNotEmpty) {
                          photoUrlPrincipal = userData['photoUrl'].toString();
                        }

                        if (userData['perfiles'] is Map) {
                          final perfilesMap =
                              Map<String, dynamic>.from(userData['perfiles']);
                          perfilesMap.forEach((key, value) {
                            if (value is Map) {
                              perfilesSecundarios.add({
                                'id': key,
                                'nombre': value['nombre'] ?? 'Sin nombre',
                                'notas': value['notas'] ?? '',
                                'photoUrl': value['photoUrl'],
                              });
                            }
                          });
                        }
                      }
                    }

                    final todosLosPerfiles = [
                      {
                        'id': 'principal',
                        'esPrincipal': true,
                        'nombre': nombrePrincipal,
                        'notas': 'Cuenta Principal',
                        'photoUrl': photoUrlPrincipal,
                      },
                      ...perfilesSecundarios.map((p) => {
                            'id': p['id'],
                            'esPrincipal': false,
                            'nombre': p['nombre'],
                            'notas': p['notas'],
                            'photoUrl': p['photoUrl'],
                          }),
                    ];

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
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.only(
                              left: 12,
                              right: 12,
                              top: 12,
                              bottom: 80,
                            ),
                            itemCount: todosLosPerfiles.length,
                            itemBuilder: (context, index) {
                              final item = todosLosPerfiles[index];
                              final bool esPrincipal =
                                  item['esPrincipal'] as bool;
                              final String id = item['id'] as String;
                              final String nombre = item['nombre'] as String;
                              final String notas = item['notas'] as String;
                              final String? photoUrl = item['photoUrl'] as String?;

                              final bool esSeleccionado = esPrincipal
                                  ? perfilActivo == null
                                  : perfilActivo?.id == id;

                              final statsItem =
                                  _calcularMetricasUsuario(rawSesiones, id);
                              final avatarImg = _obtenerImagen(photoUrl);

                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
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
                                        backgroundImage: avatarImg,
                                        child: avatarImg == null
                                            ? Text(
                                                nombre.isNotEmpty
                                                    ? nombre[0].toUpperCase()
                                                    : 'U',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: esSeleccionado
                                                      ? Colors.white
                                                      : Colors.blue.shade900,
                                                ),
                                              )
                                            : null,
                                      ),
                                      title: Text(
                                        nombre,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        esPrincipal
                                            ? 'Perfil Principal (Propietario)'
                                            : (notas.isNotEmpty ? notas : 'Usuario registrado'),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (!esPrincipal) ...[
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.edit_outlined,
                                                  size: 20),
                                              onPressed: () =>
                                                  _mostrarDialogoNuevoPerfil(
                                                id,
                                                nombre,
                                                notas,
                                                photoUrl,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.redAccent,
                                                  size: 20),
                                              onPressed: () =>
                                                  _confirmarEliminarPerfil(
                                                id,
                                                nombre,
                                              ),
                                            ),
                                          ],
                                          if (esSeleccionado)
                                            const Icon(Icons.check_circle,
                                                color: Colors.green),
                                        ],
                                      ),
                                      onTap: () {
                                        if (esPrincipal) {
                                          ref
                                              .read(perfilActivoProvider.notifier)
                                              .deseleccionar();
                                        } else {
                                          ref
                                              .read(perfilActivoProvider.notifier)
                                              .seleccionarPerfil(
                                                id,
                                                nombre,
                                                notas: notas,
                                              );
                                        }
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