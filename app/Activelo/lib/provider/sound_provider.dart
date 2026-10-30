import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

// Control de Efectos de Sonido (On/Off)
final soundEnabledProvider = StateProvider<bool>((ref) => true);

// Servicio para Reproducción de Audio
final soundServiceProvider = Provider<SoundService>((ref) {
  return SoundService(ref);
});

class SoundService {
  final Ref _ref;
  AudioPlayer? _player;

  SoundService(this._ref);

  Future<void> _playSound(String defaultFileName) async {
    final isEnabled = _ref.read(soundEnabledProvider);
    if (!isEnabled) return;

    try {
      final oldPlayer = _player;
      _player = null;
      if (oldPlayer != null) {
        try {
          await oldPlayer.stop();
          await oldPlayer.dispose();
        } catch (_) {}
      }

      final player = AudioPlayer();
      _player = player;

      await player.play(AssetSource('sounds/$defaultFileName'));
    } catch (e) {
      debugPrint("Error reproduciendo audio ($defaultFileName): $e");
    }
  }

  Future<void> playStart() async {
    await _playSound('inicio.mp3');
  }

  Future<void> playFinish() async {
    await _playSound('fin.mp3');
  }
}