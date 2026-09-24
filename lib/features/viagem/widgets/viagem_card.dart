// lib/features/viagem/widgets/viagem_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../models/viagem_collection.dart';

// Componente modular e desacoplado que renderiza o resumo visual de uma viagem, incluindo trajeto de origem/destino, status operacional, data e odômetros.
class ViagemCard extends StatelessWidget {
  final ViagemCollection viagem;
  final VoidCallback? onTap;

  const ViagemCard({
    super.key,
    required this.viagem,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isEmAndamento = viagem.status == ViagemStatus.emAndamento;
    final isConcluida = viagem.status == ViagemStatus.concluida || viagem.status == 'concluída';
    final isCancelada = viagem.status == ViagemStatus.cancelada;
    final localDt = viagem.dataInicio.toLocal();
    final dateStr = DateFormat('dd/MM/yyyy • HH:mm').format(localDt);

    return AppCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      backgroundColor: colors.cardBackground,
      borderColor: isEmAndamento
          ? colors.primary.withValues(alpha: 0.3)
          : (isCancelada ? colors.error.withValues(alpha: 0.3) : colors.borderSubtle),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isEmAndamento
                        ? LucideIcons.truck
                        : (isConcluida ? LucideIcons.checkCircle2 : LucideIcons.xCircle),
                    size: 16,
                    color: isEmAndamento
                        ? colors.warning
                        : (isConcluida ? colors.success : colors.error),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    (isEmAndamento ? 'Em andamento' : (isConcluida ? 'Concluída' : 'Cancelada')),
                    style: GoogleFonts.lexend(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                      color: isEmAndamento
                          ? colors.warning
                          : (isConcluida ? colors.success : colors.error),
                    ),
                  ),
                ],
              ),
              Text(
                dateStr,
                style: GoogleFonts.lexend(fontSize: 11, color: colors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '${viagem.origemCidade} (${viagem.origemEstado}) ➔ ${viagem.destinoCidade} (${viagem.destinoEstado})',
            style: GoogleFonts.lexend(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'KM inicial: ${viagem.kmInicial.toStringAsFixed(0)} KM',
                style: GoogleFonts.lexend(fontSize: 12, color: colors.textSecondary),
              ),
              if (viagem.kmFinal != null)
                Text(
                  'KM final: ${viagem.kmFinal!.toStringAsFixed(0)} KM',
                  style: GoogleFonts.lexend(fontSize: 12, color: colors.textSecondary),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
