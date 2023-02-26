import 'package:flutter/material.dart';

final ThemeData darkData = ThemeData.dark();
final ThemeData lightData = ThemeData.dark();

class TodoTheme {
  static ThemeData get darkTheme {
    return darkData.copyWith(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        primaryContainer: const Color.fromARGB(255, 35, 34, 37),
        secondaryContainer: const Color.fromARGB(255, 21, 20, 27),
        background: const Color.fromARGB(255, 27, 26, 34),
      ),
      snackBarTheme: const SnackBarThemeData(
          backgroundColor: Color.fromARGB(255, 55, 55, 55)),
      iconTheme: darkData.iconTheme.copyWith(
        size: 20,
      ),
      brightness: Brightness.dark,
      dividerColor: Colors.white,
      cardColor: const Color.fromARGB(255, 40, 40, 40),
      unselectedWidgetColor: Colors.grey[200],
      scaffoldBackgroundColor: const Color.fromARGB(255, 25, 23, 32),
    );
  }

  static ThemeData get lightTheme {
    return lightData.copyWith(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        primaryContainer: const Color.fromARGB(255, 37, 36, 41),
        secondaryContainer: Colors.white,
        background: const Color.fromARGB(255, 245, 245, 245),
      ),
      snackBarTheme: const SnackBarThemeData(
          backgroundColor: Color.fromARGB(255, 225, 225, 225)),
      iconTheme: lightData.iconTheme.copyWith(
        size: 20,
      ),
      brightness: Brightness.light,
      dividerColor: Colors.white,
      cardColor: const Color.fromARGB(255, 40, 40, 40),
      unselectedWidgetColor: Colors.grey[200],
      scaffoldBackgroundColor: const Color.fromARGB(255, 25, 23, 32),
    );
  }
}
