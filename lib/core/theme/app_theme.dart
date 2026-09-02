import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Paleta de cores centralizada extraída rigorosamente do Design System do Figma.
class AppColors {
  // Fundos & Superfícies (Dark Mode Profundo - Slate / Carbono)
  static const Color background = Color(0xFF0A0F1A);
  static const Color backgroundAlt = Color(0xFF0C1326);
  static const Color headerBackground = Color(0xFF0A0F1A);
  static const Color cardBackground = Color(0xFF0F172A);
  static const Color cardBackgroundAlt = Color(0xFF0C1326);
  static const Color surfaceOverlay = Color(0xFF1E293B);
  static const Color inputBackground = Color(0xFF1E293B);

  // Ações Principais & Destaques de Marca
  static const Color primary = Color(0xFFFF851A); // Laranja Rodoviário
  static const Color primaryMuted = Color(0x33FF851A); // 20% opacidade
  static const Color primaryLight = Color(0x1AFF851A); // 10% opacidade
  static const Color primaryBorder = Color(0x4DFF851A); // 30% opacidade

  // Status & Alertas
  static const Color success = Color(0xFF22C55E); // Verde Sincronizado / Online
  static const Color successMuted = Color(0x3322C55E);
  static const Color warning = Color(0xFFFFBF00); // Âmbar de Alta Visibilidade
  static const Color warningDark = Color(0xFFF59E0B);
  static const Color warningMuted = Color(0x33FFBF00);
  static const Color error = Color(0xFFEF4444); // Vermelho
  static const Color errorMuted = Color(0x33EF4444);

  // Textos & Contraste
  static const Color textPrimary = Color(0xFFFFFFFF); // Branco
  static const Color textSecondary = Color(0xFFCBD5E1); // Rótulos e legendas
  static const Color textMuted = Color(0xFF94A3B8); // Textos secundários
  static const Color textHint = Color(0xFF64748B); // Placeholders e ícones inativos
  static const Color textDark = Color(0xFF000000); // Texto escuro para contrastar no banner âmbar

  // Bordas & Divisores
  static const Color border = Color(0xFF334155);
  static const Color borderSubtle = Color(0x1AFFFFFF);
  static const Color deepNavy = Color(0xFF001F3F);
}

/// Escala padronizada de raios de borda (Border Radius) do Figma.
class AppRadius {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double pill = 9999.0;

  static BorderRadius get xsRadius => BorderRadius.circular(xs);
  static BorderRadius get smRadius => BorderRadius.circular(sm);
  static BorderRadius get mdRadius => BorderRadius.circular(md);
  static BorderRadius get lgRadius => BorderRadius.circular(lg);
  static BorderRadius get xlRadius => BorderRadius.circular(xl);
  static BorderRadius get xxlRadius => BorderRadius.circular(xxl);
  static BorderRadius get pillRadius => BorderRadius.circular(pill);
}

/// Escala padronizada de espaçamentos (Padding / Margin / Gap) do Figma.
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double huge = 32.0;
  static const double massive = 40.0;
}

/// Configuração central do ThemeData no padrão Material 3 para Dark Mode.
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.headerBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: GoogleFonts.lexend(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        surface: AppColors.cardBackground,
        error: AppColors.error,
        onPrimary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.lexend(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displayMedium: GoogleFonts.lexend(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        headlineLarge: GoogleFonts.lexend(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.lexend(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        titleLarge: GoogleFonts.lexend(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: GoogleFonts.lexend(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.lexend(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.lexend(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.textMuted,
        ),
        bodySmall: GoogleFonts.lexend(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: AppColors.textHint,
        ),
        labelLarge: GoogleFonts.lexend(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
        labelSmall: GoogleFonts.lexend(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
          color: AppColors.textSecondary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBackground,
        border: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        labelStyle: GoogleFonts.lexend(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textMuted,
        ),
        hintStyle: GoogleFonts.lexend(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.textHint,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          textStyle: GoogleFonts.lexend(
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
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primaryBorder),
          textStyle: GoogleFonts.lexend(
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
          foregroundColor: AppColors.primary,
          textStyle: GoogleFonts.lexend(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.xlRadius,
          side: const BorderSide(color: AppColors.borderSubtle),
        ),
        margin: EdgeInsets.zero,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.headerBackground,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.xlRadius,
          side: const BorderSide(color: AppColors.border),
        ),
        titleTextStyle: GoogleFonts.lexend(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        contentTextStyle: GoogleFonts.lexend(
          fontSize: 14,
          color: AppColors.textMuted,
        ),
      ),
    );
  }
}
