import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../screens/login_screen.dart';
import '../../screens/register_screen.dart';
import '../../screens/main_wrapper_screen.dart';
import '../../screens/edit_profile_screen.dart';
import '../../screens/bluetooth_screen.dart';
import '../../screens/config_entrenamiento_screen.dart';
import '../../screens/entrenamiento_activo_screen.dart';
import '../../screens/tiempos_screen.dart';
import '../../screens/settings_screen.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

// Se define como Provider para inicializarse SOLAMENTE cuando Firebase ya cargó
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final isLoggingIn =
          state.matchedLocation == '/login' || state.matchedLocation == '/register';

      if (user == null && !isLoggingIn) {
        return '/login';
      }

      if (user != null && isLoggingIn) {
        return '/home';
      }

      return null;
    },
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
        path: '/home',
        builder: (context, state) => const MainWrapperScreen(),
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
          final config = state.extra as Map<String, dynamic>? ?? {};
          return EntrenamientoActivoScreen(config: config);
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});