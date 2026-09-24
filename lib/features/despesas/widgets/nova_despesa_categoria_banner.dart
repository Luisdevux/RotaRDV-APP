// lib/features/despesas/widgets/nova_despesa_categoria_banner.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../despesa_viewmodel.dart';

// Exibe a categoria ativa selecionada para a despesa atual com opção de troca.
class NovaDespesaCategoriaBanner extends StatelessWidget {
  final CategoriaDespesa categoria;
  final bool podeTrocar;
  final VoidCallback onTrocar;

  const NovaDespesaCategoriaBanner({
    super.key,
    required this.categoria,
    required this.podeTrocar,
    required this.onTrocar,
  });

  IconData _getIconForCategoria(CategoriaDespesa cat) {
    switch (cat) {
      case CategoriaDespesa.abastecimento:
        return LucideIcons.fuel;
      case CategoriaDespesa.alimentacao:
        return LucideIcons.utensils;
      case CategoriaDespesa.manutencao:
        return LucideIcons.wrench;
      case CategoriaDespesa.pedagio:
        return LucideIcons.receipt;
      case CategoriaDespesa.outros:
        return LucideIcons.circleDot;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: colors.primaryLight,
              borderRadius: AppRadius.mdRadius,
            ),
            child: Icon(_getIconForCategoria(categoria), color: colors.primary, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categoria',
                  style: GoogleFonts.lexend(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: colors.textHint,
                  ),
                ),
                Text(
                  categoria.label,
                  style: GoogleFonts.lexend(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          if (podeTrocar)
            TextButton(
              onPressed: onTrocar,
              child: Text(
                'Trocar',
                style: GoogleFonts.lexend(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
