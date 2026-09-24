// lib/features/despesas/widgets/despesas_filtro_categorias_bar.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';

// Barra de filtros com rolagem horizontal e chevrons indicadores para segmentar a visualização dos lançamentos de despesa.
class DespesasFiltroCategoriasBar extends StatefulWidget {
  final String filtroSelecionado;
  final ValueChanged<String> onFiltroChanged;

  const DespesasFiltroCategoriasBar({
    super.key,
    required this.filtroSelecionado,
    required this.onFiltroChanged,
  });

  @override
  State<DespesasFiltroCategoriasBar> createState() => _DespesasFiltroCategoriasBarState();
}

class _DespesasFiltroCategoriasBarState extends State<DespesasFiltroCategoriasBar> {
  final ScrollController _scrollController = ScrollController();
  bool _canScrollForward = true;
  bool _canScrollBackward = false;

  final List<Map<String, dynamic>> _categorias = const [
    {'codigo': 'TODOS', 'label': 'Todos', 'icon': LucideIcons.layers},
    {'codigo': 'ABASTECIMENTO', 'label': 'Abastecimento', 'icon': LucideIcons.fuel},
    {'codigo': 'ALIMENTACAO', 'label': 'Alimentação', 'icon': LucideIcons.utensils},
    {'codigo': 'PEDAGIO', 'label': 'Pedágio', 'icon': LucideIcons.receipt},
    {'codigo': 'MANUTENCAO', 'label': 'Manutenção', 'icon': LucideIcons.wrench},
    {'codigo': 'OUTROS', 'label': 'Outros', 'icon': LucideIcons.circleDot},
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkScrollability());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    final canForward = currentScroll < maxScroll - 8;
    final canBackward = currentScroll > 8;

    if (canForward != _canScrollForward || canBackward != _canScrollBackward) {
      setState(() {
        _canScrollForward = canForward;
        _canScrollBackward = canBackward;
      });
    }
  }

  void _checkScrollability() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (mounted) {
      setState(() {
        _canScrollForward = maxScroll > 8;
        _canScrollBackward = _scrollController.offset > 8;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: AppRadius.mdRadius,
          border: Border.all(color: colors.borderSubtle),
        ),
        child: ClipRRect(
          borderRadius: AppRadius.mdRadius,
          child: Stack(
            children: [
              ListView.separated(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
                physics: const BouncingScrollPhysics(),
                itemCount: _categorias.length,
                separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.xs),
                itemBuilder: (context, index) {
                  final cat = _categorias[index];
                  final isSelected = widget.filtroSelecionado == cat['codigo'];
                  final IconData iconData = cat['icon'] as IconData;

                  return GestureDetector(
                    onTap: () => widget.onFiltroChanged(cat['codigo'] as String),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? colors.primary : colors.surfaceOverlay,
                        borderRadius: AppRadius.smRadius,
                        border: Border.all(
                          color: isSelected ? colors.primary : colors.borderSubtle,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            iconData,
                            size: 14,
                            color: isSelected ? Colors.white : colors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            cat['label'] as String,
                            style: GoogleFonts.lexend(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? Colors.white : colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              if (_canScrollBackward)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () {
                      if (!_scrollController.hasClients) return;
                      final target = (_scrollController.offset - 130).clamp(0.0, _scrollController.position.maxScrollExtent);
                      _scrollController.animateTo(
                        target,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      );
                    },
                    child: Container(
                      width: 36,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            colors.cardBackground,
                            colors.cardBackground.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: colors.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(LucideIcons.chevronLeft, size: 14, color: colors.primary),
                        ),
                      ),
                    ),
                  ),
                ),
              if (_canScrollForward)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () {
                      if (!_scrollController.hasClients) return;
                      final target = (_scrollController.offset + 130).clamp(0.0, _scrollController.position.maxScrollExtent);
                      _scrollController.animateTo(
                        target,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      );
                    },
                    child: Container(
                      width: 38,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                            colors.cardBackground,
                            colors.cardBackground.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: colors.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(LucideIcons.chevronRight, size: 14, color: colors.primary),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
