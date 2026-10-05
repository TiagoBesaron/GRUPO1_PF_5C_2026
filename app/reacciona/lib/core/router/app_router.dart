import 'package:go_router/go_router.dart';
import '../../screens/login_screen.dart';
import '../../screens/register_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/bluetooth_screen.dart';
import '../../screens/config_entrenamiento_screen.dart';
import '../../screens/entrenamiento_activo_screen.dart';
import '../../screens/tiempos_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
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
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/bluetooth',
      builder: (context, state) => const BluetoothScreen(),
    ),
    GoRoute(
      path: '/config_entrenamiento',
      builder: (context, state) => const ConfigEntrenamientoScreen(),
    ),
    GoRoute(
      path: '/entrenamiento_activo',
      builder: (context, state) {
        final config = state.extra as Map<String, dynamic>;
        return EntrenamientoActivoScreen(config: config);
      },
    ),
    GoRoute(
      path: '/tiempos',
      builder: (context, state) => const TiemposScreen(),
    ),
  ],
);