import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/login_screen.dart';
import '../../screens/register_screen.dart';
import '../../screens/main_wrapper_screen.dart';
import '../../screens/edit_profile_screen.dart';
import '../../screens/bluetooth_screen.dart';
import '../../screens/config_entrenamiento_screen.dart';
import '../../screens/entrenamiento_activo_screen.dart';
import '../../screens/tiempos_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text("Página no encontrada")),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("La pantalla solicitada no existe."),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/home'),
            child: const Text("Volver al Inicio"),
          ),
        ],
      ),
    ),
  ),
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) => '/home',
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainWrapperScreen(),
    ),
    GoRoute(
      path: '/tiempos',
      builder: (context, state) => const TiemposScreen(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/bluetooth',
      builder: (context, state) => const BluetoothScreen(),
    ),
    GoRoute(
      path: '/config-entrenamiento',
      builder: (context, state) => const ConfigEntrenamientoScreen(),
    ),
    GoRoute(
      path: '/entrenamiento-activo',
      builder: (context, state) {
        final config = state.extra;
        return EntrenamientoActivoScreen(config: config as dynamic);
      },
    ),
  ],
);