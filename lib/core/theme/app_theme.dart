// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
export 'app_colors.dart';
export 'app_radius.dart';
export 'app_spacing.dart';

// Configuração central do ThemeData no padrão Material 3 para Dark e Light Mode.
class AppTheme {
  static final ThemeData darkTheme = _buildTheme(
        brightness: Brightness.dark,
        colors: AppColorsExtension.dark,
      );

  static final ThemeData lightTheme = _buildTheme(
        brightness: Brightness.light,
        colors: AppColorsExtension.light,
      );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required AppColorsExtension colors,
  }) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.lexend().fontFamily,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      splashFactory: InkRipple.splashFactory,
      brightness: brightness,
      scaffoldBackgroundColor: colors.background,
      extensions: [colors],
      appBarTheme: AppBarTheme(
        backgroundColor: colors.headerBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: colors.textPrimary),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: colors.textPrimary,
        ),
      ),
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.primary,
        onPrimary: Colors.white,
        secondary: colors.primary,
        onSecondary: Colors.white,
        error: colors.error,
        onError: Colors.white,
        surface: colors.cardBackground,
        onSurface: colors.textPrimary,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: colors.textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: colors.textPrimary,
        ),
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: colors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: colors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: colors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: colors.textMuted,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: colors.textHint,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: colors.primary,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
          color: colors.textSecondary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.inputBackground,
        border: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: colors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: colors.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: colors.textMuted,
        ),
        hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: colors.textHint,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.lgRadius,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.lg,
            horizontal: AppSpacing.xxl,
          ),
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          side: BorderSide(color: colors.primaryBorder),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.lgRadius,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.xl,
          ),
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.xlRadius,
          side: BorderSide(color: colors.borderSubtle),
        ),
        margin: EdgeInsets.zero,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.cardBackground,
        elevation: isDark ? 8 : 4,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.xlRadius,
          side: BorderSide(color: colors.border),
        ),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: colors.textPrimary,
        ),
        contentTextStyle: TextStyle(
          fontSize: 14,
          color: colors.textMuted,
        ),
      ),
    );
  }
}
