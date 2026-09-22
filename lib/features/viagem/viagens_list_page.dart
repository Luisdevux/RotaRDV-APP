import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/custom_refresh_indicator.dart';
import '../../core/widgets/network_status_bar.dart';
import '../../models/viagem_collection.dart';
import '../home/home_viewmodel.dart';
import 'detalhes_viagem_page.dart';
import 'widgets/viagem_card.dart';

/*──────────────────────────────────────────────────────────────*/
/* TELA: HISTÓRICO GERAL E CONSULTA DE VIAGENS                  */
/*──────────────────────────────────────────────────────────────*/

/// Página responsável por listar o histórico completo de viagens do condutor,
/// com suporte a pesquisa por texto (cidade/UF) e filtros por período e status operacional.
class ViagensListPage extends StatefulWidget {
  final bool isTab;
  final ValueChanged<int>? onNavigateToTab;

  const ViagensListPage({
    super.key,
    this.isTab = false,
    this.onNavigateToTab,
  });

  @override
  State<ViagensListPage> createState() => _ViagensListPageState();
}

class _ViagensListPageState extends State<ViagensListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _filtroPeriodo;
  String _filtroStatus = 'TODOS';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matchesPeriodo(DateTime dt) {
    if (_filtroPeriodo == null || _filtroPeriodo == 'todos') return true;

    final now = DateTime.now();
    final localDt = dt.toLocal();

    if (_filtroPeriodo == 'este_mes') {
      return localDt.year == now.year && localDt.month == now.month;
    } else if (_filtroPeriodo == 'mes_passado') {
      final prevMonthYear = now.month == 1 ? now.year - 1 : now.year;
      final prevMonth = now.month == 1 ? 12 : now.month - 1;
      return localDt.year == prevMonthYear && localDt.month == prevMonth;
    }
    return true;
  }

  bool _matchesStatus(String status) {
    if (_filtroStatus == 'TODOS') return true;
    if (_filtroStatus == 'concluida') {
      return status == 'concluida' || status == 'concluída';
    }
    return status == _filtroStatus;
  }

  bool _matchesSearch(ViagemCollection viagem) {
    if (_searchQuery.isEmpty) return true;
    final origem = '${viagem.origemCidade} ${viagem.origemEstado}'.toLowerCase();
    final destino = '${viagem.destinoCidade} ${viagem.destinoEstado}'.toLowerCase();
    return origem.contains(_searchQuery) || destino.contains(_searchQuery);
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'concluida':
        return 'Concluídas';
      case 'em_andamento':
        return 'Em andamento';
      case 'cancelada':
        return 'Canceladas';
      default:
        return 'Status';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final homeVM = context.watch<HomeViewModel>();
    final todasViagens = homeVM.ultimasViagens;

    final viagensFiltradas = todasViagens.where((v) {
      return _matchesSearch(v) && _matchesStatus(v.status) && _matchesPeriodo(v.dataInicio);
    }).toList();

    final bool isPeriodoAtivo = _filtroPeriodo != null && _filtroPeriodo != 'todos';
    final bool isStatusAtivo = _filtroStatus != 'TODOS';

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
          'Histórico de viagens',
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
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 0),
              child: Column(
                children: [
                  // Campo de Pesquisa
                  Container(
                    decoration: BoxDecoration(
                      color: colors.inputBackground,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colors.borderSubtle),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: GoogleFonts.lexend(fontSize: 14, color: colors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Buscar por cidade ou estado...',
                        hintStyle: GoogleFonts.lexend(fontSize: 13, color: colors.textHint),
                        prefixIcon: Icon(LucideIcons.search, size: 18, color: colors.textHint),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(LucideIcons.x, size: 16, color: colors.textHint),
                                onPressed: () {
                                  _searchController.clear();
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Filtros por Período e Status
                  Row(
                    children: [
                      PopupMenuButton<String>(
                        onSelected: (val) {
                          setState(() {
                            _filtroPeriodo = val;
                          });
                        },
                        color: colors.cardBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: colors.borderSubtle),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'todos',
                            child: Text(
                              'Todas as datas (limpar)',
                              style: GoogleFonts.lexend(
                                color: !isPeriodoAtivo ? colors.primary : colors.textPrimary,
                                fontWeight: !isPeriodoAtivo ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'este_mes',
                            child: Text(
                              'Este mês',
                              style: GoogleFonts.lexend(
                                color: _filtroPeriodo == 'este_mes' ? colors.primary : colors.textPrimary,
                                fontWeight: _filtroPeriodo == 'este_mes' ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'mes_passado',
                            child: Text(
                              'Mês passado',
                              style: GoogleFonts.lexend(
                                color: _filtroPeriodo == 'mes_passado' ? colors.primary : colors.textPrimary,
                                fontWeight: _filtroPeriodo == 'mes_passado' ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isPeriodoAtivo
                                ? colors.primary.withValues(alpha: 0.15)
                                : colors.cardBackground,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isPeriodoAtivo ? colors.primary : colors.borderSubtle,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                isPeriodoAtivo
                                    ? (_filtroPeriodo == 'este_mes' ? 'Este mês' : 'Mês passado')
                                    : 'Período',
                                style: GoogleFonts.lexend(
                                  fontSize: 13,
                                  fontWeight: isPeriodoAtivo ? FontWeight.bold : FontWeight.w500,
                                  color: isPeriodoAtivo ? colors.primary : colors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                LucideIcons.chevronDown,
                                size: 14,
                                color: isPeriodoAtivo ? colors.primary : colors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),

                      PopupMenuButton<String>(
                        onSelected: (val) {
                          setState(() {
                            _filtroStatus = val;
                          });
                        },
                        color: colors.cardBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: colors.borderSubtle),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'TODOS',
                            child: Text(
                              'Todos os status (limpar)',
                              style: GoogleFonts.lexend(
                                color: !isStatusAtivo ? colors.primary : colors.textPrimary,
                                fontWeight: !isStatusAtivo ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'concluida',
                            child: Text(
                              'Concluídas',
                              style: GoogleFonts.lexend(
                                color: _filtroStatus == 'concluida' ? colors.primary : colors.textPrimary,
                                fontWeight: _filtroStatus == 'concluida' ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'em_andamento',
                            child: Text(
                              'Em andamento',
                              style: GoogleFonts.lexend(
                                color: _filtroStatus == 'em_andamento' ? colors.primary : colors.textPrimary,
                                fontWeight: _filtroStatus == 'em_andamento' ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'cancelada',
                            child: Text(
                              'Canceladas',
                              style: GoogleFonts.lexend(
                                color: _filtroStatus == 'cancelada' ? colors.primary : colors.textPrimary,
                                fontWeight: _filtroStatus == 'cancelada' ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isStatusAtivo
                                ? colors.primary.withValues(alpha: 0.15)
                                : colors.cardBackground,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isStatusAtivo ? colors.primary : colors.borderSubtle,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                isStatusAtivo ? _getStatusLabel(_filtroStatus) : 'Status',
                                style: GoogleFonts.lexend(
                                  fontSize: 13,
                                  fontWeight: isStatusAtivo ? FontWeight.bold : FontWeight.w500,
                                  color: isStatusAtivo ? colors.primary : colors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                LucideIcons.chevronDown,
                                size: 14,
                                color: isStatusAtivo ? colors.primary : colors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${viagensFiltradas.length} ${viagensFiltradas.length == 1 ? "viagem" : "viagens"}',
                        style: GoogleFonts.lexend(
                          fontSize: 12,
                          color: colors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            Expanded(
              child: viagensFiltradas.isEmpty
                  ? _buildListaVazia(colors)
                  : CustomRefreshIndicator(
                      onRefresh: homeVM.refresh,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                        itemCount: viagensFiltradas.length,
                        itemBuilder: (context, index) {
                          final viagem = viagensFiltradas[index];
                          return ViagemCard(
                            viagem: viagem,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetalhesViagemPage(viagem: viagem),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListaVazia(AppColorsExtension colors) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: colors.surfaceOverlay,
                  shape: BoxShape.circle,
                ),
                child: Icon(LucideIcons.searchX, size: 36, color: colors.textHint),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Nenhuma viagem encontrada',
                style: GoogleFonts.lexend(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                _searchQuery.isNotEmpty
                    ? 'Nenhum resultado para "$_searchQuery".'
                    : 'Tente alterar os filtros de período ou status acima.',
                textAlign: TextAlign.center,
                style: GoogleFonts.lexend(
                  fontSize: 12,
                  color: colors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
