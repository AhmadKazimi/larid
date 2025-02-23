import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF4A90E2);
  static const Color secondary = Color(0xFF3EAE30);
  static const Color accent = Color(0xFFFBCD00);
  
  // Gradient colors
  static const Color gradientStart = Color(0xFF4A90E2);
  static const Color gradientEnd = Color(0xFFE3F2FD);
  
  // Derived colors
  static const Color primaryLight = Color(0xFF64A5E8);
  static const Color primaryDark = Color(0xFF2F7FDB);
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


  static const Color textColor = Colors.black;
  static const Color textColorException = Colors.red;
}

class AppTheme {
  static ThemeData get lightTheme {
    final baseTheme = ThemeData(
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
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.notoKufiArabicTextTheme(baseTheme.textTheme),
      primaryTextTheme: GoogleFonts.notoKufiArabicTextTheme(baseTheme.primaryTextTheme),
      
      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.notoKufiArabic(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.notoKufiArabic(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        titleTextStyle: GoogleFonts.notoKufiArabic(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.onBackground,
        ),
        contentTextStyle: GoogleFonts.notoKufiArabic(
          fontSize: 16,
          color: AppColors.onBackground,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: GoogleFonts.notoKufiArabic(
          color: Colors.grey[700],
        ),
        errorStyle: GoogleFonts.notoKufiArabic(
          color: AppColors.error,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
      ),
      scaffoldBackgroundColor: AppColors.background,
    );
  }
}
