import 'package:flutter/material.dart';

class ThemeApp {
  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,

      colorScheme: const ColorScheme(
        brightness: Brightness.light,

        primary: Color.fromARGB(255, 131, 31, 156),
        onPrimary: Colors.black,

        secondary: Color.fromARGB(255, 255, 248, 200),
        onSecondary: Colors.black,

        error: Colors.red,
        onError: Colors.white,

        surface: Color.fromARGB(255, 248, 248, 248),
        onSurface: Color.fromARGB(
          255,
          0,
          0,
          0,
        ), //Color de letras en las pantallas
      ),

      scaffoldBackgroundColor: Color.fromARGB(255, 248, 248, 248),

      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 248, 248, 248),
        foregroundColor: Color.fromARGB(255, 0, 0, 0), //no usar
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,

      colorScheme: const ColorScheme(
        brightness: Brightness.dark,

        primary: Color.fromARGB(255, 165, 97, 221), // edita color de texto home
        onPrimary: Color.fromARGB(237, 252, 230, 59),
        secondary: Colors.black12,
        onSecondary: Colors.redAccent,
        error: Colors.red,
        onError: Colors.white,
        //surface: Color.fromARGB(167, 253, 253, 150), //color lista de categorias
        surface: Color.fromARGB(237, 252, 230, 59),
        onSurface: Color.fromARGB(
          255,
          255,
          255,
          255,
        ), //color de letras en la pantalla
      ),

      scaffoldBackgroundColor: Color.fromARGB(255, 0, 0, 0), //color de fondo

      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        foregroundColor: Color.fromARGB(255, 0, 0, 0),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color.fromARGB(255, 190, 190, 190),
      ),
    );
  }
}
