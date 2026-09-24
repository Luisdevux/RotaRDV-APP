import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/network_status_bar.dart';
import '../../models/viagem_collection.dart';
import '../despesas/despesa_viewmodel.dart';
import '../despesas/despesas_viagem_page.dart';
import '../despesas/nova_despesa_page.dart';
import '../despesas/widgets/comprovante_viewer_modal.dart';
import '../despesas/widgets/despesa_card.dart';
import '../home/home_viewmodel.dart';
import 'encerrar_viagem_page.dart';
import 'widgets/viagem_bottom_actions.dart';
import 'widgets/viagem_consumo_card.dart';
import 'widgets/viagem_odometro_resumo_card.dart';
import 'widgets/viagem_rota_card.dart';

// Página responsável por exibir a visão consolidada da viagem selecionada: trajeto de origem/destino, indicadores de consumo, registros financeiros de despesas e controles de encerramento da rota
class DetalhesViagemPage extends StatefulWidget {
  final ViagemCollection viagem;
  final bool isTab;
  final ValueChanged<int>? onNavigateToTab;

  const DetalhesViagemPage({
    super.key,
    required this.viagem,
    this.isTab = false,
    this.onNavigateToTab,
  });

  @override
  State<DetalhesViagemPage> createState() => _DetalhesViagemPageState();
}

class _DetalhesViagemPageState extends State<DetalhesViagemPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DespesaViewModel>().carregarDespesas(widget.viagem.uuid);
      }
    });
  }

  void _navegarParaEncerrarViagem() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EncerrarViagemPage(viagem: widget.viagem),
      ),
    );
  }

  void _navegarParaNovaDespesa() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NovaDespesaPage(viagemId: widget.viagem.uuid),
      ),
    ).then((_) {
      if (mounted) {
        context.read<DespesaViewModel>().carregarDespesas(widget.viagem.uuid);
      }
    });
  }

  void _navegarParaTodasDespesas() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DespesasViagemPage(
          viagem: widget.viagem,
          viagemId: widget.viagem.uuid,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final homeVM = context.watch<HomeViewModel>();
    final veiculo = homeVM.veiculo;
    final despesaVM = context.watch<DespesaViewModel>();
    final isEmAndamento = widget.viagem.status == 'em_andamento';
    final ultimasDespesas = despesaVM.despesas.take(4).toList();

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
            if (widget.isTab && widget.onNavigateToTab != null) {
              widget.onNavigateToTab!(0);
            } else if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          'Gerenciar viagem',
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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ViagemRotaCard(
                      viagem: widget.viagem,
                      veiculo: veiculo,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    ViagemOdometroResumoCard(
                      viagem: widget.viagem,
                      despesaVM: despesaVM,
                      onVerDespesas: _navegarParaTodasDespesas,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    ViagemConsumoCard(
                      viagem: widget.viagem,
                      despesaVM: despesaVM,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Seção de Lançamentos da Rota
                    _buildSecaoLancamentos(
                      colors: colors,
                      despesaVM: despesaVM,
                      ultimasDespesas: ultimasDespesas,
                    ),
                    const SizedBox(height: AppSpacing.huge),
                  ],
                ),
              ),
            ),
            if (isEmAndamento)
              ViagemBottomActions(
                onEncerrarViagem: _navegarParaEncerrarViagem,
                onLancarDespesa: _navegarParaNovaDespesa,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecaoLancamentos({
    required AppColorsExtension colors,
    required DespesaViewModel despesaVM,
    required List<dynamic> ultimasDespesas,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Lançamentos da rota',
                  style: GoogleFonts.lexend(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: colors.textSecondary,
                  ),
                ),
                if (despesaVM.despesas.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: colors.surfaceOverlay,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${despesaVM.despesas.length}',
                      style: GoogleFonts.lexend(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (despesaVM.despesas.isNotEmpty)
              TextButton(
                onPressed: _navegarParaTodasDespesas,
                child: Row(
                  children: [
                    Text(
                      'Ver todas',
                      style: GoogleFonts.lexend(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(LucideIcons.chevronRight, size: 14, color: colors.primary),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        if (ultimasDespesas.isEmpty)
          AppCard(
            backgroundColor: colors.cardBackground,
            borderColor: colors.borderSubtle,
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: colors.surfaceOverlay,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(LucideIcons.receiptText, size: 36, color: colors.textHint),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Nenhuma despesa lançada nesta viagem',
                    style: GoogleFonts.lexend(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Toque no botão abaixo para lançar abastecimento, pedágio ou refeição.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lexend(
                      fontSize: 12,
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...ultimasDespesas.map(
            (d) => DespesaCard(
              despesa: d,
              onTap: () {
                ComprovanteViewerModal.show(
                  context,
                  despesa: d,
                );
              },
            ),
          ),
      ],
    );
  }
}
