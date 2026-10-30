import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../l10n/app_localizations.dart';

import '../provider/theme_provider.dart';
import '../provider/user_mode_provider.dart';
import '../provider/sound_provider.dart';
import '../provider/locale_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final Map<String, String> _idiomasSoportados = const {
    'es': 'Español',
    'en': 'English',
    'fr': 'Français',
    'it': 'Italiano',
    'de': 'Deutsch',
    'he': 'עברית (Hebreo)',
    'ar': 'العربية (Árabe)',
    'ja': '日本語 (Japonés)',
    'zh': '中文 (Chino)',
  };

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

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final esModoProfesional = ref.watch(modoProfesionalProvider);
    final sonidoHabilitado = ref.watch(soundEnabledProvider);
    final currentLocale = ref.watch(localeProvider);
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc?.ajustes ?? 'Ajustes y Configuración'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                                label: Text(
                                  loc?.editarPerfil ?? 'Editar',
                                  style: const TextStyle(
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

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Text(
                loc?.cuentaPerfil ?? 'PERFIL Y MODO DE USO',
                style: const TextStyle(
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
                title: Text(loc?.modoProfesional ?? 'Modo Profesional'),
                subtitle: Text(
                  loc?.modoProfesionalDesc ??
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

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Text(
                loc?.aparienciaTema ?? 'APARIENCIA Y TEMA',
                style: const TextStyle(
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
                    title: Text(loc?.modoOscuro ?? 'Modo Oscuro'),
                    subtitle: const Text('Cambiar entre tema claro y oscuro'),
                    value: isDarkMode,
                    activeThumbColor: Colors.blue,
                    onChanged: (bool value) {
                      ref.read(themeProvider.notifier).toggleTheme(value);
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.language, color: Colors.blueAccent),
                    title: Text(loc?.idioma ?? 'Idioma'),
                    subtitle: Text(_idiomasSoportados[currentLocale.languageCode] ?? 'Español'),
                    trailing: DropdownButton<String>(
                      value: currentLocale.languageCode,
                      underline: const SizedBox(),
                      items: _idiomasSoportados.entries.map((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                      onChanged: (langCode) {
                        if (langCode != null) {
                          ref.read(localeProvider.notifier).cambiarIdioma(langCode);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Text(
                loc?.sonidoRetroalimentacion ?? 'SONIDO Y RETROALIMENTACIÓN',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Card(
              child: SwitchListTile(
                secondary: const Icon(Icons.volume_up, color: Colors.blue),
                title: Text(loc?.efectosSonido ?? 'Efectos de Sonido'),
                subtitle: const Text(
                    'Reproducir sonidos al iniciar y finalizar la rutina'),
                value: sonidoHabilitado,
                activeThumbColor: Colors.blue,
                onChanged: (val) {
                  ref.read(soundEnabledProvider.notifier).state = val;
                },
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Text(
                loc?.cuentaPerfil ?? 'CUENTA Y PERFIL',
                style: const TextStyle(
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
                    title: Text(loc?.editarPerfil ?? 'Editar Perfil'),
                    subtitle: const Text('Actualiza tu información personal'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/edit-profile'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.bluetooth_searching,
                        color: Colors.blue),
                    title: Text(loc?.dispositivosBluetooth ?? 'Dispositivos Bluetooth'),
                    subtitle: const Text('Administrar conexiones y escaneo'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/bluetooth'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Text(
                loc?.informacion ?? 'INFORMACIÓN',
                style: const TextStyle(
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
                    title: Text(loc?.terminosPrivacidad ?? 'Términos y Privacidad'),
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
                label: Text(
                  loc?.cerrarSesion ?? 'Cerrar Sesión',
                  style: const TextStyle(
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