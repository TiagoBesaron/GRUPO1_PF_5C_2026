import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';
import 'provider/theme_provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_wrapper_screen.dart';
import 'screens/bluetooth_screen.dart';
import 'screens/config_entrenamiento_screen.dart';
import 'screens/entrenamiento_activo_screen.dart';
import 'screens/tiempos_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización de Firebase con opciones para Web (Chrome) y plataformas nativas
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Persistencia offline con manejo de excepciones para evitar bloqueos
  try {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
  } catch (e) {
    debugPrint('Nota sobre persistencia Firebase: $e');
  }

  runApp(const ProviderScope(child: ActiveloApp()));
}

// Permite a GoRouter reaccionar cuando cambia la sesión de Firebase Auth
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

final _router = GoRouter(
  initialLocation: '/',
  refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isLoggingIn =
        state.matchedLocation == '/login' || state.matchedLocation == '/register';

    // Si no está logueado y quiere acceder a una ruta privada -> va al login
    if (user == null && !isLoggingIn) {
      return '/login';
    }

    // Si ya está logueado e intenta ir al login/registro -> va a la pantalla principal
    if (user != null && isLoggingIn) {
      return '/';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
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
      path: '/tiempos',
      builder: (context, state) => const TiemposScreen(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

class ActiveloApp extends ConsumerWidget {
  const ActiveloApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    const primaryBlue = Colors.blue;

    final lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.light,
        primary: primaryBlue,
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: primaryBlue.withValues(alpha: 0.2),
      ),
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.dark,
        primary: primaryBlue,
        surface: const Color(0xFF1E1E1E),
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        indicatorColor: primaryBlue.withValues(alpha: 0.4),
      ),
    );

    return MaterialApp.router(
      title: 'Activelo',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: _router,
    );
  }
}