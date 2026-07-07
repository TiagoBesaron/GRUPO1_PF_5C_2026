import 'package:flutter/material.dart';



// Clase encargada de centralizar el diseño visual
// de toda la aplicación.
// Permite mantener una apariencia uniforme entre pantallas
// evitando repetir configuraciones de estilos.
class AppTheme {



  // Tema claro principal utilizado por la aplicación.
  // Desde aquí se configuran:
  // - Colores generales.
  // - Barra superior.
  // - Botones.
  // - Tarjetas.
  // - Campos de entrada.
  static ThemeData get lightTheme {


    return ThemeData(



      // Utiliza Material Design 3 para aplicar
      // componentes y estilos modernos de Flutter.
      useMaterial3:true,


      // Define la paleta principal de colores
      // generada a partir del color azul.
      colorScheme:ColorScheme.fromSeed(

        seedColor:Colors.blue,

        brightness:Brightness.light,

      ),





      // Color de fondo general utilizado
      // en las pantallas de la aplicación.
      scaffoldBackgroundColor:
          const Color(0xfff4f7fb),





      // Configuración visual de las barras superiores.
      appBarTheme:const AppBarTheme(

        // Centra los títulos de las pantallas.
        centerTitle:true,


        // Elimina la sombra para obtener
        // un diseño más limpio.
        elevation:0,


        backgroundColor:Colors.blue,


        foregroundColor:Colors.white,

      ),





      // Estilo general para los botones elevados.
      // Define un tamaño y una forma uniforme
      // para las acciones principales de la aplicación.
      elevatedButtonTheme:ElevatedButtonThemeData(

        style:ElevatedButton.styleFrom(



          // Los botones ocupan todo el ancho disponible
          // y tienen una altura cómoda para interacción móvil.
          minimumSize:
              const Size(double.infinity,55),




          // Bordes redondeados para mantener
          // la estética general de la aplicación.
          shape:RoundedRectangleBorder(

            borderRadius:
                BorderRadius.circular(15),

          ),

        ),

      ),





      // Diseño general de las tarjetas utilizadas
      // para mostrar información como estadísticas,
      // estados Bluetooth o accesos rápidos.
      cardTheme:CardThemeData(


        // Sombra utilizada para separar visualmente
        // las tarjetas del fondo.
        elevation:3,



        shape:RoundedRectangleBorder(

          borderRadius:
              BorderRadius.circular(18),

        ),

      ),





      // Configuración visual de los campos de texto.
      // Se utiliza en pantallas como:
      // - Login.
      // - Registro.
      // - Edición de perfil.
      inputDecorationTheme:InputDecorationTheme(


        // Activa un fondo para diferenciar
        // los campos del resto de la pantalla.
        filled:true,


        fillColor:Colors.white,



        border:OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(15),

        ),

      ),



    );


  }


}