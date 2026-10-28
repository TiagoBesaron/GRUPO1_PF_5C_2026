import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Modelo para los sonidos personalizados cargados por el usuario
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

// Habilitar / deshabilitar efectos de sonido
final soundEnabledProvider = StateProvider<bool>((ref) => true);

// Biblioteca de sonidos subidos por el usuario
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

  Future<SoundItem?> agregarSonido(String name, String path) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final newItem = SoundItem(id: path, name: name, path: path);

      // Evita duplicar el mismo archivo
      final exists = state.any((s) => s.path == path);
      if (!exists) {
        final newState = [...state, newItem];
        state = newState;
        final listJson = newState.map((item) => jsonEncode(item.toJson())).toList();
        await prefs.setStringList('custom_sounds_library', listJson);
      }
      return newItem;
    } catch (e) {
      debugPrint("Error al agregar sonido a la biblioteca: $e");
      return null;
    }
  }
}

// Selección de sonido de Inicio
final selectedStartSoundProvider =
    StateNotifierProvider<SelectedSoundNotifier, String?>((ref) {
  return SelectedSoundNotifier('selected_start_sound');
});

// Selección de sonido de Fin
final selectedFinishSoundProvider =
    StateNotifierProvider<SelectedSoundNotifier, String?>((ref) {
  return SelectedSoundNotifier('selected_finish_sound');
});

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

// Servicio para reproducción de audio
final soundServiceProvider = Provider<SoundService>((ref) {
  return SoundService(ref);
});

class SoundService {
  final Ref _ref;

  SoundService(this._ref);

  Future<void> _playSound(String defaultFileName, String? customFilePath) async {
    final isEnabled = _ref.read(soundEnabledProvider);
    if (!isEnabled) return;

    try {
      final player = AudioPlayer();

      player.onPlayerComplete.listen((_) {
        player.dispose();
      });

      if (customFilePath != null && customFilePath.isNotEmpty) {
        await player.play(
          DeviceFileSource(customFilePath),
          mode: PlayerMode.lowLatency,
        );
      } else {
        await player.play(
          AssetSource('sounds/$defaultFileName'),
          mode: PlayerMode.lowLatency,
        );
      }
    } catch (e) {
      debugPrint("Error al reproducir audio ($defaultFileName / $customFilePath): $e");
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