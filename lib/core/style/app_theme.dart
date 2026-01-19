import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData getTheme(bool isDark) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,

        primary: isDark ? AppColors.primaryDark : AppColors.primaryLight,
        onPrimary: Colors.white,

        secondary: isDark ? AppColors.secondaryDark : AppColors.secondaryLight,
        onSecondary: Colors.white,

        surface: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        onSurface: isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
        // Error
        error: Colors.red,
        onError: Colors.white,
      ),

      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: isDark
            ? AppColors.primaryDark
            : AppColors.primaryLight,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
}
