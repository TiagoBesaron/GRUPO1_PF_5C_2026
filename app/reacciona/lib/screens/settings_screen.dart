import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../provider/theme_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _sonidoHabilitado = true;
  bool _vibracionHabilitada = true;
  bool _reconexionAutomatica = true;
  double _brilloLeds = 80;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

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
            // Sección Apariencia
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

            // Sección Audio y Retroalimentación
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
                    subtitle: const Text('Reproducir sonidos al presionar los pods'),
                    value: _sonidoHabilitado,
                    activeThumbColor: Colors.blue,
                    onChanged: (val) {
                      setState(() => _sonidoHabilitado = val);
                    },
                  ),
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

            // Sección Dispositivos y Pods
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Text(
                'CONFIGURACIÓN DE PODS',
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
                    secondary: const Icon(Icons.autorenew, color: Colors.blue),
                    title: const Text('Reconexión Automática'),
                    subtitle: const Text('Conectar automáticamente al pod conocido'),
                    value: _reconexionAutomatica,
                    activeThumbColor: Colors.blue,
                    onChanged: (val) {
                      setState(() => _reconexionAutomatica = val);
                    },
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.lightbulb_outline, color: Colors.blue),
                                SizedBox(width: 12),
                                Text(
                                  'Brillo Predeterminado LED',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Text(
                              '${_brilloLeds.round()}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: _brilloLeds,
                          min: 10,
                          max: 100,
                          divisions: 9,
                          label: '${_brilloLeds.round()}%',
                          activeColor: Colors.blue,
                          onChanged: (val) {
                            setState(() => _brilloLeds = val);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Sección Cuenta y Perfil
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

            // Sección Información
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
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Activelo - Sistema de entrenamiento táctil y cognitivo.')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Botón Cerrar Sesión
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