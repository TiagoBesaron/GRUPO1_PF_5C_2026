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
  final AudioPlayer _player = AudioPlayer();

  SoundService(this._ref);

  Future<void> _playSound(String assetPath) async {
    final isEnabled = _ref.read(soundEnabledProvider);
    if (!isEnabled) return;

    try {
      await _player.stop();
      await _player.play(AssetSource(assetPath));
    } catch (e) {
      debugPrint("Error al reproducir audio ($assetPath): $e");
    }
  }

  Future<void> playStart() async {
    await _playSound('sounds/inicio.mp3');
  }

  Future<void> playFinish() async {
    await _playSound('sounds/fin.mp3');
  }
}