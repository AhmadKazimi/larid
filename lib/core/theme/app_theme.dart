import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0076F1);
  static const Color secondary = Color(0xFF3EAE30);
  static const Color accent = Color(0xFFFBCD00);
  
  // Derived colors
  static const Color primaryLight = Color(0xFF3391F3);
  static const Color primaryDark = Color(0xFF005BBE);
  static const Color secondaryLight = Color(0xFF5FC551);
  static const Color secondaryDark = Color(0xFF2E8222);
  
  // Additional colors
  static const Color background = Colors.white;
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFB00020);
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Colors.white;
  static const Color onAccent = Colors.black;
  static const Color onBackground = Colors.black;
  static const Color onSurface = Colors.black;
  static const Color onError = Colors.white;
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: false,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
        error: AppColors.error,
        surface: AppColors.surface,
        onPrimary: AppColors.onPrimary,
        onSecondary: AppColors.onSecondary,
        onError: AppColors.onError,
        onSurface: AppColors.onSurface,
      ),
      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle: const TextStyle(color: AppColors.primary),
      ),
      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
      ),
      // Scaffold background color
      scaffoldBackgroundColor: AppColors.background,
      // Text theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: AppColors.onBackground),
        headlineMedium: TextStyle(color: AppColors.onBackground),
        headlineSmall: TextStyle(color: AppColors.onBackground),
        titleLarge: TextStyle(color: AppColors.onBackground),
        titleMedium: TextStyle(color: AppColors.onBackground),
        titleSmall: TextStyle(color: AppColors.onBackground),
        bodyLarge: TextStyle(color: AppColors.onBackground),
        bodyMedium: TextStyle(color: AppColors.onBackground),
        bodySmall: TextStyle(color: AppColors.onBackground),
      ),
    );
  }
}
