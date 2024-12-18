import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeConfig {
  static ThemeData get teslaTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: Color(0xFF2C2C2C),
        secondary: Color(0xFF4A4A4A),
        surface: Color(0xFF1E1E1E),
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: Color(0xFF121212),
      fontFamily: GoogleFonts.roboto().fontFamily,
      textTheme: _getTextTheme(),
      appBarTheme: _getAppBarTheme(),
      cardTheme: _getCardTheme(),
      elevatedButtonTheme: _getElevatedButtonTheme(),
      drawerTheme: _getDrawerTheme(),
      iconTheme: _getIconTheme(),
      inputDecorationTheme: _getInputDecorationTheme(),
      dividerTheme: _getDividerTheme(),
    );
  }

  static TextTheme _getTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.roboto(
          fontSize: 56, fontWeight: FontWeight.w300, letterSpacing: -1.5),
      displayMedium: GoogleFonts.roboto(
          fontSize: 45, fontWeight: FontWeight.w300, letterSpacing: -0.5),
      displaySmall: GoogleFonts.roboto(fontSize: 36, fontWeight: FontWeight.w400),
      headlineMedium: GoogleFonts.roboto(
          fontSize: 28, fontWeight: FontWeight.w400, letterSpacing: 0.25),
      headlineSmall:
          GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w400),
      titleLarge: GoogleFonts.roboto(
          fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
      titleMedium: GoogleFonts.roboto(
          fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
      titleSmall: GoogleFonts.roboto(
          fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
      bodyLarge: GoogleFonts.roboto(
          fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
      bodyMedium: GoogleFonts.roboto(
          fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
      labelLarge: GoogleFonts.roboto(
          fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
      bodySmall: GoogleFonts.roboto(
          fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
      labelSmall: GoogleFonts.roboto(
          fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
    ).apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    );
  }

  static AppBarTheme _getAppBarTheme() {
    return AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.roboto(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    );
  }

  static CardTheme _getCardTheme() {
    return CardTheme(
      color: Color(0xFF1E1E1E),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  static ElevatedButtonThemeData _getElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF2C2C2C),
        textStyle: GoogleFonts.roboto(
            fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
    );
  }

  static DrawerThemeData _getDrawerTheme() {
    return DrawerThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(0))),
    );
  }

  static IconThemeData _getIconTheme() {
    return IconThemeData(color: Colors.white, size: 24);
  }

  static InputDecorationTheme _getInputDecorationTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF2C2C2C),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: Colors.white70),
    );
  }

  static DividerThemeData _getDividerTheme() {
    return DividerThemeData(
      color: Color(0xFF2C2C2C),
      thickness: 1,
    );
  }
}