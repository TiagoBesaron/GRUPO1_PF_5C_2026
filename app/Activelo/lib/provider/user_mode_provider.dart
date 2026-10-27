import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModoProfesionalNotifier extends StateNotifier<bool> {
  ModoProfesionalNotifier() : super(false); // Por defecto en Modo Personal

  void toggleModo(bool valor) {
    state = valor;
  }
}

final modoProfesionalProvider =
    StateNotifierProvider<ModoProfesionalNotifier, bool>((ref) {
  return ModoProfesionalNotifier();
});