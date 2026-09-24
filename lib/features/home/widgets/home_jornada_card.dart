// lib/features/home/widgets/home_jornada_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../models/viagem_collection.dart';
import '../../../routes.dart';

// Componente modular que apresenta o status atual da operação:
// exibe a viagem ativa e atalho de navegação, ou o convite para início de jornada
class HomeJornadaCard extends StatelessWidget {
  final ViagemCollection? viagemAtiva;
  final VoidCallback onAcessarViagem;

  const HomeJornadaCard({
    super.key,
    required this.viagemAtiva,
    required this.onAcessarViagem,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: viagemAtiva != null
          ? _buildCardViagemAtiva(context, colors, viagemAtiva!)
          : _buildCardSemViagem(context, colors),
    );
  }

  Widget _buildCardViagemAtiva(
    BuildContext context,
    AppColorsExtension colors,
    ViagemCollection viagem,
  ) {
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.truck, size: 12, color: colors.warning),
                    const SizedBox(width: 5),
                    Text(
                      'Em andamento',
                      style: GoogleFonts.lexend(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6,
                        color: colors.warning,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                DateFormat('dd/MM • HH:mm').format(viagem.dataInicio.toLocal()),
                style: GoogleFonts.lexend(
                  fontSize: 11,
                  color: colors.textHint,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '${viagem.origemCidade} ➔ ${viagem.destinoCidade}',
            style: GoogleFonts.lexend(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'KM inicial: ${viagem.kmInicial.toStringAsFixed(0)} KM',
            style: GoogleFonts.lexend(
              fontSize: 12,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: onAcessarViagem,
              icon: const Icon(LucideIcons.navigation, color: Colors.white, size: 18),
              label: Text(
                'Acessar viagem',
                style: GoogleFonts.lexend(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.mdRadius,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSemViagem(BuildContext context, AppColorsExtension colors) {
    return AppCard(
      backgroundColor: colors.cardBackground,
      borderColor: colors.borderSubtle,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: colors.primaryLight,
                  borderRadius: AppRadius.smRadius,
                ),
                child: Icon(LucideIcons.truck, size: 18, color: colors.primary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status atual',
                      style: GoogleFonts.lexend(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6,
                        color: colors.textHint,
                      ),
                    ),
                    Text(
                      'Nenhuma viagem em andamento',
                      style: GoogleFonts.lexend(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Inicie uma nova viagem para registrar ponto de partida, destino e despesas.',
            style: GoogleFonts.lexend(
              fontSize: 12,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, Routes.novaViagem);
              },
              icon: const Icon(LucideIcons.plus, color: Colors.white, size: 18),
              label: Text(
                'Iniciar nova viagem',
                style: GoogleFonts.lexend(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.mdRadius,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
