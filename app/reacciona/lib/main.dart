import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/router/app_router.dart';



// Función principal de ejecución de Flutter.
// Es el primer código que se ejecuta al iniciar la aplicación.
void main() {


  // ProviderScope habilita Riverpod en toda la aplicación.
  // Permite que cualquier pantalla pueda acceder
  // a los providers globales, como el manejo Bluetooth
  // del ESP32.
  runApp(

    const ProviderScope(

      child: MyApp(),

    ),

  );


}






// Widget principal de la aplicación.
// Se utiliza ConsumerWidget porque necesita interactuar
// con Riverpod y permite que la aplicación pueda consumir
// estados globales si es necesario.
class MyApp extends ConsumerWidget {


  const MyApp({super.key});





  @override
  Widget build(BuildContext context, WidgetRef ref) {



    return MaterialApp.router(



      // Oculta la etiqueta de debug que aparece
      // en la esquina superior derecha.
      debugShowCheckedModeBanner:false,





      // Nombre identificador de la aplicación.
      title:'LED Trainer',





      // Configuración del sistema de navegación.
      // Utiliza GoRouter para administrar las rutas
      // entre pantallas como:
      // Login, Home, Bluetooth, Configuración, etc.
      routerConfig:appRouter,






      // Configuración general del diseño visual.
      // Define la apariencia base utilizada
      // por los componentes de Flutter.
      theme:ThemeData(



        // Genera la paleta principal de colores
        // utilizando azul como color base.
        colorScheme:ColorScheme.fromSeed(

          seedColor:Colors.blue,

        ),





        // Activa Material Design 3 para utilizar
        // componentes modernos de Flutter.
        useMaterial3:true,



      ),


    );


  }


}