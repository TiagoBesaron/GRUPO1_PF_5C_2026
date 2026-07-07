import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'settings_screen.dart';
import 'tiempos_screen.dart';



// Pantalla principal de la aplicación.
//
// Contiene la navegación inferior entre las secciones
// más utilizadas del LED Trainer.
class MainScreen extends StatefulWidget {

  const MainScreen({super.key});


  @override
  State<MainScreen> createState() =>
      _MainScreenState();

}




class _MainScreenState extends State<MainScreen> {


  // Guarda la posición de la pantalla actualmente seleccionada
  // dentro de la barra de navegación inferior.
  int currentIndex = 0;



  // Lista de pantallas principales disponibles.
  // El índice de cada pantalla coincide con el índice
  // de su botón correspondiente en BottomNavigationBar.
  final List<Widget> screens = const [

    HomeScreen(),

    TiemposScreen(),

    SettingsScreen(),

  ];





  @override
  Widget build(BuildContext context) {


    return Scaffold(



      // Muestra la pantalla seleccionada actualmente.
      // Cuando el usuario cambia de sección,
      // este contenido se actualiza mediante currentIndex.
      body: screens[currentIndex],





      // Barra de navegación inferior que permite cambiar
      // entre las funciones principales de la aplicación.
      bottomNavigationBar: BottomNavigationBar(



        // Indica qué opción está seleccionada actualmente.
        currentIndex: currentIndex,



        // Se ejecuta cuando el usuario toca una opción.
        onTap: (index) {


          // Actualiza la pantalla mostrada modificando
          // el índice seleccionado.
          setState(() {


            currentIndex = index;


          });


        },



        items: const [



          // Acceso a la pantalla principal del entrenador LED.
          BottomNavigationBarItem(

            icon: Icon(Icons.home),

            label:"Inicio",

          ),




          // Acceso al historial y estadísticas de tiempos.
          BottomNavigationBarItem(

            icon: Icon(Icons.timer),

            label:"Tiempos",

          ),




          // Acceso a la configuración de la aplicación.
          BottomNavigationBarItem(

            icon: Icon(Icons.settings),

            label:"Ajustes",

          ),



        ],



      ),


    );


  }


}