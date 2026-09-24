import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../models/viagem_collection.dart';

// Componente modular que renderiza o itinerário da rota com timeline gráfica de origem e destino, além das credenciais do veículo tracionador vinculado.
class ViagemRotaCard extends StatelessWidget {
  final ViagemCollection viagem;
  final Map<String, dynamic>? veiculo;

  const ViagemRotaCard({
    super.key,
    required this.viagem,
    this.veiculo,
  });

  String _formatDateTime(DateTime dt) {
    try {
      return DateFormat('dd/MM/yyyy • HH:mm').format(dt.toLocal());
    } catch (_) {
      return DateFormat('dd/MM/yyyy').format(dt.toLocal());
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isEmAndamento = viagem.status == 'em_andamento';
    final isConcluida = viagem.status == 'concluida' || viagem.status == 'concluída';
    final isCancelada = viagem.status == 'cancelada';

    final Color statusColor = isEmAndamento
        ? colors.warning
        : (isConcluida ? colors.success : colors.error);

    final IconData statusIcon = isEmAndamento
        ? LucideIcons.truck
        : (isConcluida ? LucideIcons.checkCircle2 : LucideIcons.xCircle);

    final String statusBadgeText = isEmAndamento
        ? 'Em andamento'
        : (isConcluida ? 'Concluída' : 'Cancelada');

    return AppCard(
      backgroundColor: colors.cardBackground,
      borderColor: colors.borderSubtle,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 13, color: statusColor),
                    const SizedBox(width: 5),
                    Text(
                      statusBadgeText,
                      style: GoogleFonts.lexend(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _formatDateTime(viagem.dataInicio),
                style: GoogleFonts.lexend(
                  fontSize: 11,
                  color: colors.textHint,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Timeline Visual: Origem ➔ Destino
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const SizedBox(height: 2),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: isCancelada ? colors.textMuted : colors.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.background, width: 2),
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 38,
                    color: statusColor.withValues(alpha: 0.35),
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.background, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: statusColor.withValues(alpha: 0.35),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Origem',
                          style: GoogleFonts.lexend(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: colors.textHint,
                          ),
                        ),
                        Text(
                          '${viagem.origemCidade}, ${viagem.origemEstado}',
                          style: GoogleFonts.lexend(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Destino',
                          style: GoogleFonts.lexend(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: colors.textHint,
                          ),
                        ),
                        Text(
                          '${viagem.destinoCidade}, ${viagem.destinoEstado}',
                          style: GoogleFonts.lexend(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (veiculo != null) ...[
            const SizedBox(height: AppSpacing.md),
            Divider(color: colors.borderSubtle, height: 1),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(LucideIcons.truck, size: 14, color: colors.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${veiculo!['modelo'] ?? 'Caminhão'} • Placa ${veiculo!['placa'] ?? 'N/A'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lexend(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: colors.textSecondary,
                    ),
                  ),
                ),
                if (viagem.dataFim != null)
                  Text(
                    'Fim: ${_formatDateTime(viagem.dataFim!)}',
                    style: GoogleFonts.lexend(
                      fontSize: 11,
                      color: colors.textHint,
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
