import 'package:go_router/go_router.dart';

// Importación de las pantallas que serán utilizadas como destinos
// dentro del sistema de navegación de la aplicación.
import '../../screens/login_screen.dart';
import '../../screens/register_screen.dart';
import '../../screens/settings_screen.dart';
import '../../screens/edit_profile_screen.dart';
import '../../screens/tiempos_screen.dart';
import '../../screens/main_screen.dart';
import '../../screens/bluetooth_screen.dart';


// Configuración centralizada de la navegación.
// GoRouter permite manejar las rutas de la aplicación y cambiar
// entre pantallas sin depender de Navigator manualmente.
final appRouter = GoRouter(

  // Primera pantalla que se muestra al iniciar la aplicación.
  // En este caso, el usuario comienza desde el inicio de sesión.
  initialLocation: '/login',


  routes: [


    // Pantalla de autenticación del usuario.
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),


    // Pantalla utilizada para crear una nueva cuenta.
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),


    // Pantalla principal de la aplicación.
    // Desde aquí el usuario accede a las funciones principales del LED Trainer.
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainScreen(),
    ),


    // Pantalla de configuración general de la aplicación.
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),


    // Pantalla donde el usuario puede modificar sus datos personales.
    GoRoute(
      path: '/editProfile',
      builder: (context, state) => const EditProfileScreen(),
    ),


    // Pantalla encargada de mostrar el historial de tiempos obtenidos durante los entrenamientos.
    GoRoute(
      path: '/tiempos',
      builder: (context, state) => const TiemposScreen(),
    ),


    // Pantalla encargada de la conexión Bluetooth con el ESP32.
    // Desde esta pantalla se realiza la búsqueda y conexión del dispositivo.
    GoRoute(
      path: '/bluetooth',
      builder: (context, state) => const BluetoothScreen(),
    ),

  ],
);