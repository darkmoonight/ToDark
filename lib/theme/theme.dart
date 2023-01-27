import 'package:flutter/material.dart';

final ThemeData themeData = ThemeData.dark();

class TodoTheme {
  static ThemeData get baseTheme {
    return themeData.copyWith(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        primaryContainer: const Color.fromARGB(255, 37, 36, 41),
      ),
      iconTheme: themeData.iconTheme.copyWith(
        size: 20,
      ),
      brightness: Brightness.dark,
      dividerColor: Colors.white,
      cardColor: const Color.fromARGB(255, 40, 40, 40),
      unselectedWidgetColor: Colors.grey[200],
      scaffoldBackgroundColor: const Color(0xff191720),
    );
  }
}
