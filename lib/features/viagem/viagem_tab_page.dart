import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/network_status_bar.dart';
import '../../models/viagem_collection.dart';
import '../../routes.dart';
import '../home/home_viewmodel.dart';
import 'detalhes_viagem_page.dart';

// Aba intermediária do shell de navegação. Caso haja uma viagem em andamento, apresenta a tela de gestão detalhada, se não, apresenta o estado de boas-vindas com atalho para abertura de nova rota
class ViagemTabPage extends StatelessWidget {
  final ValueChanged<int>? onNavigateToTab;

  const ViagemTabPage({
    super.key,
    this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final homeVM = context.watch<HomeViewModel>();
    final veiculo = homeVM.veiculo;

    final ViagemCollection? viagemAtiva = homeVM.ultimasViagens.cast<ViagemCollection?>().firstWhere(
          (v) => v?.status == ViagemStatus.emAndamento,
          orElse: () => null,
        );

    if (viagemAtiva != null) {
      return DetalhesViagemPage(
        viagem: viagemAtiva,
        isTab: true,
        onNavigateToTab: onNavigateToTab,
      );
    }

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.headerBackground,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: colors.primary),
          onPressed: () {
            if (onNavigateToTab != null) {
              onNavigateToTab!(0);
            } else if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          'Viagem',
          style: GoogleFonts.lexend(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const NetworkStatusBar(),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl,
                    vertical: AppSpacing.xl,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: AppSpacing.xl),
                      Text(
                        'Nenhuma viagem em andamento',
                        style: GoogleFonts.lexend(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Inicie uma nova viagem para registrar as cidades de origem, destino, odômetro e controlar todas as despesas da rota.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lexend(
                          fontSize: 14,
                          color: colors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      if (veiculo != null) ...[
                        const SizedBox(height: AppSpacing.xl),
                        AppCard(
                          backgroundColor: colors.cardBackground,
                          borderColor: colors.borderSubtle,
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Row(
                            children: [
                              Icon(LucideIcons.truck, color: colors.primary, size: 20),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Veículo vinculado',
                                      style: GoogleFonts.lexend(
                                        fontSize: 11,
                                        color: colors.textMuted,
                                      ),
                                    ),
                                    Text(
                                      '${veiculo['modelo']} • Placa: ${veiculo['placa']}',
                                      style: GoogleFonts.lexend(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: colors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xxl),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.novaViagem);
                          },
                          icon: const Icon(LucideIcons.plus, color: Colors.white, size: 20),
                          label: Text(
                            'Iniciar nova viagem',
                            style: GoogleFonts.lexend(
                              fontSize: 16,
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
