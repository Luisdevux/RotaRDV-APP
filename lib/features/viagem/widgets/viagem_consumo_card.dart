// lib/features/viagem/widgets/viagem_consumo_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../models/viagem_collection.dart';
import '../../despesas/despesa_viewmodel.dart';

// Componente modular que renderiza as médias consolidadas de consumo (km/l) da viagem e do último trecho abastecido
class ViagemConsumoCard extends StatelessWidget {
  final ViagemCollection viagem;
  final DespesaViewModel despesaVM;

  const ViagemConsumoCard({
    super.key,
    required this.viagem,
    required this.despesaVM,
  });

  String _formatarLegendaMediaGeral(bool isKmIncoerente, MetricasConsumoViagem metricas) {
    if (isKmIncoerente) {
      return 'KM menor que inicial';
    }
    if (metricas.totalLitros <= 0) {
      return 'Informe litros para calcular';
    }
    final km = metricas.kmPercorridoTotal.toStringAsFixed(0);
    final l = metricas.totalLitros.toStringAsFixed(1);
    return '$km km • $l L';
  }

  String _formatarLegendaUltimoTrecho(bool isKmIncoerente, MetricasConsumoViagem metricas) {
    if (isKmIncoerente) {
      final km = metricas.ultimoKmInformado?.toStringAsFixed(0) ?? '--';
      return 'Odômetro ($km) < Inicial';
    }
    if (metricas.kmTrechoUltimo != null && metricas.litrosUltimoAbastecimento != null) {
      final km = metricas.kmTrechoUltimo!.toStringAsFixed(0);
      final l = metricas.litrosUltimoAbastecimento!.toStringAsFixed(1);
      return '$km km • $l L';
    }
    return 'Trecho inicial';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final metricas = despesaVM.calcularMetricasConsumo(viagem);
    final isKmIncoerente = metricas.ultimoKmInformado != null &&
        metricas.ultimoKmInformado! < viagem.kmInicial;

    return AppCard(
      backgroundColor: colors.cardBackground,
      borderColor: isKmIncoerente ? colors.warning.withValues(alpha: 0.5) : colors.borderSubtle,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.fuel, size: 15, color: colors.primary),
                  const SizedBox(width: 6),
                  Text(
                    'Consumo do veículo',
                    style: GoogleFonts.lexend(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: metricas.temDadosAbastecimento ? colors.primaryLight : colors.surfaceOverlay,
                  borderRadius: AppRadius.pillRadius,
                  border: Border.all(
                    color: metricas.temDadosAbastecimento ? colors.primaryBorder : colors.borderSubtle,
                  ),
                ),
                child: Text(
                  metricas.temDadosAbastecimento
                      ? '${metricas.totalAbastecimentos} ${metricas.totalAbastecimentos == 1 ? "abastecimento" : "abastecimentos"}'
                      : 'Sem abastecimento',
                  style: GoogleFonts.lexend(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: metricas.temDadosAbastecimento ? colors.primary : colors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          if (metricas.temDadosAbastecimento) ...[
            Row(
              children: [
                // Média Geral da Viagem
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: colors.surfaceOverlay,
                      borderRadius: AppRadius.mdRadius,
                      border: Border.all(color: colors.borderSubtle),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Média da rota',
                          style: GoogleFonts.lexend(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: colors.textHint,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          metricas.mediaConsumoGeral != null
                              ? '${metricas.mediaConsumoGeral!.toStringAsFixed(2)} km/l'
                              : '-- km/l',
                          style: GoogleFonts.lexend(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatarLegendaMediaGeral(isKmIncoerente, metricas),
                          style: GoogleFonts.lexend(
                            fontSize: 10,
                            color: isKmIncoerente ? colors.warning : colors.textMuted,
                            fontWeight: isKmIncoerente ? FontWeight.w600 : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),

                // Média do Último Trecho
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: colors.surfaceOverlay,
                      borderRadius: AppRadius.mdRadius,
                      border: Border.all(color: colors.borderSubtle),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Último abastecimento',
                          style: GoogleFonts.lexend(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: colors.textHint,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          metricas.mediaUltimoAbastecimento != null
                              ? '${metricas.mediaUltimoAbastecimento!.toStringAsFixed(2)} km/l'
                              : '-- km/l',
                          style: GoogleFonts.lexend(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatarLegendaUltimoTrecho(isKmIncoerente, metricas),
                          style: GoogleFonts.lexend(
                            fontSize: 10,
                            color: isKmIncoerente ? colors.warning : colors.textMuted,
                            fontWeight: isKmIncoerente ? FontWeight.w600 : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Row(
              children: [
                Icon(LucideIcons.info, size: 16, color: colors.textHint),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Ao lançar abastecimentos com litros e odômetro, a média (km/l) do veículo será calculada aqui automaticamente.',
                    style: GoogleFonts.lexend(
                      fontSize: 12,
                      color: colors.textMuted,
                    ),
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
