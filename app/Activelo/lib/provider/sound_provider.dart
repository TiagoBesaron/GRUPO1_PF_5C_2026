import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Modelo de Sonido Personalizado
class SoundItem {
  final String id;
  final String name;
  final String path;

  SoundItem({
    required this.id,
    required this.name,
    required this.path,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'path': path,
      };

  factory SoundItem.fromJson(Map<String, dynamic> json) => SoundItem(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        path: json['path'] ?? '',
      );
}

// Control de Efectos de Sonido (On/Off)
final soundEnabledProvider = StateProvider<bool>((ref) => true);

// Biblioteca de Sonidos Guardados por el Usuario
final customSoundsLibraryProvider =
    StateNotifierProvider<CustomSoundsLibraryNotifier, List<SoundItem>>((ref) {
  return CustomSoundsLibraryNotifier();
});

class CustomSoundsLibraryNotifier extends StateNotifier<List<SoundItem>> {
  CustomSoundsLibraryNotifier() : super([]) {
    _cargarBiblioteca();
  }

  Future<void> _cargarBiblioteca() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? savedList = prefs.getStringList('custom_sounds_library');
      if (savedList != null) {
        state = savedList
            .map((item) => SoundItem.fromJson(jsonDecode(item)))
            .toList();
      }
    } catch (e) {
      debugPrint("Error al cargar biblioteca de sonidos: $e");
    }
  }

  Future<SoundItem?> agregarSonido({
    required String name,
    String? path,
    Uint8List? bytes,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String finalPath = '';

      if (kIsWeb) {
        // En Web creamos un Data URI Base64 para reproducción inmediata
        if (bytes != null) {
          final base64Str = base64Encode(bytes);
          final ext = name.split('.').last.toLowerCase();
          final mime = ext == 'wav' ? 'audio/wav' : 'audio/mp3';
          finalPath = 'data:$mime;base64,$base64Str';
        } else if (path != null && path.startsWith('data:')) {
          finalPath = path;
        } else {
          return null;
        }
      } else {
        // En Android / iOS guardamos el archivo en disco local
        final appDocDir = await getApplicationDocumentsDirectory();
        final soundsFolder = Directory('${appDocDir.path}/custom_sounds');
        if (!await soundsFolder.exists()) {
          await soundsFolder.create(recursive: true);
        }

        final cleanName = name.replaceAll(RegExp(r'[^\w\.-]'), '_');
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_$cleanName';
        final destinationFile = File('${soundsFolder.path}/$fileName');

        if (path != null && path.isNotEmpty && await File(path).exists()) {
          await File(path).copy(destinationFile.path);
        } else if (bytes != null) {
          await destinationFile.writeAsBytes(bytes);
        } else {
          return null;
        }

        finalPath = destinationFile.path;
      }

      final newItem = SoundItem(id: finalPath, name: name, path: finalPath);

      final exists = state.any((s) => s.path == finalPath);
      if (!exists) {
        final newState = [...state, newItem];
        state = newState;
        final listJson = newState.map((item) => jsonEncode(item.toJson())).toList();
        await prefs.setStringList('custom_sounds_library', listJson);
      }
      return newItem;
    } catch (e) {
      debugPrint("Error guardando el archivo de audio: $e");
      return null;
    }
  }
}

// Selección de Sonido de Inicio
final selectedStartSoundProvider =
    StateNotifierProvider<SelectedSoundNotifier, String?>((ref) {
  return SelectedSoundNotifier('selected_start_sound');
});

// Selección de Sonido de Fin
final selectedFinishSoundProvider =
    StateNotifierProvider<SelectedSoundNotifier, String?>((ref) {
  return SelectedSoundNotifier('selected_finish_sound');
});

final customStartSoundProvider = selectedStartSoundProvider;
final customFinishSoundProvider = selectedFinishSoundProvider;

class SelectedSoundNotifier extends StateNotifier<String?> {
  final String prefKey;

  SelectedSoundNotifier(this.prefKey) : super(null) {
    _cargarDePrefs();
  }

  Future<void> _cargarDePrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = prefs.getString(prefKey);
    } catch (e) {
      debugPrint("Error al cargar preferencia de sonido: $e");
    }
  }

  Future<void> setSelectedSound(String? path) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (path == null) {
        await prefs.remove(prefKey);
      } else {
        await prefs.setString(prefKey, path);
      }
      state = path;
    } catch (e) {
      debugPrint("Error al guardar preferencia de sonido: $e");
    }
  }
}

// Servicio para Reproducción de Audio
final soundServiceProvider = Provider<SoundService>((ref) {
  return SoundService(ref);
});

class SoundService {
  final Ref _ref;
  AudioPlayer? _player;

  SoundService(this._ref);

  AudioPlayer _getAudioPlayer() {
    _player ??= AudioPlayer();
    return _player!;
  }

  Future<void> _playSound(String defaultFileName, String? customFilePath) async {
    final isEnabled = _ref.read(soundEnabledProvider);
    if (!isEnabled) return;

    final player = _getAudioPlayer();

    try {
      await player.stop();

      if (customFilePath != null && customFilePath.isNotEmpty) {
        if (customFilePath.startsWith('data:audio') || customFilePath.startsWith('http')) {
          // Reproducción en Web / Data URI
          await player.play(UrlSource(customFilePath));
          return;
        } else if (!kIsWeb) {
          // Reproducción en Android / Dispositivo Físico
          if (await File(customFilePath).exists()) {
            await player.play(DeviceFileSource(customFilePath));
            return;
          }
        }
      }

      await player.play(AssetSource('sounds/$defaultFileName'));
    } catch (e) {
      debugPrint("Error al reproducir audio personalizado ($customFilePath): $e");
      try {
        await player.play(AssetSource('sounds/$defaultFileName'));
      } catch (e2) {
        debugPrint("Error reproduciendo audio por defecto: $e2");
      }
    }
  }

  Future<void> playStart() async {
    final customPath = _ref.read(selectedStartSoundProvider);
    await _playSound('inicio.mp3', customPath);
  }

  Future<void> playFinish() async {
    final customPath = _ref.read(selectedFinishSoundProvider);
    await _playSound('fin.mp3', customPath);
  }

  Future<void> playPreview(String? path, String defaultFileName) async {
    await _playSound(defaultFileName, path);
  }
}