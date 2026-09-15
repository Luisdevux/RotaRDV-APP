import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';

/// Badge visual padronizado, limpo e elegante para status do sistema.
/// Sem ícones excessivos — tipografia clara com fundo translúcido sutil.
class AppStatusBadge extends StatelessWidget {
  final String status;
  final Color? customColor;
  final String? customLabel;

  const AppStatusBadge({
    super.key,
    required this.status,
    this.customColor,
    this.customLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final (color, label) = _resolveStatus(colors);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.smRadius,
      ),
      child: Text(
        customLabel ?? label,
        style: GoogleFonts.lexend(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: customColor ?? color,
        ),
      ),
    );
  }

  (Color, String) _resolveStatus(AppColorsExtension colors) {
    final s = status.toLowerCase().trim();

    if (s == ViagemStatus.emAndamento) {
      return (colors.primary, 'EM ANDAMENTO');
    } else if (s == ViagemStatus.concluida || s == 'concluída') {
      return (colors.success, 'CONCLUÍDA');
    } else if (s == ViagemStatus.cancelada) {
      return (colors.error, 'CANCELADA');
    } else if (s == SyncStatus.sincronizado) {
      return (colors.success, 'SINCRONIZADO');
    } else if (s == SyncStatus.criado || s == SyncStatus.editado) {
      return (colors.warning, 'LOCAL');
    }

    return (colors.textMuted, status.toUpperCase());
  }
}
