import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../provider/theme_provider.dart';
import '../provider/user_mode_provider.dart';
import '../provider/sound_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _vibracionHabilitada = true;

  String _getNombreArchivo(String? path) {
    if (path == null || path.isEmpty) return 'Predeterminado (inicio.mp3)';
    if (path.contains('/')) return path.split('/').last;
    if (path.contains('\\')) return path.split('\\').last;
    return path;
  }

  Future<void> _seleccionarAudioInicio() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final String? pathElegido = file.path ?? (kIsWeb ? file.name : null);

        if (pathElegido != null) {
          await ref.read(customStartSoundProvider.notifier).setCustomSound(pathElegido);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Sonido de inicio guardado: ${file.name}'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error seleccionando archivo de audio: $e');
    }
  }

  Future<void> _seleccionarAudioFin() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final String? pathElegido = file.path ?? (kIsWeb ? file.name : null);

        if (pathElegido != null) {
          await ref.read(customFinishSoundProvider.notifier).setCustomSound(pathElegido);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Sonido de fin guardado: ${file.name}'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error seleccionando archivo de audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final esModoProfesional = ref.watch(modoProfesionalProvider);
    final sonidoHabilitado = ref.watch(soundEnabledProvider);
    final customStartPath = ref.watch(customStartSoundProvider);
    final customFinishPath = ref.watch(customFinishSoundProvider);

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
                    subtitle: const Text('Reproducir sonidos al iniciar y finalizar la rutina'),
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
                        icon: const Icon(Icons.play_circle_fill, color: Colors.blue),
                        tooltip: 'Probar sonido',
                        onPressed: () {
                          ref.read(soundServiceProvider).playStart();
                        },
                      ),
                      title: const Text('Sonido de Inicio'),
                      subtitle: Text(_getNombreArchivo(customStartPath)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (customStartPath != null)
                            IconButton(
                              icon: const Icon(Icons.restore, color: Colors.orangeAccent),
                              tooltip: 'Restablecer predeterminado',
                              onPressed: () {
                                ref
                                    .read(customStartSoundProvider.notifier)
                                    .setCustomSound(null);
                              },
                            ),
                          IconButton(
                            icon: const Icon(Icons.folder_open, color: Colors.blue),
                            tooltip: 'Elegir archivo',
                            onPressed: _seleccionarAudioInicio,
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: IconButton(
                        icon: const Icon(Icons.play_circle_fill, color: Colors.blue),
                        tooltip: 'Probar sonido',
                        onPressed: () {
                          ref.read(soundServiceProvider).playFinish();
                        },
                      ),
                      title: const Text('Sonido de Fin'),
                      subtitle: Text(_getNombreArchivo(customFinishPath)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (customFinishPath != null)
                            IconButton(
                              icon: const Icon(Icons.restore, color: Colors.orangeAccent),
                              tooltip: 'Restablecer predeterminado',
                              onPressed: () {
                                ref
                                    .read(customFinishSoundProvider.notifier)
                                    .setCustomSound(null);
                              },
                            ),
                          IconButton(
                            icon: const Icon(Icons.folder_open, color: Colors.blue),
                            tooltip: 'Elegir archivo',
                            onPressed: _seleccionarAudioFin,
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Divider(height: 1),
                  SwitchListTile(
                    secondary: const Icon(Icons.vibration, color: Colors.blue),
                    title: const Text('Vibración Háptica'),
                    subtitle: const Text('Vibración en el teléfono al registrar toques'),
                    value: _vibracionHabilitada,
                    activeThumbColor: Colors.blue,
                    onChanged: (val) {
                      setState(() => _vibracionHabilitada = val);
                    },
                  ),
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
                    leading: const Icon(Icons.person_outline, color: Colors.blue),
                    title: const Text('Editar Perfil'),
                    subtitle: const Text('Actualiza tu información personal'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/edit-profile'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.bluetooth_searching, color: Colors.blue),
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
                    leading: const Icon(Icons.privacy_tip_outlined, color: Colors.blue),
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