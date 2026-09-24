// lib/features/viagem/widgets/viagem_bottom_actions.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';

// Componente modular fixado na base da tela com botões de ação rápida: encerramento da jornada e novo lançamento financeiro com comprovante
class ViagemBottomActions extends StatelessWidget {
  final VoidCallback onEncerrarViagem;
  final VoidCallback onLancarDespesa;

  const ViagemBottomActions({
    super.key,
    required this.onEncerrarViagem,
    required this.onLancarDespesa,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.headerBackground,
        border: Border(top: BorderSide(color: colors.borderSubtle, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: OutlinedButton.icon(
                onPressed: onEncerrarViagem,
                icon: Icon(LucideIcons.checkCircle2, size: 18, color: colors.error),
                label: Text(
                  'Encerrar viagem',
                  style: GoogleFonts.lexend(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: colors.error,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colors.error),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.smRadius),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              flex: 1,
              child: ElevatedButton.icon(
                onPressed: onLancarDespesa,
                icon: const Icon(LucideIcons.plusCircle, size: 18, color: Colors.white),
                label: Text(
                  'Lançar despesa',
                  style: GoogleFonts.lexend(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.6,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.smRadius),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
