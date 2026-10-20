import 'package:flutter_riverpod/flutter_riverpod.dart';

class PerfilAtleta {
  final String id;
  final String nombre;
  final String notas;

  PerfilAtleta({
    required this.id,
    required this.nombre,
    this.notas = '',
  });
}

class PerfilNotifier extends StateNotifier<PerfilAtleta?> {
  PerfilNotifier() : super(null);

  void seleccionarPerfil(String id, String nombre, {String notas = ''}) {
    state = PerfilAtleta(id: id, nombre: nombre, notas: notas);
  }

  void deseleccionar() {
    state = null;
  }
}

final perfilActivoProvider =
    StateNotifierProvider<PerfilNotifier, PerfilAtleta?>((ref) {
  return PerfilNotifier();
});