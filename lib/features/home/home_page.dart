// lib/features/home/home_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_empty_state.dart';
import '../../core/widgets/app_loading_indicator.dart';
import '../../core/widgets/custom_refresh_indicator.dart';
import '../../core/widgets/network_status_bar.dart';
import '../../models/viagem_collection.dart';
import '../../routes.dart';
import '../auth/auth_viewmodel.dart';
import '../viagem/detalhes_viagem_page.dart';
import '../viagem/widgets/viagem_card.dart';
import 'home_viewmodel.dart';
import 'widgets/home_header_widget.dart';
import 'widgets/home_jornada_card.dart';
import 'widgets/home_session_expired_banner.dart';

// Página inicial da aplicação móvel. Centraliza o resumo da operação atual, status de conectividade, atalhos de rota e histórico de viagens recentes
class HomePage extends StatefulWidget {
  final ValueChanged<int>? onNavigateToTab;

  const HomePage({super.key, this.onNavigateToTab});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().init();
    });
  }

  void _navegarParaViagem(ViagemCollection viagem) {
    if (widget.onNavigateToTab != null) {
      widget.onNavigateToTab!(1);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetalhesViagemPage(viagem: viagem),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final authVM = context.watch<AuthViewModel>();
    final homeVM = context.watch<HomeViewModel>();

    final user = authVM.currentUser;
    final userName = user?['nome'] ?? 'Motorista';
    final userPhotoUrl = user?['foto_perfil'];

    final ViagemCollection? viagemAtiva = homeVM.ultimasViagens.cast<ViagemCollection?>().firstWhere(
          (v) => v?.status == ViagemStatus.emAndamento,
          orElse: () => null,
        );

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            const NetworkStatusBar(),

            if (homeVM.isSessionExpired) ...[
              const SizedBox(height: AppSpacing.sm),
              HomeSessionExpiredBanner(userEmail: authVM.currentUser?['email']),
            ],

            const SizedBox(height: AppSpacing.lg),

            HomeHeaderWidget(
              userName: userName,
              userPhotoUrl: userPhotoUrl,
              veiculo: homeVM.veiculo,
            ),

            const SizedBox(height: AppSpacing.lg),

            HomeJornadaCard(
              viagemAtiva: viagemAtiva,
              onAcessarViagem: () {
                if (viagemAtiva != null) {
                  _navegarParaViagem(viagemAtiva);
                }
              },
            ),

            const SizedBox(height: AppSpacing.lg),

            // Gaveta de Histórico Recente
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.xl,
                  AppSpacing.xl,
                  0,
                ),
                decoration: BoxDecoration(
                  color: colors.cardBackgroundAlt,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  border: Border(
                    top: BorderSide(
                      color: colors.borderSubtle,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    // Cabeçalho da Seção de Histórico
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(LucideIcons.history, color: colors.primary, size: 18),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Histórico recente',
                              style: GoogleFonts.lexend(
                                color: colors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            if (widget.onNavigateToTab != null) {
                              widget.onNavigateToTab!(2);
                            } else {
                              Navigator.pushNamed(context, Routes.viagens);
                            }
                          },
                          child: Text(
                            'Ver histórico',
                            style: GoogleFonts.lexend(
                              color: colors.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Lista de Viagens Recentes
                    Expanded(
                      child: homeVM.isLoading
                          ? const AppLoadingIndicator()
                          : homeVM.ultimasViagens.isEmpty
                              ? const AppEmptyState(
                                  icon: LucideIcons.truck,
                                  title: 'Nenhuma viagem encontrada',
                                  subtitle: 'Toque no botão acima para iniciar sua rota.',
                                )
                              : CustomRefreshIndicator(
                                  onRefresh: homeVM.refresh,
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(
                                      parent: AlwaysScrollableScrollPhysics(),
                                    ),
                                    itemCount: homeVM.ultimasViagens.length,
                                    itemBuilder: (context, index) {
                                      final viagem = homeVM.ultimasViagens[index];
                                      return ViagemCard(
                                        viagem: viagem,
                                        onTap: () => _navegarParaViagem(viagem),
                                      );
                                    },
                                  ),
                                ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
