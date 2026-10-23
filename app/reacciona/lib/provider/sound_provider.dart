import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

// Provider global para habilitar o deshabilitar el sonido
final soundEnabledProvider = StateProvider<bool>((ref) => true);

// Service provider para reproducciones de audio
final soundServiceProvider = Provider<SoundService>((ref) {
  return SoundService(ref);
});

class SoundService {
  final Ref _ref;

  SoundService(this._ref);

  Future<void> _playSound(String fileName) async {
    final isEnabled = _ref.read(soundEnabledProvider);
    if (!isEnabled) return;

    try {
      final player = AudioPlayer();

      // Liberar recursos automáticamente cuando termina de sonar
      player.onPlayerComplete.listen((_) {
        player.dispose();
      });

      // AssetSource busca dentro del directorio assets/ configurado en pubspec.yaml
      await player.play(
        AssetSource('sounds/$fileName'),
        mode: PlayerMode.lowLatency,
      );
    } catch (e) {
      debugPrint("Error al reproducir audio ($fileName): $e");
    }
  }

  Future<void> playStart() async {
    await _playSound('inicio.mp3');
  }

  Future<void> playFinish() async {
    await _playSound('fin.mp3');
  }
}