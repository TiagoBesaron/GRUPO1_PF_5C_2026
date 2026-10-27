import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider global para habilitar o deshabilitar el sonido
final soundEnabledProvider = StateProvider<bool>((ref) => true);

// Notifier para manejar el sonido personalizado de inicio (null = predeterminado)
final customStartSoundProvider =
    StateNotifierProvider<CustomSoundNotifier, String?>((ref) {
  return CustomSoundNotifier('custom_start_sound');
});

// Notifier para manejar el sonido personalizado de fin (null = predeterminado)
final customFinishSoundProvider =
    StateNotifierProvider<CustomSoundNotifier, String?>((ref) {
  return CustomSoundNotifier('custom_finish_sound');
});

class CustomSoundNotifier extends StateNotifier<String?> {
  final String prefKey;

  CustomSoundNotifier(this.prefKey) : super(null) {
    _cargarDePrefs();
  }

  Future<void> _cargarDePrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = prefs.getString(prefKey);
    } catch (e) {
      debugPrint("Error al cargar sonido guardado: $e");
    }
  }

  Future<void> setCustomSound(String? path) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (path == null) {
        await prefs.remove(prefKey);
      } else {
        await prefs.setString(prefKey, path);
      }
      state = path;
    } catch (e) {
      debugPrint("Error al guardar sonido personalizado: $e");
    }
  }
}

// Service provider para reproducciones de audio
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
        // Reproducir archivo local elegido por el usuario
        await player.play(
          DeviceFileSource(customFilePath),
          mode: PlayerMode.lowLatency,
        );
      } else {
        // Reproducir sonido predeterminado de assets
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
    final customPath = _ref.read(customStartSoundProvider);
    await _playSound('inicio.mp3', customPath);
  }

  Future<void> playFinish() async {
    final customPath = _ref.read(customFinishSoundProvider);
    await _playSound('fin.mp3', customPath);
  }
}