import 'package:flutter_riverpod/flutter_riverpod.dart';

class PerfilUsuario {
  final String id;
  final String nombre;
  final String notas;

  PerfilUsuario({
    required this.id,
    required this.nombre,
    this.notas = '',
  });
}

class PerfilNotifier extends StateNotifier<PerfilUsuario?> {
  PerfilNotifier() : super(null);

  void seleccionarPerfil(String id, String nombre, {String notas = ''}) {
    state = PerfilUsuario(id: id, nombre: nombre, notas: notas);
  }

  void deseleccionar() {
    state = null;
  }
}

final perfilActivoProvider =
    StateNotifierProvider<PerfilNotifier, PerfilUsuario?>((ref) {
  return PerfilNotifier();
});