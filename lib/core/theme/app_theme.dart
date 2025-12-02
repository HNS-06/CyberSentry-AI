import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme => ThemeData.dark().copyWith(
        primaryColor: Colors.tealAccent,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          foregroundColor: Colors.cyan,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1A1A1A),
          selectedItemColor: Colors.cyan,
          unselectedItemColor: Colors.grey,
          elevation: 8,
        ),
      );
}
