import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'settings_screen.dart';
import 'tiempos_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int currentIndex = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    TiemposScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: screens[currentIndex],

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: currentIndex,

        onTap: (index) {

          setState(() {

            currentIndex = index;

          });

        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Inicio",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: "Tiempos",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Ajustes",
          ),

        ],

      ),

    );

  }

}