import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFFF851A),
        surface: Color(0xFF1E293B),
        error: Color(0xFFE74C3C),
        onPrimary: Colors.white,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF0A0F1A),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.lexend(fontSize: 50, fontWeight: FontWeight.w200, color: Colors.white),
        displayMedium: GoogleFonts.lexend(fontSize: 30, fontWeight: FontWeight.bold, color: const Color(0xFFF1F5F9)),
        titleLarge: GoogleFonts.lexend(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFFF1F5F9)),
        bodyLarge: GoogleFonts.lexend(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF64748B)),
        bodyMedium: GoogleFonts.lexend(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFFCBD5E1)),
        labelLarge: GoogleFonts.lexend(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFFFF851A)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E293B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFFF851A)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: GoogleFonts.lexend(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFFCBD5E1)),
        hintStyle: GoogleFonts.lexend(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF64748B)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF851A),
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.lexend(fontSize: 18, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 4,
        ),
      ),
    );
  }
}
