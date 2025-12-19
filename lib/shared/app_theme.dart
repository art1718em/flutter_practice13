import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white70,
        backgroundColor: Color(0xFF1E1E1E),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

