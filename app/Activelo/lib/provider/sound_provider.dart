import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

// Control de Efectos de Sonido (On/Off)
final soundEnabledProvider = StateProvider<bool>((ref) => true);

// Servicio para Reproducción de Audio
final soundServiceProvider = Provider<SoundService>((ref) {
  final service = SoundService(ref);
  ref.onDispose(service.dispose);
  return service;
});

class SoundService {
  final Ref _ref;
  final AudioPlayer _player = AudioPlayer();
  DateTime? _ultimoPlay;
  String? _ultimoArchivo;

  SoundService(this._ref) {
    _player.setReleaseMode(ReleaseMode.stop);
  }

  Future<void> _playSound(String defaultFileName) async {
    final isEnabled = _ref.read(soundEnabledProvider);
    if (!isEnabled) return;

    final ahora = DateTime.now();
    if (_ultimoArchivo == defaultFileName &&
        _ultimoPlay != null &&
        ahora.difference(_ultimoPlay!).inMilliseconds < 600) {
      return;
    }
    _ultimoArchivo = defaultFileName;
    _ultimoPlay = ahora;

    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/$defaultFileName'));
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

  void dispose() {
    _player.dispose();
  }
}