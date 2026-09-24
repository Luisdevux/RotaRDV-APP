// lib/core/widgets/cidade_estado_picker.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/app_theme.dart';
import '../../services/estado_cidade_service.dart';

class CidadeEstadoPicker extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? cidade;
  final String? uf;
  final String hintCidade;
  final String hintUF;
  final Function(String cidade, String uf) onSelected;

  const CidadeEstadoPicker({
    super.key,
    required this.label,
    required this.icon,
    required this.cidade,
    required this.uf,
    this.hintCidade = 'Selecione a cidade',
    this.hintUF = 'UF',
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bool hasValue = (cidade != null && cidade!.isNotEmpty) && (uf != null && uf!.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: colors.primary, size: 18),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: GoogleFonts.lexend(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        InkWell(
          onTap: () => _openPicker(context),
          borderRadius: AppRadius.lgRadius,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: colors.inputBackground,
              border: Border.all(
                color: colors.border,
              ),
              borderRadius: AppRadius.lgRadius,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    hasValue ? cidade! : hintCidade,
                    style: GoogleFonts.lexend(
                      fontSize: 16,
                      fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
                      color: hasValue ? colors.textPrimary : colors.textHint,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: colors.cardBackground,
                    borderRadius: AppRadius.smRadius,
                    border: Border.all(color: colors.borderSubtle),
                  ),
                  child: Text(
                    hasValue ? uf! : hintUF,
                    style: GoogleFonts.lexend(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: hasValue ? colors.textPrimary : colors.textMuted,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Icon(LucideIcons.chevronDown, color: colors.textHint, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _openPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CidadeEstadoBottomSheet(
        titulo: label,
        estadoInicial: uf,
        onSelected: onSelected,
      ),
    );
  }
}

class _CidadeEstadoBottomSheet extends StatefulWidget {
  final String titulo;
  final String? estadoInicial;
  final Function(String cidade, String uf) onSelected;

  const _CidadeEstadoBottomSheet({
    required this.titulo,
    this.estadoInicial,
    required this.onSelected,
  });

  @override
  State<_CidadeEstadoBottomSheet> createState() => _CidadeEstadoBottomSheetState();
}

enum _Step { selecionarEstado, selecionarCidade }

class _CidadeEstadoBottomSheetState extends State<_CidadeEstadoBottomSheet> {
  final EstadoCidadeService _service = EstadoCidadeService();
  final TextEditingController _searchController = TextEditingController();

  _Step _currentStep = _Step.selecionarEstado;
  Map<String, dynamic>? _selectedEstado;

  List<Map<String, dynamic>> _filteredEstados = [];
  List<Map<String, dynamic>> _filteredCidades = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await _service.loadEstadosECidades();
    _filterList();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterList() {
    final query = _searchController.text.trim().toLowerCase();

    if (_currentStep == _Step.selecionarEstado) {
      final todosEstados = _service.getEstados();
      if (query.isEmpty) {
        _filteredEstados = todosEstados;
      } else {
        _filteredEstados = todosEstados.where((e) {
          final nome = e['name'].toString().toLowerCase();
          final sigla = e['sigla'].toString().toLowerCase();
          return nome.contains(query) || sigla.contains(query);
        }).toList();
      }
    } else {
      if (_selectedEstado != null) {
        final sigla = _selectedEstado!['sigla'] as String;
        if (query.isEmpty) {
          _filteredCidades = _service.getCidadesPorEstado(sigla);
        } else {
          _filteredCidades = _service.buscarCidades(query, estadoSigla: sigla);
        }
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: colors.border, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            child: Row(
              children: [
                if (_currentStep == _Step.selecionarCidade)
                  IconButton(
                    icon: Icon(LucideIcons.arrowLeft, color: colors.primary, size: 22),
                    onPressed: () {
                      setState(() {
                        _currentStep = _Step.selecionarEstado;
                        _searchController.clear();
                        _filterList();
                      });
                    },
                  )
                else
                  const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentStep == _Step.selecionarEstado
                            ? '1. Escolha o Estado (UF)'
                            : '2. Escolha a Cidade (${_selectedEstado?['sigla']})',
                        style: GoogleFonts.lexend(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                      ),
                      Text(
                        _currentStep == _Step.selecionarEstado
                            ? 'Para onde é o seu destino ou ponto de partida?'
                            : 'Cidades de ${_selectedEstado?['name']}',
                        style: GoogleFonts.lexend(
                          fontSize: 12,
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(LucideIcons.x, color: colors.textHint, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            child: Container(
              decoration: BoxDecoration(
                color: colors.inputBackground,
                borderRadius: AppRadius.mdRadius,
                border: Border.all(color: colors.border),
              ),
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.lexend(color: colors.textPrimary, fontSize: 15),
                decoration: InputDecoration(
                  hintText: _currentStep == _Step.selecionarEstado
                      ? 'Filtrar estado (ex: MT, Mato Grosso)...'
                      : 'Filtrar cidade...',
                  hintStyle: GoogleFonts.lexend(color: colors.textHint, fontSize: 14),
                  prefixIcon: Icon(LucideIcons.search, color: colors.primary, size: 18),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(LucideIcons.x, color: colors.textHint, size: 16),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _filterList();
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  filled: false,
                ),
                onChanged: (val) {
                  setState(() {
                    _filterList();
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 4),
          Divider(color: colors.border, height: 1),

          // Content List
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: colors.primary))
                : _currentStep == _Step.selecionarEstado
                    ? _buildEstadosList(colors)
                    : _buildCidadesList(colors),
          ),
        ],
      ),
    );
  }

  Widget _buildEstadosList(AppColorsExtension colors) {
    if (_filteredEstados.isEmpty) {
      return Center(
        child: Text(
          'Nenhum estado encontrado',
          style: GoogleFonts.lexend(color: colors.textMuted, fontSize: 14),
        ),
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      itemCount: _filteredEstados.length,
      separatorBuilder: (context, index) => Divider(color: colors.borderSubtle, height: 1),
      itemBuilder: (context, index) {
        final estado = _filteredEstados[index];
        final nome = estado['name'] as String;
        final sigla = estado['sigla'] as String;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          leading: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.primary.withValues(alpha: 0.25)),
            ),
            child: Text(
              sigla,
              style: GoogleFonts.lexend(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colors.primary,
              ),
            ),
          ),
          title: Text(
            nome,
            style: GoogleFonts.lexend(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          trailing: Icon(LucideIcons.chevronRight, color: colors.textHint, size: 18),
          onTap: () {
            setState(() {
              _selectedEstado = estado;
              _currentStep = _Step.selecionarCidade;
              _searchController.clear();
              _filterList();
            });
          },
        );
      },
    );
  }

  Widget _buildCidadesList(AppColorsExtension colors) {
    if (_filteredCidades.isEmpty) {
      return Center(
        child: Text(
          'Nenhuma cidade encontrada em ${_selectedEstado?['sigla']}',
          style: GoogleFonts.lexend(color: colors.textMuted, fontSize: 14),
        ),
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      itemCount: _filteredCidades.length,
      separatorBuilder: (context, index) => Divider(color: colors.borderSubtle, height: 1),
      itemBuilder: (context, index) {
        final cidadeItem = _filteredCidades[index];
        final nomeCidade = cidadeItem['name'] as String;
        final sigla = _selectedEstado?['sigla'] as String? ?? '';

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.surfaceOverlay,
              borderRadius: AppRadius.smRadius,
            ),
            child: Icon(LucideIcons.mapPin, color: colors.primary, size: 18),
          ),
          title: Text(
            nomeCidade,
            style: GoogleFonts.lexend(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: colors.surfaceOverlay,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: colors.border),
            ),
            child: Text(
              sigla,
              style: GoogleFonts.lexend(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: colors.primary,
              ),
            ),
          ),
          onTap: () {
            widget.onSelected(nomeCidade, sigla);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
