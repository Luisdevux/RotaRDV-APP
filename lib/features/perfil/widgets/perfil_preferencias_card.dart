// lib/features/perfil/widgets/perfil_preferencias_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/app_card.dart';

// Componente modular que permite a customização do tema do aplicativo entre modos Claro, Escuro ou Sincronizado com o Sistema Operacional
class PerfilPreferenciasCard extends StatefulWidget {
  final ThemeProvider? themeProvider;

  const PerfilPreferenciasCard({
    super.key,
    this.themeProvider,
  });

  @override
  State<PerfilPreferenciasCard> createState() => _PerfilPreferenciasCardState();
}

class _PerfilPreferenciasCardState extends State<PerfilPreferenciasCard> {
  bool _isExpanded = false;

  String _getThemeSummary(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'Tema escuro';
      case ThemeMode.light:
        return 'Tema claro';
      case ThemeMode.system:
        return 'Padrão do sistema';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    ThemeProvider? provider = widget.themeProvider;
    if (provider == null) {
      try {
        provider = context.watch<ThemeProvider>();
      } catch (_) {}
    }
    final currentMode = provider?.themeMode ?? ThemeMode.dark;

    void selectMode(ThemeMode mode) {
      if (widget.themeProvider != null) {
        widget.themeProvider!.setThemeMode(mode);
      } else {
        try {
          context.read<ThemeProvider>().setThemeMode(mode);
        } catch (_) {}
      }
    }

    return AppCard(
      backgroundColor: colors.cardBackground,
      borderColor: colors.borderSubtle,
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: AppRadius.mdRadius,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.10),
                        borderRadius: AppRadius.smRadius,
                      ),
                      child: Icon(LucideIcons.palette, size: 18, color: colors.primary),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Aparência',
                            style: GoogleFonts.lexend(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _getThemeSummary(currentMode),
                            style: GoogleFonts.lexend(
                              fontSize: 12,
                              color: colors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: Icon(
                        LucideIcons.chevronDown,
                        size: 20,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity),
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(height: 1, color: colors.borderSubtle),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Escolha o modo de visualização do aplicativo.',
                          style: GoogleFonts.lexend(
                            fontSize: 12,
                            color: colors.textMuted,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            _buildThemeOption(
                              colors: colors,
                              mode: ThemeMode.dark,
                              currentMode: currentMode,
                              label: 'Escuro',
                              icon: LucideIcons.moon,
                              onSelect: () => selectMode(ThemeMode.dark),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            _buildThemeOption(
                              colors: colors,
                              mode: ThemeMode.light,
                              currentMode: currentMode,
                              label: 'Claro',
                              icon: LucideIcons.sun,
                              onSelect: () => selectMode(ThemeMode.light),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            _buildThemeOption(
                              colors: colors,
                              mode: ThemeMode.system,
                              currentMode: currentMode,
                              label: 'Sistema',
                              icon: LucideIcons.smartphone,
                              onSelect: () => selectMode(ThemeMode.system),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption({
    required AppColorsExtension colors,
    required ThemeMode mode,
    required ThemeMode currentMode,
    required String label,
    required IconData icon,
    required VoidCallback onSelect,
  }) {
    final isSelected = mode == currentMode;

    return Expanded(
      child: InkWell(
        onTap: onSelect,
        borderRadius: AppRadius.smRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.primary.withValues(alpha: 0.12)
                : colors.inputBackground,
            borderRadius: AppRadius.smRadius,
            border: Border.all(
              color: isSelected ? colors.primary : colors.border,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? colors.primary : colors.textMuted,
              ),
              const SizedBox(height: 5),
              Text(
                label,
                style: GoogleFonts.lexend(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? colors.primary : colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
