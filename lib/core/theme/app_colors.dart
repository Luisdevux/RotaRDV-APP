import 'package:flutter/material.dart';

/// Extensão de cores personalizada do RotaRDV para suporte nativo a Tema Claro e Escuro.
/// Use sempre `context.colors.<nome_da_cor>` nos widgets.
@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.background,
    required this.backgroundAlt,
    required this.headerBackground,
    required this.cardBackground,
    required this.cardBackgroundAlt,
    required this.surfaceOverlay,
    required this.inputBackground,
    required this.primary,
    required this.primaryMuted,
    required this.primaryLight,
    required this.primaryFaint,
    required this.primaryBorder,
    required this.success,
    required this.successMuted,
    required this.warning,
    required this.warningDark,
    required this.warningMuted,
    required this.error,
    required this.errorMuted,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textHint,
    required this.textDark,
    required this.border,
    required this.borderSubtle,
    required this.deepNavy,
  });

  final Color background;
  final Color backgroundAlt;
  final Color headerBackground;
  final Color cardBackground;
  final Color cardBackgroundAlt;
  final Color surfaceOverlay;
  final Color inputBackground;
  final Color primary;
  final Color primaryMuted;
  final Color primaryLight;
  final Color primaryFaint;
  final Color primaryBorder;
  final Color success;
  final Color successMuted;
  final Color warning;
  final Color warningDark;
  final Color warningMuted;
  final Color error;
  final Color errorMuted;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textHint;
  final Color textDark;
  final Color border;
  final Color borderSubtle;
  final Color deepNavy;

  // ═══════════════════ DARK THEME (Tema Escuro Profundo) ═══════════════════
  static const dark = AppColorsExtension(
    background: Color(0xFF0A0F1A),
    backgroundAlt: Color(0xFF0C1326),
    headerBackground: Color(0xFF0A0F1A),
    cardBackground: Color(0xFF0F172A),
    cardBackgroundAlt: Color(0xFF0D121F),
    surfaceOverlay: Color(0xFF1E293B),
    inputBackground: Color(0xFF1E293B),
    primary: Color(0xFFFF851A),
    primaryMuted: Color(0x33FF851A),
    primaryLight: Color(0x1AFF851A),
    primaryFaint: Color(0x14FF851A),
    primaryBorder: Color(0x4DFF851A),
    success: Color(0xFF22C55E),
    successMuted: Color(0x3322C55E),
    warning: Color(0xFFFFBF00),
    warningDark: Color(0xFFF59E0B),
    warningMuted: Color(0x33FFBF00),
    error: Color(0xFFEF4444),
    errorMuted: Color(0x33EF4444),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFCBD5E1),
    textMuted: Color(0xFF94A3B8),
    textHint: Color(0xFF64748B),
    textDark: Color(0xFF000000),
    border: Color(0xFF334155),
    borderSubtle: Color(0x1AFFFFFF),
    deepNavy: Color(0xFF001F3F),
  );

  // ═══════════════════ LIGHT THEME (Tema Claro Limpo e Elegante) ═══════════════════
  static const light = AppColorsExtension(
    background: Color(0xFFF8FAFC),       // Slate 50
    backgroundAlt: Color(0xFFF1F5F9),    // Slate 100
    headerBackground: Color(0xFFFFFFFF), // Branco
    cardBackground: Color(0xFFFFFFFF),   // Branco
    cardBackgroundAlt: Color(0xFFF1F5F9),// Slate 100 suave
    surfaceOverlay: Color(0xFFE2E8F0),   // Slate 200
    inputBackground: Color(0xFFF1F5F9),  // Slate 100
    primary: Color(0xFFFF851A),          // Laranja identidade RotaRDV
    primaryMuted: Color(0x26FF851A),
    primaryLight: Color(0x14FF851A),
    primaryFaint: Color(0x0DFF851A),     // Muito sutil em fundo claro
    primaryBorder: Color(0x4DFF851A),
    success: Color(0xFF16A34A),          // Verde com ótimo contraste
    successMuted: Color(0x2016A34A),
    warning: Color(0xFFD97706),          // Âmbar visível em fundo claro
    warningDark: Color(0xFFB45309),
    warningMuted: Color(0x20D97706),
    error: Color(0xFFDC2626),            // Vermelho com contraste
    errorMuted: Color(0x20DC2626),
    textPrimary: Color(0xFF0F172A),      // Slate 900
    textSecondary: Color(0xFF334155),    // Slate 700
    textMuted: Color(0xFF64748B),        // Slate 500
    textHint: Color(0xFF94A3B8),         // Slate 400
    textDark: Color(0xFF000000),
    border: Color(0xFFE2E8F0),           // Slate 200
    borderSubtle: Color(0xFFCBD5E1),     // Slate 300
    deepNavy: Color(0xFFF1F5F9),
  );

  @override
  AppColorsExtension copyWith({
    Color? background,
    Color? backgroundAlt,
    Color? headerBackground,
    Color? cardBackground,
    Color? cardBackgroundAlt,
    Color? surfaceOverlay,
    Color? inputBackground,
    Color? primary,
    Color? primaryMuted,
    Color? primaryLight,
    Color? primaryFaint,
    Color? primaryBorder,
    Color? success,
    Color? successMuted,
    Color? warning,
    Color? warningDark,
    Color? warningMuted,
    Color? error,
    Color? errorMuted,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? textHint,
    Color? textDark,
    Color? border,
    Color? borderSubtle,
    Color? deepNavy,
  }) {
    return AppColorsExtension(
      background: background ?? this.background,
      backgroundAlt: backgroundAlt ?? this.backgroundAlt,
      headerBackground: headerBackground ?? this.headerBackground,
      cardBackground: cardBackground ?? this.cardBackground,
      cardBackgroundAlt: cardBackgroundAlt ?? this.cardBackgroundAlt,
      surfaceOverlay: surfaceOverlay ?? this.surfaceOverlay,
      inputBackground: inputBackground ?? this.inputBackground,
      primary: primary ?? this.primary,
      primaryMuted: primaryMuted ?? this.primaryMuted,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryFaint: primaryFaint ?? this.primaryFaint,
      primaryBorder: primaryBorder ?? this.primaryBorder,
      success: success ?? this.success,
      successMuted: successMuted ?? this.successMuted,
      warning: warning ?? this.warning,
      warningDark: warningDark ?? this.warningDark,
      warningMuted: warningMuted ?? this.warningMuted,
      error: error ?? this.error,
      errorMuted: errorMuted ?? this.errorMuted,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      textHint: textHint ?? this.textHint,
      textDark: textDark ?? this.textDark,
      border: border ?? this.border,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      deepNavy: deepNavy ?? this.deepNavy,
    );
  }

  @override
  AppColorsExtension lerp(AppColorsExtension? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      background: Color.lerp(background, other.background, t)!,
      backgroundAlt: Color.lerp(backgroundAlt, other.backgroundAlt, t)!,
      headerBackground: Color.lerp(headerBackground, other.headerBackground, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      cardBackgroundAlt: Color.lerp(cardBackgroundAlt, other.cardBackgroundAlt, t)!,
      surfaceOverlay: Color.lerp(surfaceOverlay, other.surfaceOverlay, t)!,
      inputBackground: Color.lerp(inputBackground, other.inputBackground, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryMuted: Color.lerp(primaryMuted, other.primaryMuted, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryFaint: Color.lerp(primaryFaint, other.primaryFaint, t)!,
      primaryBorder: Color.lerp(primaryBorder, other.primaryBorder, t)!,
      success: Color.lerp(success, other.success, t)!,
      successMuted: Color.lerp(successMuted, other.successMuted, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningDark: Color.lerp(warningDark, other.warningDark, t)!,
      warningMuted: Color.lerp(warningMuted, other.warningMuted, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorMuted: Color.lerp(errorMuted, other.errorMuted, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      textDark: Color.lerp(textDark, other.textDark, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      deepNavy: Color.lerp(deepNavy, other.deepNavy, t)!,
    );
  }
}

/// Helper para acessar as cores sem boilerplate com `context.colors`.
extension AppColorsContext on BuildContext {
  AppColorsExtension get colors =>
      Theme.of(this).extension<AppColorsExtension>() ?? AppColorsExtension.dark;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

/// Paleta de cores centralizada estática mantida para compatibilidade e serviços sem BuildContext.
class AppColors {
  static const Color background = Color(0xFF0A0F1A);
  static const Color backgroundAlt = Color(0xFF0C1326);
  static const Color headerBackground = Color(0xFF0A0F1A);
  static const Color cardBackground = Color(0xFF0F172A);
  static const Color cardBackgroundAlt = Color(0xFF0D121F);
  static const Color surfaceOverlay = Color(0xFF1E293B);
  static const Color inputBackground = Color(0xFF1E293B);

  static const Color primary = Color(0xFFFF851A);
  static const Color primaryMuted = Color(0x33FF851A);
  static const Color primaryLight = Color(0x1AFF851A);
  static const Color primaryFaint = Color(0x14FF851A);
  static const Color primaryBorder = Color(0x4DFF851A);

  static const Color success = Color(0xFF22C55E);
  static const Color successMuted = Color(0x3322C55E);
  static const Color warning = Color(0xFFFFBF00);
  static const Color warningDark = Color(0xFFF59E0B);
  static const Color warningMuted = Color(0x33FFBF00);
  static const Color error = Color(0xFFEF4444);
  static const Color errorMuted = Color(0x33EF4444);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textHint = Color(0xFF64748B);
  static const Color textDark = Color(0xFF000000);

  static const Color border = Color(0xFF334155);
  static const Color borderSubtle = Color(0x1AFFFFFF);
  static const Color deepNavy = Color(0xFF001F3F);
}
