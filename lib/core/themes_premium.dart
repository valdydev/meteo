import 'package:flutter/material.dart';

class CouleursElite {
  // Palette Inspirée d'Apple Vision Pro & Tesla
  static const Color fondNoirPur = Color(0xFF000000);
  static const Color grisSideral = Color(0xFF1C1C1E);
  static const Color bleuElectrique = Color(0xFF0A84FF);
  static const Color cyanVision = Color(0xFF32ADE6);
  static const Color blancTranslucide = Color(0x1AFFFFFF);
  static const Color bordureVerre = Color(0x33FFFFFF);
  
  static const LinearGradient gradientVision = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2C2C2E),
      Color(0xFF1C1C1E),
    ],
  );

  static const List<Color> meshColors = [
    Color(0xFF000000),
    Color(0xFF0A0E21),
    Color(0xFF1C1C1E),
    Color(0xFF003366),
  ];
}

class ThemesElite {
  static ThemeData themeElite3D = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: CouleursElite.fondNoirPur,
    colorScheme: ColorScheme.fromSeed(
      seedColor: CouleursElite.bleuElectrique,
      brightness: Brightness.dark,
      primary: CouleursElite.bleuElectrique,
      surface: CouleursElite.grisSideral,
    ),
    fontFamily: 'SF Pro Display', // On simule la police Apple
    cardTheme: CardThemeData(
      color: CouleursElite.blancTranslucide,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: const BorderSide(color: CouleursElite.bordureVerre, width: 0.5),
      ),
    ),
  );
}
