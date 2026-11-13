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
import '../utils/pdf_downloader.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String? _descargandoManual;

  static const Map<String, String> _idiomasSoportados = {
    'es': '🇦🇷 Español',
    'en': '🇺🇸 English',
    'pt': '🇧🇷 Português',
    'it': '🇮🇹 Italiano',
    'fr': '🇫🇷 Français',
    'de': '🇩🇪 Deutsch',
    'ar': '🇸🇦 العربية',
    'he': '🇮🇱 עברית',
    'ja': '🇯🇵 日本語',
    'zh': '🇨🇳 中文',
  };

  static const Map<String, Map<String, String>> _textosManuales = {
    'es': {
      'userTitle': 'Manual de Usuario',
      'userSub': 'Guía de uso y glosario (PDF)',
      'techTitle': 'Manual Técnico',
      'techSub': 'Arquitectura y especificaciones (PDF)',
      'ok': 'Manual descargado correctamente',
      'err':
          'No se pudo descargar el manual. Verificá que el PDF esté en assets/docs/.',
    },
    'en': {
      'userTitle': 'User Manual',
      'userSub': 'Usage guide & glossary (PDF)',
      'techTitle': 'Technical Manual',
      'techSub': 'Architecture & specifications (PDF)',
      'ok': 'Manual downloaded successfully',
      'err': 'Could not download manual. Make sure the PDF is in assets/docs/.',
    },
    'pt': {
      'userTitle': 'Manual do Usuário',
      'userSub': 'Guia de uso e glossário (PDF)',
      'techTitle': 'Manual Técnico',
      'techSub': 'Arquitetura e especificações (PDF)',
      'ok': 'Manual baixado com sucesso',
      'err': 'Não foi possível baixar o manual. Verifique assets/docs/.',
    },
    'it': {
      'userTitle': 'Manuale Utente',
      'userSub': 'Guida all’uso e glossario (PDF)',
      'techTitle': 'Manuale Tecnico',
      'techSub': 'Architettura e specifiche (PDF)',
      'ok': 'Manuale scaricato correttamente',
      'err': 'Impossibile scaricare il manuale. Controlla assets/docs/.',
    },
    'fr': {
      'userTitle': 'Manuel d’utilisation',
      'userSub': 'Guide d’utilisation et glossaire (PDF)',
      'techTitle': 'Manuel Technique',
      'techSub': 'Architecture et spécifications (PDF)',
      'ok': 'Manuel téléchargé avec succès',
      'err': 'Impossible de télécharger le manuel. Vérifiez assets/docs/.',
    },
    'de': {
      'userTitle': 'Benutzerhandbuch',
      'userSub': 'Bedienungsanleitung & Glossar (PDF)',
      'techTitle': 'Technisches Handbuch',
      'techSub': 'Architektur & Spezifikationen (PDF)',
      'ok': 'Handbuch erfolgreich heruntergeladen',
      'err':
          'Handbuch konnte nicht heruntergeladen werden. Prüfe assets/docs/.',
    },
    'ar': {
      'userTitle': 'دليل المستخدم',
      'userSub': 'دليل الاستخدام والمصطلحات (PDF)',
      'techTitle': 'الدليل التقني',
      'techSub': 'البنية والمواصفات التقنية (PDF)',
      'ok': 'تم تنزيل الدليل بنجاح',
      'err': 'تعذر تنزيل الدليل. تحقق من وجود الملف في assets/docs/.',
    },
    'he': {
      'userTitle': 'מדריך למשתמש',
      'userSub': 'מדריך שימוש ומילון מונחים (PDF)',
      'techTitle': 'מדריך טכני',
      'techSub': 'ארכיטקטורה ומפרט טכני (PDF)',
      'ok': 'המדריך הורד בהצלחה',
      'err': 'לא ניתן להוריד את המדריך. בדוק את תיקיית assets/docs/.',
    },
    'ja': {
      'userTitle': 'ユーザーマニュアル',
      'userSub': '操作ガイドと用語集 (PDF)',
      'techTitle': 'テクニカルマニュアル',
      'techSub': 'アーキテクチャと仕様書 (PDF)',
      'ok': 'マニュアルをダウンロードしました',
      'err': 'マニュアルをダウンロードできませんでした。assets/docs/ を確認してください。',
    },
    'zh': {
      'userTitle': '用户手册',
      'userSub': '使用指南与术语表 (PDF)',
      'techTitle': '技术手册',
      'techSub': '系统架构与技术规范 (PDF)',
      'ok': '手册下载成功',
      'err': '无法下载手册，请检查 assets/docs/ 目录。',
    },
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

  Future<void> _descargarManual({
    required String tipo,
    required String assetPath,
    required String fileName,
    required Map<String, String> textos,
  }) async {
    if (_descargandoManual != null) return;

    setState(() => _descargandoManual = tipo);

    try {
      await descargarYAbrirPdfAsset(
        assetPath: assetPath,
        fileName: fileName,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.green.shade700,
            duration: const Duration(seconds: 3),
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    textos['ok']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
    } catch (e) {
      debugPrint("Error descargando manual ($assetPath): $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.red.shade700,
            duration: const Duration(seconds: 4),
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    textos['err']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
    } finally {
      if (mounted) {
        setState(() => _descargandoManual = null);
      }
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

    final selectedLang =
        _idiomasSoportados.containsKey(currentLocale.languageCode)
            ? currentLocale.languageCode
            : 'es';
    final textosManuales =
        _textosManuales[selectedLang] ?? _textosManuales['es']!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.ajustes),
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

                  if (snapshot.hasData &&
                      snapshot.data?.snapshot.value != null) {
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
                                  colors: [
                                    Colors.blueAccent,
                                    Color(0xFF1565C0)
                                  ],
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
                                  side: const BorderSide(
                                      color: Colors.blueAccent),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                icon: const Icon(Icons.edit,
                                    size: 16, color: Colors.blueAccent),
                                label: Text(
                                  loc.editarPerfil,
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
                  if (!snapshot.hasData ||
                      snapshot.data?.snapshot.value == null) {
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
                                  loc.felizCumpleanos(nombre),
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
                                  loc.mensajeCumpleanos,
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
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Text(
                loc.perfilYModoDeUso,
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
                title: Text(loc.modoProfesional),
                subtitle: Text(loc.modoProfesionalDesc),
                value: esModoProfesional,
                activeThumbColor: Colors.blue,
                onChanged: (bool value) {
                  ref.read(modoProfesionalProvider.notifier).toggleModo(value);
                },
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Text(
                loc.aparienciaTema,
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
                    title: Text(loc.modoOscuro),
                    subtitle: Text(loc.cambiarTemaClaroOscuro),
                    value: isDarkMode,
                    activeThumbColor: Colors.blue,
                    onChanged: (bool value) {
                      ref.read(themeProvider.notifier).toggleTheme(value);
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading:
                        const Icon(Icons.language, color: Colors.blueAccent),
                    title: Text(loc.idioma),
                    subtitle:
                        Text(_idiomasSoportados[selectedLang] ?? '🇦🇷 Español'),
                    trailing: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedLang,
                        borderRadius: BorderRadius.circular(12),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                        ),
                        items: _idiomasSoportados.entries.map((entry) {
                          return DropdownMenuItem<String>(
                            value: entry.key,
                            child: Text(
                              entry.value,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          );
                        }).toList(),
                        onChanged: (langCode) {
                          if (langCode != null) {
                            ref
                                .read(localeProvider.notifier)
                                .cambiarIdioma(langCode);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Text(
                loc.sonidoRetroalimentacion,
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
                title: Text(loc.efectosSonido),
                subtitle: Text(loc.reproducirSonidosRutina),
                value: sonidoHabilitado,
                activeThumbColor: Colors.blue,
                onChanged: (val) {
                  ref.read(soundEnabledProvider.notifier).state = val;
                },
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Text(
                loc.cuentaPerfil,
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
                    title: Text(loc.editarPerfil),
                    subtitle: Text(loc.actualizaInformacionPersonal),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/edit-profile'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.bluetooth_searching,
                        color: Colors.blue),
                    title: Text(loc.dispositivosBluetooth),
                    subtitle: Text(loc.administrarConexiones),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/bluetooth'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Text(
                loc.informacion,
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
                    leading: const Icon(Icons.info_outline, color: Colors.blue),
                    title: Text(loc.appTitle),
                    subtitle: Text(loc.versionApp),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.menu_book_outlined,
                        color: Colors.blue),
                    title: Text(textosManuales['userTitle']!),
                    subtitle: Text(textosManuales['userSub']!),
                    trailing: _descargandoManual == 'usuario'
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.download_rounded,
                            color: Colors.blue),
                    onTap: () => _descargarManual(
                      tipo: 'usuario',
                      assetPath: 'assets/docs/manual_usuario.pdf',
                      fileName: 'Manual_de_Usuario_Activelo.pdf',
                      textos: textosManuales,
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.engineering_outlined,
                        color: Colors.blue),
                    title: Text(textosManuales['techTitle']!),
                    subtitle: Text(textosManuales['techSub']!),
                    trailing: _descargandoManual == 'tecnico'
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.download_rounded,
                            color: Colors.blue),
                    onTap: () => _descargarManual(
                      tipo: 'tecnico',
                      assetPath: 'assets/docs/manual_tecnico.pdf',
                      fileName: 'Manual_Tecnico_Activelo.pdf',
                      textos: textosManuales,
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined,
                        color: Colors.blue),
                    title: Text(loc.terminosYPrivacidad),
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
                  loc.cerrarSesion,
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