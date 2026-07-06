import 'package:go_router/go_router.dart';
import '../../screens/login_screen.dart';
import '../../screens/register_screen.dart';
import '../../screens/settings_screen.dart';
import '../../screens/edit_profile_screen.dart';
import '../../screens/tiempos_screen.dart';
import '../../screens/main_screen.dart';

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
      builder: (context, state) => const MainScreen(),
    ),

    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),

    GoRoute(
      path: '/editProfile',
      builder: (context, state) => const EditProfileScreen(),
    ),

    GoRoute(
      path: '/tiempos',
      builder: (context, state) => const TiemposScreen(),
    ),

  ],
);

