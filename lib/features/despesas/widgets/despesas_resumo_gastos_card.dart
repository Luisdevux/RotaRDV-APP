import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../models/viagem_collection.dart';
import '../despesa_viewmodel.dart';

// Card de cabeçalho analítico que exibe a rota operacional, o somatório financeiro dos lançamentos e a eficiência energética do veículo.
class DespesasResumoGastosCard extends StatelessWidget {
  final DespesaViewModel despesaVM;
  final ViagemCollection? viagem;

  const DespesasResumoGastosCard({
    super.key,
    required this.despesaVM,
    this.viagem,
  });

  String _formatCurrency(double val) {
    try {
      return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(val);
    } catch (_) {
      return 'R\$ ${val.toStringAsFixed(2)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: AppCard(
        backgroundColor: colors.cardBackground,
        borderColor: colors.borderSubtle,
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (viagem != null) ...[
              Row(
                children: [
                  Icon(LucideIcons.mapPin, size: 15, color: colors.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      '${viagem!.origemCidade} (${viagem!.origemEstado}) ➔ ${viagem!.destinoCidade} (${viagem!.destinoEstado})',
                      style: GoogleFonts.lexend(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Divider(color: colors.borderSubtle, height: 1),
              const SizedBox(height: AppSpacing.md),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total de despesas da viagem',
                  style: GoogleFonts.lexend(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colors.textMuted,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: colors.primary.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    '${despesaVM.despesas.length} ${despesaVM.despesas.length == 1 ? "registro" : "registros"}',
                    style: GoogleFonts.lexend(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              _formatCurrency(despesaVM.totalGasto),
              style: GoogleFonts.lexend(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            if (viagem != null) ...[
              Builder(
                builder: (_) {
                  final metricas = despesaVM.calcularMetricasConsumo(viagem!);
                  if (!metricas.temDadosAbastecimento) return const SizedBox.shrink();

                  return Column(
                    children: [
                      const SizedBox(height: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
                        decoration: BoxDecoration(
                          color: colors.surfaceOverlay,
                          borderRadius: AppRadius.smRadius,
                          border: Border.all(color: colors.borderSubtle),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(LucideIcons.fuel, size: 14, color: colors.primary),
                                const SizedBox(width: 6),
                                Text(
                                  'Média do veículo:',
                                  style: GoogleFonts.lexend(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              metricas.mediaConsumoGeral != null
                                  ? '${metricas.mediaConsumoGeral!.toStringAsFixed(2)} km/l (${NumberFormat('#,##0.#', 'pt_BR').format(metricas.totalLitros)} L)'
                                  : '${NumberFormat('#,##0.#', 'pt_BR').format(metricas.totalLitros)} L abastecidos',
                              style: GoogleFonts.lexend(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
