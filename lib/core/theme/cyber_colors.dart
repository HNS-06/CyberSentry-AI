import 'package:flutter/material.dart';

class CyberColors {
  // Primary Colors
  static const Color matrixGreen = Color(0xFF00FF41);
  static const Color neonGreen = Color(0xFF39FF14);
  static const Color cyberGreen = Color(0xFF00FF9D);
  static const Color terminalGreen = Color(0xFF00FF00);
  
  // Secondary Colors
  static const Color quantumBlue = Color(0xFF00D1FF);
  static const Color deepBlue = Color(0xFF0066FF);
  static const Color cyberPurple = Color(0xFF7700FF);
  static const Color neonPurple = Color(0xFFBC13FE);
  
  // Status Colors
  static const Color success = Color(0xFF00FF9D);
  static const Color warning = Color(0xFFFFD600);
  static const Color danger = Color(0xFFFF006E);
  static const Color info = Color(0xFF00D1FF);
  static const Color secure = Color(0xFF00FF41);
  
  // Background Colors
  static const Color backgroundDark = Color(0xFF0A0A0A);
  static const Color backgroundDarker = Color(0xFF050505);
  static const Color surfaceDark = Color(0xFF1A1A1A);
  static const Color surfaceLight = Color(0xFF2A2A2A);
  
  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFCCCCCC);
  static const Color textDisabled = Color(0xFF888888);
  static const Color textTerminal = Color(0xFF00FF00);
  
  // Gradient Presets
  static LinearGradient get cyberGradient => const LinearGradient(
    colors: [matrixGreen, quantumBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static LinearGradient get quantumGradient => const LinearGradient(
    colors: [quantumBlue, cyberPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static LinearGradient get matrixGradient => const LinearGradient(
    colors: [matrixGreen, terminalGreen],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static LinearGradient get threatGradient => const LinearGradient(
    colors: [danger, warning],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  
  // Glow Effects
  static List<BoxShadow> get cyberGlow => [
    BoxShadow(
      color: matrixGreen.withOpacity(0.5),
      blurRadius: 10,
      spreadRadius: 2,
    ),
    BoxShadow(
      color: matrixGreen.withOpacity(0.3),
      blurRadius: 20,
      spreadRadius: 5,
    ),
  ];
  
  static List<BoxShadow> get quantumGlow => [
    BoxShadow(
      color: quantumBlue.withOpacity(0.5),
      blurRadius: 10,
      spreadRadius: 2,
    ),
    BoxShadow(
      color: quantumBlue.withOpacity(0.3),
      blurRadius: 20,
      spreadRadius: 5,
    ),
  ];
  
  static List<BoxShadow> get threatGlow => [
    BoxShadow(
      color: danger.withOpacity(0.5),
      blurRadius: 10,
      spreadRadius: 2,
    ),
    BoxShadow(
      color: danger.withOpacity(0.3),
      blurRadius: 20,
      spreadRadius: 5,
    ),
  ];
  
  // Color Schemes
  static ColorScheme get darkColorScheme => const ColorScheme.dark(
    primary: matrixGreen,
    secondary: quantumBlue,
    surface: surfaceDark,
    background: backgroundDark,
    error: danger,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.white,
    onBackground: Colors.white,
    onError: Colors.white,
  );
}