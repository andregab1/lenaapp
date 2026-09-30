import 'package:flutter/material.dart';

/// Spotify-inspired color palette. Kept as named constants so every
/// screen pulls from the same source instead of hardcoding hex values.
class AppColors {
  AppColors._();

  static const bg = Color(0xFF000000);
  static const surface = Color(0xFF121212);
  static const card = Color(0xFF181818);
  static const cardHover = Color(0xFF282828);
  static const green = Color(0xFF1ED760);
  static const pink = Color(0xFFFF6FB0);
  static const text = Color(0xFFFFFFFF);
  static const textDim = Color(0xFFA7A7A7);
  static const textFaint = Color(0xFF727272);

  static const heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF5B2A86), Color(0xFFC2185B), Color(0xFFFF6FB0)],
  );
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.green,
      brightness: Brightness.dark,
      surface: AppColors.surface,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.text),
    ),
  );
}
