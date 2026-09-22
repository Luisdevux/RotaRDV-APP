import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../despesas/despesa_viewmodel.dart';

/*──────────────────────────────────────────────────────────────*/
/* COMPONENTE: PREVISÃO DE CONSUMO NO ENCERRAMENTO DA VIAGEM    */
/*──────────────────────────────────────────────────────────────*/

/// Componente modular que exibe o cálculo dinâmico da média final de consumo (km/l)
/// atualizada em tempo real conforme o odômetro de chegada digitado pelo condutor.
class EncerrarViagemConsumoCard extends StatelessWidget {
  final MetricasConsumoViagem metricas;

  const EncerrarViagemConsumoCard({
    super.key,
    required this.metricas,
  });

  String _obterValorConsumo(MetricasConsumoViagem metricas) {
    if (metricas.mediaConsumoGeral != null) {
      return '${metricas.mediaConsumoGeral!.toStringAsFixed(2)} km/l';
    }
    if (metricas.temDadosAbastecimento) {
      return 'Informe o KM final válido';
    }
    return 'Sem abastecimento lançado';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppCard(
      backgroundColor: colors.cardBackground,
      borderColor: colors.borderSubtle,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: colors.surfaceOverlay,
              borderRadius: AppRadius.smRadius,
              border: Border.all(color: colors.borderSubtle),
            ),
            child: Icon(LucideIcons.fuel, size: 18, color: colors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Média de consumo da rota',
                  style: GoogleFonts.lexend(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colors.textHint,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _obterValorConsumo(metricas),
                  style: GoogleFonts.lexend(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          if (metricas.temDadosAbastecimento) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${metricas.totalLitros.toStringAsFixed(1)} L',
                  style: GoogleFonts.lexend(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: colors.textSecondary,
                  ),
                ),
                Text(
                  '${metricas.totalAbastecimentos} abastec.',
                  style: GoogleFonts.lexend(
                    fontSize: 10,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
