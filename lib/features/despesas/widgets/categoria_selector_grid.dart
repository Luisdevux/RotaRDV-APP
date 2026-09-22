import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../despesa_viewmodel.dart';

/*──────────────────────────────────────────────────────────────*/
/* COMPONENTE: GRADE DE SELEÇÃO DE CATEGORIAS DE DESPESA        */
/*──────────────────────────────────────────────────────────────*/

/// Componente modular para seleção da categoria do lançamento financeiro.
class CategoriaSelectorGrid extends StatelessWidget {
  final CategoriaDespesa? selectedCategoria;
  final ValueChanged<CategoriaDespesa> onSelected;

  const CategoriaSelectorGrid({
    super.key,
    required this.selectedCategoria,
    required this.onSelected,
  });

  IconData _getIconForCategoria(CategoriaDespesa categoria) {
    switch (categoria) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.25,
          children: [
            _buildCategoriaButton(CategoriaDespesa.abastecimento, colors),
            _buildCategoriaButton(CategoriaDespesa.alimentacao, colors),
            _buildCategoriaButton(CategoriaDespesa.manutencao, colors),
            _buildCategoriaButton(CategoriaDespesa.pedagio, colors),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _buildOutrosButton(colors),
      ],
    );
  }

  Widget _buildCategoriaButton(CategoriaDespesa categoria, AppColorsExtension colors) {
    final isSelected = selectedCategoria == categoria;
    final icon = _getIconForCategoria(categoria);

    return AppCard(
      onTap: () => onSelected(categoria),
      isHighlighted: isSelected,
      backgroundColor: isSelected ? colors.primaryLight : colors.cardBackground,
      borderColor: isSelected ? colors.primary : colors.border,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isSelected ? colors.primary : colors.primaryLight,
              borderRadius: AppRadius.mdRadius,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : colors.primary,
              size: 26,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            categoria.label,
            textAlign: TextAlign.center,
            style: GoogleFonts.lexend(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? colors.primary : colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutrosButton(AppColorsExtension colors) {
    final isSelected = selectedCategoria == CategoriaDespesa.outros;

    return AppCard(
      onTap: () => onSelected(CategoriaDespesa.outros),
      isHighlighted: isSelected,
      backgroundColor: isSelected ? colors.primaryLight : colors.cardBackground,
      borderColor: isSelected ? colors.primary : colors.border,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: isSelected ? colors.primary : colors.primaryLight,
              borderRadius: AppRadius.smRadius,
            ),
            child: Icon(
              LucideIcons.circleDot,
              color: isSelected ? Colors.white : colors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            'Outras Despesas',
            style: GoogleFonts.lexend(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: isSelected ? colors.primary : colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
