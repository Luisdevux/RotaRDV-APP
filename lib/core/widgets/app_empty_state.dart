// lib/core/widgets/app_empty_state.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// Componente padronizado para exibir estado vazio em listas e consultas
class AppEmptyState extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final Widget? action;
  final EdgeInsetsGeometry padding;

  const AppEmptyState({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.xxl,
      vertical: AppSpacing.massive,
    ),
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: colors.surfaceOverlay,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 26,
                  color: colors.textHint,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.lexend(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: GoogleFonts.lexend(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: colors.textMuted,
                  height: 1.4,
                ),
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: AppSpacing.xl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
