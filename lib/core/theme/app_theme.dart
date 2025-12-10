import 'package:flutter/material.dart';

class AppTheme {
  // 🎨 Brand Colors
  static const Color primary = Color(0xFF2EB872); // Green
  static const Color primarySoft = Color(0xFFEAF8F1);
  static const Color scaffoldBg = Color(0xFFF7F8FA);

  static const Color textPrimary = Color(0xFF1C1C1C);
  static const Color textSecondary = Color(0xFF8E8E93);

  static const Color border = Color(0xFFE5E5EA);
  static const Color cardBg = Colors.white;

  // 🌞 LIGHT THEME
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    scaffoldBackgroundColor: scaffoldBg,
    primaryColor: primary,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: primary,
      surface: scaffoldBg,
    ),

    // ✅ APP BAR
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: scaffoldBg,
      foregroundColor: textPrimary,
      centerTitle: false,
    ),

    // ✅ TEXT THEME
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(fontSize: 13, color: textSecondary),
    ),

    // ✅ CARD
    cardTheme: CardThemeData(
      elevation: 0,
      color: cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // ✅ INPUT (Search bar)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(color: textSecondary),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),

    // ✅ BUTTONS
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),

    // ✅ ICONS
    iconTheme: const IconThemeData(color: primary, size: 24),

    // ✅ BOTTOM NAVIGATION
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primary,
      unselectedItemColor: textSecondary,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );
}
