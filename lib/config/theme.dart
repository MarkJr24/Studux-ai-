import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const primary = Color(0xFF673AB7);        // Deep Purple
  static const primaryLight = Color(0xFF8B5CF6);   // Purple-500
  static const secondary = Color(0xFF3B82F6);      // Blue-500
  
  // Dark Theme Background
  static const darkIndigo = Color(0xFF1E1B4B);     // indigo-950
  static const darkPurple = Color(0xFF581C87);     // purple-900
  static const darkBlue = Color(0xFF1E3A8A);       // blue-950
  
  // Accent Colors
  static const accentCyan = Color(0xFF06B6D4);     // cyan-500
  static const accentPink = Color(0xFFEC4899);     // pink-500
  
  // Glass Effects
  static Color white5 = Colors.white.withOpacity(0.05);
  static Color white10 = Colors.white.withOpacity(0.1);
  static Color white20 = Colors.white.withOpacity(0.2);
  static Color white30 = Colors.white.withOpacity(0.3);
  static Color white50 = Colors.white.withOpacity(0.5);
  static Color white60 = Colors.white.withOpacity(0.6);
  static Color white70 = Colors.white.withOpacity(0.7);
  static Color white80 = Colors.white.withOpacity(0.8);
  
  // Light Theme
  static const lightBackground = Color(0xFFFFFFFF);
  static const lightSurface = Color(0xFFF5F5F5);
  static const textPrimary = Color(0xFF212121);
  static const textSecondary = Color(0xFF757575);
  static const border = Color(0xFFE0E0E0);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );
  
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkIndigo, darkPurple],
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [accentCyan, accentPink],
  );
}

class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.lightSurface,
      error: Colors.red,
    ),
  );
  
  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkIndigo,
    scaffoldBackgroundColor: AppColors.darkIndigo,
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.darkPurple,
      error: Colors.redAccent,
    ),
  );
}
