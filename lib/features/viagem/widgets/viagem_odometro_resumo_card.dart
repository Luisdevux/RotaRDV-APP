import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../models/viagem_collection.dart';
import '../../despesas/despesa_viewmodel.dart';

/*──────────────────────────────────────────────────────────────*/
/* COMPONENTE: MÉTRICAS OPERACIONAIS E GASTOS DA VIAGEM         */
/*──────────────────────────────────────────────────────────────*/

/// Componente modular que renderiza lado a lado os indicadores de odômetro
/// (KM percorrido no trecho) e o total financeiro de despesas lançadas.
class ViagemOdometroResumoCard extends StatelessWidget {
  final ViagemCollection viagem;
  final DespesaViewModel despesaVM;
  final VoidCallback onVerDespesas;

  const ViagemOdometroResumoCard({
    super.key,
    required this.viagem,
    required this.despesaVM,
    required this.onVerDespesas,
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
    final kmIni = viagem.kmInicial;
    final kmFim = viagem.kmFinal;
    final double? percorrido = (kmFim != null && kmFim >= kmIni) ? (kmFim - kmIni) : null;
    final isEmAndamento = viagem.status == 'em_andamento';

    return Row(
      children: [
        // Card de Odômetro (KM)
        Expanded(
          child: AppCard(
            backgroundColor: colors.cardBackground,
            borderColor: colors.borderSubtle,
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Odômetro',
                      style: GoogleFonts.lexend(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colors.textHint,
                      ),
                    ),
                    Icon(LucideIcons.gauge, size: 14, color: colors.primary),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  percorrido != null
                      ? '${percorrido.toStringAsFixed(0)} KM'
                      : (isEmAndamento ? 'Em andamento' : '${kmIni.toStringAsFixed(0)} KM'),
                  style: GoogleFonts.lexend(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Inicial: ${kmIni.toStringAsFixed(0)} KM',
                  style: GoogleFonts.lexend(
                    fontSize: 11,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),

        // Card de Finanças (Gastos da Rota)
        Expanded(
          child: AppCard(
            onTap: onVerDespesas,
            backgroundColor: colors.cardBackground,
            borderColor: colors.borderSubtle,
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Despesas',
                      style: GoogleFonts.lexend(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colors.textHint,
                      ),
                    ),
                    Icon(LucideIcons.chevronRight, size: 14, color: colors.textSecondary),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _formatCurrency(despesaVM.totalGasto),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lexend(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${despesaVM.despesas.length} lançamento(s)',
                  style: GoogleFonts.lexend(
                    fontSize: 11,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
