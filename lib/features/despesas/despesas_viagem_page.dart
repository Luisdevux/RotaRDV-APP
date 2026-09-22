import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/custom_refresh_indicator.dart';
import '../../core/widgets/network_status_bar.dart';
import '../../models/despesa_collection.dart';
import '../../models/viagem_collection.dart';
import '../home/home_viewmodel.dart';
import 'despesa_viewmodel.dart';
import 'nova_despesa_page.dart';
import 'widgets/comprovante_viewer_modal.dart';
import 'widgets/despesa_card.dart';
import 'widgets/despesas_filtro_categorias_bar.dart';
import 'widgets/despesas_resumo_gastos_card.dart';

/*──────────────────────────────────────────────────────────────*/
/* TELA: RELATÓRIO E GERENCIAMENTO DE DESPESAS DA VIAGEM        */
/*──────────────────────────────────────────────────────────────*/

/// Página responsável por consolidar e listar todas as despesas lançadas
/// para uma determinada rota, permitindo filtragem por categoria e novo registro.
class DespesasViagemPage extends StatefulWidget {
  final ViagemCollection? viagem;
  final String? viagemId;
  final bool isTab;

  const DespesasViagemPage({
    super.key,
    this.viagem,
    this.viagemId,
    this.isTab = false,
  });

  @override
  State<DespesasViagemPage> createState() => _DespesasViagemPageState();
}

class _DespesasViagemPageState extends State<DespesasViagemPage> {
  String _filtroTipo = 'TODOS';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _carregar());
  }

  void _carregar() {
    final homeVM = context.read<HomeViewModel>();
    final viagemAtiva = homeVM.ultimasViagens.where((v) => v.status == 'em_andamento').firstOrNull;
    final targetId = widget.viagemId ?? widget.viagem?.uuid ?? viagemAtiva?.uuid;

    if (targetId != null) {
      context.read<DespesaViewModel>().carregarDespesas(targetId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final homeVM = context.watch<HomeViewModel>();
    final viagemAtiva = homeVM.ultimasViagens.where((v) => v.status == 'em_andamento').firstOrNull;
    final targetViagemId = widget.viagemId ?? widget.viagem?.uuid ?? viagemAtiva?.uuid;

    final ViagemCollection? viagemObj = widget.viagem ??
        homeVM.ultimasViagens.cast<ViagemCollection?>().firstWhere(
              (v) => v?.uuid == targetViagemId,
              orElse: () => null,
            );

    final isViagemFinalizada = viagemObj != null &&
        (viagemObj.status == 'concluida' ||
            viagemObj.status == 'cancelada' ||
            viagemObj.status == ViagemStatus.concluida ||
            viagemObj.status == ViagemStatus.cancelada);

    final despesaVM = context.watch<DespesaViewModel>();

    final List<DespesaCollection> despesasFiltradas = _filtroTipo == 'TODOS'
        ? despesaVM.despesas
        : despesaVM.despesas.where((d) => d.tipo == _filtroTipo).toList();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: widget.isTab
          ? null
          : AppBar(
              backgroundColor: colors.headerBackground,
              elevation: 0,
              centerTitle: false,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(LucideIcons.arrowLeft, color: colors.primary),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Despesas da viagem',
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
              child: targetViagemId == null
                  ? _buildSemViagemAtiva(colors)
                  : CustomRefreshIndicator(
                      onRefresh: () async => _carregar(),
                      child: Column(
                        children: [
                          // Header com Resumo de Gastos e Eficiência
                          DespesasResumoGastosCard(
                            despesaVM: despesaVM,
                            viagem: viagemObj,
                          ),

                          const SizedBox(height: AppSpacing.sm),

                          // Filtro por Categoria
                          DespesasFiltroCategoriasBar(
                            filtroSelecionado: _filtroTipo,
                            onFiltroChanged: (cat) {
                              setState(() {
                                _filtroTipo = cat;
                              });
                            },
                          ),

                          const SizedBox(height: AppSpacing.sm),

                          // Lista de Despesas
                          Expanded(
                            child: despesasFiltradas.isEmpty
                                ? _buildListaVazia(colors, isViagemFinalizada)
                                : ListView.builder(
                                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                    padding: const EdgeInsets.all(AppSpacing.lg),
                                    itemCount: despesasFiltradas.length,
                                    itemBuilder: (context, index) {
                                      final despesa = despesasFiltradas[index];
                                      return DespesaCard(
                                        despesa: despesa,
                                        onTap: () {
                                          ComprovanteViewerModal.show(
                                            context,
                                            despesa: despesa,
                                          );
                                        },
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: (!isViagemFinalizada && targetViagemId != null)
          ? FloatingActionButton.extended(
              heroTag: 'fab_despesas',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NovaDespesaPage(viagemId: targetViagemId),
                  ),
                ).then((_) => _carregar());
              },
              backgroundColor: colors.primary,
              icon: const Icon(LucideIcons.plus, color: Colors.white),
              label: Text(
                'Lançar despesa',
                style: GoogleFonts.lexend(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildListaVazia(AppColorsExtension colors, bool isViagemFinalizada) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: colors.surfaceOverlay,
                  shape: BoxShape.circle,
                ),
                child: Icon(LucideIcons.receiptText, size: 44, color: colors.textHint),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Nenhum gasto registrado',
                style: GoogleFonts.lexend(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                _filtroTipo == 'TODOS'
                    ? (isViagemFinalizada
                        ? 'Nenhuma despesa foi registrada nesta viagem.'
                        : 'Toque no botão abaixo para lançar uma despesa.')
                    : 'Nenhuma despesa encontrada para esta categoria.',
                textAlign: TextAlign.center,
                style: GoogleFonts.lexend(
                  fontSize: 13,
                  color: colors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSemViagemAtiva(AppColorsExtension colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: colors.warning.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(LucideIcons.truck, size: 48, color: colors.warning),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Nenhuma viagem ativa',
              style: GoogleFonts.lexend(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Para visualizar ou lançar despesas, inicie uma nova viagem na tela de viagens.',
              textAlign: TextAlign.center,
              style: GoogleFonts.lexend(
                fontSize: 14,
                color: colors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
