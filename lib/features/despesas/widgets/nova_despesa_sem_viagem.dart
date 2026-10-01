// lib/features/despesas/widgets/nova_despesa_sem_viagem.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';

// Exibição de estado vazio quando não há nenhuma viagem em andamento para vincular o lançamento
class NovaDespesaSemViagem extends StatelessWidget {
  final VoidCallback onVoltar;

  const NovaDespesaSemViagem({
    super.key,
    required this.onVoltar,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.huge),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: colors.warning.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(LucideIcons.alertTriangle, size: 48, color: colors.warning),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Nenhuma viagem em andamento',
              textAlign: TextAlign.center,
              style: GoogleFonts.lexend(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Para lançar uma despesa ou comprovante, você precisa primeiro iniciar uma viagem.',
              textAlign: TextAlign.center,
              style: GoogleFonts.lexend(
                fontSize: 14,
                color: colors.textMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            ElevatedButton(
              onPressed: onVoltar,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.md),
              ),
              child: Text(
                'Voltar ao início',
                style: GoogleFonts.lexend(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
