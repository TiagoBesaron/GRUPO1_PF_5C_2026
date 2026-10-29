import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:file_picker/file_picker.dart';
import '../provider/theme_provider.dart';
import '../provider/user_mode_provider.dart';
import '../provider/sound_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _getNombreArchivo(String? path, String defaultName, List<SoundItem> library) {
    if (path == null || path.isEmpty) return 'Predeterminado ($defaultName)';
    final match = library.where((item) => item.path == path);
    if (match.isNotEmpty) return match.first.name;
    if (path.startsWith('data:')) return 'Audio Personalizado';
    if (path.contains('/')) return path.split('/').last;
    if (path.contains('\\')) return path.split('\\').last;
    return path;
  }

  bool _esCumpleanosHoy(String? fechaIsoStr) {
    if (fechaIsoStr == null || fechaIsoStr.isEmpty) return false;
    try {
      final fechaNac = DateTime.parse(fechaIsoStr);
      final hoy = DateTime.now();
      return fechaNac.day == hoy.day && fechaNac.month == hoy.month;
    } catch (_) {
      return false;
    }
  }

  Future<void> _agregarYSeleccionarAudio({
    required String defaultFileName,
    required Function(String?) onSelected,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'm4a', 'aac', 'ogg'],
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        final nuevoSonido = await ref
            .read(customSoundsLibraryProvider.notifier)
            .agregarSonido(
              name: file.name,
              path: file.path,
              bytes: file.bytes,
            );

        if (nuevoSonido != null) {
          onSelected(nuevoSonido.path);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Sonido guardado: ${file.name}'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Archivo no válido o supera el peso máximo (3MB).'),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error seleccionando archivo de audio: $e');
    }
  }

  void _mostrarSelectorSonido({
    required BuildContext context,
    required String titulo,
    required String defaultFileName,
    required String? currentPath,
    required Function(String?) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        return Consumer(
          builder: (context, ref, child) {
            final library = ref.watch(customSoundsLibraryProvider);

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 8.0),
                      child: Text(
                        titulo,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(),
                    RadioGroup<String?>(
                      groupValue: currentPath,
                      onChanged: (val) {
                        onSelected(val);
                        Navigator.pop(modalContext);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RadioListTile<String?>(
                            title: Text('Predeterminado ($defaultFileName)'),
                            subtitle: const Text('Sonido original de la app'),
                            value: null,
                            secondary: IconButton(
                              icon: const Icon(Icons.play_circle_fill,
                                  color: Colors.blue),
                              onPressed: () {
                                ref
                                    .read(soundServiceProvider)
                                    .playPreview(null, defaultFileName);
                              },
                            ),
                          ),
                          ...library.map((sound) {
                            return RadioListTile<String?>(
                              title: Text(sound.name),
                              subtitle: Text(
                                sound.path.startsWith('data:')
                                    ? 'Archivo guardado en memoria'
                                    : sound.path,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              value: sound.path,
                              secondary: IconButton(
                                icon: const Icon(Icons.play_circle_fill,
                                    color: Colors.blue),
                                onPressed: () {
                                  ref
                                      .read(soundServiceProvider)
                                      .playPreview(sound.path, defaultFileName);
                                },
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                      title: const Text(
                        'Agregar nuevo sonido',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      subtitle: const Text('Seleccionar archivo (.mp3, .wav)'),
                      onTap: () async {
                        Navigator.pop(modalContext);
                        await _agregarYSeleccionarAudio(
                          defaultFileName: defaultFileName,
                          onSelected: onSelected,
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final esModoProfesional = ref.watch(modoProfesionalProvider);
    final sonidoHabilitado = ref.watch(soundEnabledProvider);

    final selectedStartPath = ref.watch(selectedStartSoundProvider);
    final selectedFinishPath = ref.watch(selectedFinishSoundProvider);
    final soundLibrary = ref.watch(customSoundsLibraryProvider);
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes y Configuración'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ENCABEZADO PERFIL ESTILO FACEBOOK
            if (currentUser != null)
              StreamBuilder<DatabaseEvent>(
                stream: FirebaseDatabase.instance
                    .ref('usuarios/${currentUser.uid}')
                    .onValue,
                builder: (context, snapshot) {
                  String nombre = currentUser.displayName?.isNotEmpty == true
                      ? currentUser.displayName!
                      : 'Usuario';
                  String email = currentUser.email ?? '';
                  String? photoUrl = currentUser.photoURL;

                  if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
                    final rawData = snapshot.data!.snapshot.value;
                    if (rawData is Map) {
                      final userData = Map<String, dynamic>.from(rawData);
                      if (userData['nombre'] != null &&
                          (userData['nombre'] as String).trim().isNotEmpty) {
                        nombre = userData['nombre'].toString().trim();
                      }
                      if (userData['photoUrl'] != null &&
                          (userData['photoUrl'] as String).isNotEmpty) {
                        photoUrl = userData['photoUrl'].toString();
                      }
                    }
                  }

                  ImageProvider? avatarImage;
                  if (photoUrl != null && photoUrl.isNotEmpty) {
                    if (photoUrl.startsWith('data:image')) {
                      try {
                        final base64Str = photoUrl.split(',').last;
                        avatarImage = MemoryImage(base64Decode(base64Str));
                      } catch (_) {}
                    } else {
                      avatarImage = NetworkImage(photoUrl);
                    }
                  }

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: 100,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.blueAccent, Color(0xFF1565C0)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -35,
                              left: 20,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  shape: BoxShape.circle,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 36,
                                  backgroundColor: Colors.blue.shade100,
                                  backgroundImage: avatarImage,
                                  child: avatarImage == null
                                      ? const Icon(Icons.person,
                                          size: 42, color: Colors.blueAccent)
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nombre,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      email,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: isDarkMode
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.blueAccent),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                icon: const Icon(Icons.edit,
                                    size: 16, color: Colors.blueAccent),
                                label: const Text(
                                  'Editar',
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () => context.push('/edit-profile'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                },
              ),

            // BANNER DE CUMPLEAÑOS
            if (currentUser != null)
              StreamBuilder<DatabaseEvent>(
                stream: FirebaseDatabase.instance
                    .ref('usuarios/${currentUser.uid}')
                    .onValue,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
                    return const SizedBox.shrink();
                  }

                  final rawData = snapshot.data!.snapshot.value;
                  if (rawData is! Map) return const SizedBox.shrink();

                  final userData = Map<String, dynamic>.from(rawData);
                  final fechaIsoStr = userData['fecha_nacimiento'] as String?;
                  final esCumple = _esCumpleanosHoy(fechaIsoStr);

                  if (!esCumple) return const SizedBox.shrink();

                  final String nombreBD =
                      (userData['nombre'] as String?)?.trim() ?? '';
                  final String nombre = nombreBD.isNotEmpty
                      ? nombreBD
                      : (currentUser.displayName?.trim().isNotEmpty == true
                          ? currentUser.displayName!
                          : 'Usuario');

                  return Card(
                    color: isDarkMode
                        ? const Color(0xFF3E2723)
                        : const Color(0xFFFFF8E1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Colors.amber, width: 2),
                    ),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Text('🎉', style: TextStyle(fontSize: 36)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '¡Feliz Cumpleaños, $nombre! 🎂',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? Colors.amber.shade200
                                        : Colors.amber.shade900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '¡Todo el equipo de Activelo te desea un excelente día de entrenamiento!',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDarkMode
                                        ? Colors.grey.shade300
                                        : Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Text(
                'PERFIL Y MODO DE USO',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Card(
              child: SwitchListTile(
                secondary: const Icon(Icons.badge_outlined, color: Colors.blue),
                title: const Text('Modo Profesional'),
                subtitle: const Text(
                  'Habilita la gestión de múltiples usuarios y notas de sesión.',
                ),
                value: esModoProfesional,
                activeThumbColor: Colors.blue,
                onChanged: (bool value) {
                  ref.read(modoProfesionalProvider.notifier).toggleModo(value);
                },
              ),
            ),
            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Text(
                'APARIENCIA Y TEMA',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: Icon(
                      isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: Colors.blue,
                    ),
                    title: const Text('Modo Oscuro'),
                    subtitle: const Text('Cambiar entre tema claro y oscuro'),
                    value: isDarkMode,
                    activeThumbColor: Colors.blue,
                    onChanged: (bool value) {
                      ref.read(themeProvider.notifier).toggleTheme(value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Text(
                'SONIDO Y RETROALIMENTACIÓN',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.volume_up, color: Colors.blue),
                    title: const Text('Efectos de Sonido'),
                    subtitle: const Text(
                        'Reproducir sonidos al iniciar y finalizar la rutina'),
                    value: sonidoHabilitado,
                    activeThumbColor: Colors.blue,
                    onChanged: (val) {
                      ref.read(soundEnabledProvider.notifier).state = val;
                    },
                  ),
                  if (sonidoHabilitado) ...[
                    const Divider(height: 1),
                    ListTile(
                      leading: IconButton(
                        icon: const Icon(Icons.play_circle_fill,
                            color: Colors.blue),
                        tooltip: 'Probar sonido',
                        onPressed: () {
                          ref.read(soundServiceProvider).playStart();
                        },
                      ),
                      title: const Text('Sonido de Inicio'),
                      subtitle: Text(_getNombreArchivo(
                        selectedStartPath,
                        'inicio.mp3',
                        soundLibrary,
                      )),
                      trailing: const Icon(Icons.folder_open, color: Colors.blue),
                      onTap: () {
                        _mostrarSelectorSonido(
                          context: context,
                          titulo: 'Seleccionar Sonido de Inicio',
                          defaultFileName: 'inicio.mp3',
                          currentPath: selectedStartPath,
                          onSelected: (path) {
                            ref
                                .read(selectedStartSoundProvider.notifier)
                                .setSelectedSound(path);
                          },
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: IconButton(
                        icon: const Icon(Icons.play_circle_fill,
                            color: Colors.blue),
                        tooltip: 'Probar sonido',
                        onPressed: () {
                          ref.read(soundServiceProvider).playFinish();
                        },
                      ),
                      title: const Text('Sonido de Fin'),
                      subtitle: Text(_getNombreArchivo(
                        selectedFinishPath,
                        'fin.mp3',
                        soundLibrary,
                      )),
                      trailing: const Icon(Icons.folder_open, color: Colors.blue),
                      onTap: () {
                        _mostrarSelectorSonido(
                          context: context,
                          titulo: 'Seleccionar Sonido de Fin',
                          defaultFileName: 'fin.mp3',
                          currentPath: selectedFinishPath,
                          onSelected: (path) {
                            ref
                                .read(selectedFinishSoundProvider.notifier)
                                .setSelectedSound(path);
                          },
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Text(
                'CUENTA Y PERFIL',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading:
                        const Icon(Icons.person_outline, color: Colors.blue),
                    title: const Text('Editar Perfil'),
                    subtitle: const Text('Actualiza tu información personal'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/edit-profile'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.bluetooth_searching,
                        color: Colors.blue),
                    title: const Text('Dispositivos Bluetooth'),
                    subtitle: const Text('Administrar conexiones y escaneo'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/bluetooth'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Text(
                'INFORMACIÓN',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Card(
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.info_outline, color: Colors.blue),
                    title: Text('Activelo LED Trainer'),
                    subtitle: Text('Versión 1.0.0'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined,
                        color: Colors.blue),
                    title: const Text('Términos y Privacidad'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/terminos-privacidad'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                label: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    context.go('/login');
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}