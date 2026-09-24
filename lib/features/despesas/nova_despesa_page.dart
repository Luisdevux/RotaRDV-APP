// lib/features/despesas/nova_despesa_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/labeled_input_field.dart';
import '../../core/widgets/network_status_bar.dart';
import '../../core/widgets/odometer_input_field.dart';
import '../../models/viagem_collection.dart';
import '../home/home_viewmodel.dart';
import 'despesa_viewmodel.dart';
import 'widgets/categoria_selector_grid.dart';
import 'widgets/comprovante_picker_widget.dart';
import 'widgets/currency_input_field.dart';
import 'widgets/nova_despesa_categoria_banner.dart';

// Formulário para cadastro e auditoria de gastos operacionais e abastecimentos
// Implementa validação estrita de odômetro e proteção contra encerramento de processo Android
class NovaDespesaPage extends StatefulWidget {
  final String? viagemId;
  final CategoriaDespesa? initialCategoria;
  final File? fotoRecuperada;
  final double? initialValor;
  final String? initialLocal;
  final String? initialDescricao;
  final String? initialLitros;
  final String? initialKm;
  final String? initialCombustivel;

  const NovaDespesaPage({
    super.key,
    this.viagemId,
    this.initialCategoria,
    this.fotoRecuperada,
    this.initialValor,
    this.initialLocal,
    this.initialDescricao,
    this.initialLitros,
    this.initialKm,
    this.initialCombustivel,
  });

  @override
  State<NovaDespesaPage> createState() => _NovaDespesaPageState();
}

class _NovaDespesaPageState extends State<NovaDespesaPage> {
  CategoriaDespesa? _categoria;
  File? _comprovanteFile;
  bool _fotoTiradaNoApp = true;
  double _valorTotal = 0.0;

  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _localController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _litrosController = TextEditingController();
  final TextEditingController _kmAtualController = TextEditingController();

  String _tipoCombustivel = 'DIESEL_S10';

  @override
  void initState() {
    super.initState();
    _categoria = widget.initialCategoria;
    _inicializarCampos();
    _recuperarFotoSePendente();
  }

  void _inicializarCampos() {
    if (widget.fotoRecuperada != null) {
      _comprovanteFile = widget.fotoRecuperada;
      _fotoTiradaNoApp = true;
    }
    if (widget.initialValor != null && widget.initialValor! > 0) {
      _valorTotal = widget.initialValor!;
      final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '', decimalDigits: 2);
      _valorController.text = formatter.format(_valorTotal).trim();
    }
    if (widget.initialLocal?.isNotEmpty ?? false) {
      _localController.text = widget.initialLocal!;
    }
    if (widget.initialDescricao?.isNotEmpty ?? false) {
      _descricaoController.text = widget.initialDescricao!;
    }
    if (widget.initialLitros?.isNotEmpty ?? false) {
      _litrosController.text = widget.initialLitros!;
    }
    if (widget.initialKm?.isNotEmpty ?? false) {
      _kmAtualController.text = widget.initialKm!;
    }
    if (widget.initialCombustivel?.isNotEmpty ?? false) {
      _tipoCombustivel = widget.initialCombustivel!;
    }
  }

  Future<void> _recuperarFotoSePendente() async {
    final file = await _NovaDespesaDraftManager.recuperarFotoPerdida();
    if (file != null && mounted) {
      setState(() {
        _comprovanteFile = file;
        _fotoTiradaNoApp = true;
      });
    }
  }

  @override
  void dispose() {
    _valorController.dispose();
    _localController.dispose();
    _descricaoController.dispose();
    _litrosController.dispose();
    _kmAtualController.dispose();
    super.dispose();
  }

  String _obterTitulo() {
    if (_categoria == null) return 'Lançar despesa';
    return 'Lançar ${_categoria!.label.toLowerCase()}';
  }

  double? _parseNumero(String texto) {
    final limpo = texto.replaceAll('.', '').replaceAll(',', '.').trim();
    return double.tryParse(limpo);
  }

  String? _validarValorEmTempoReal() {
    if (_valorController.text.isNotEmpty && _valorTotal <= 0) {
      return 'O valor total deve ser maior que R\$ 0,00';
    }
    return null;
  }

  String? _validarLitrosEmTempoReal() {
    if (_categoria != CategoriaDespesa.abastecimento) return null;
    if (_litrosController.text.isEmpty) return null;
    final litros = _parseNumero(_litrosController.text);
    if (litros == null || litros <= 0) {
      return 'Litros devem ser maiores que zero';
    }
    return null;
  }

  String? _validarOdometroEmTempoReal(ViagemCollection? viagem) {
    if (_categoria != CategoriaDespesa.abastecimento) return null;
    if (_kmAtualController.text.isEmpty) return null;
    final km = _parseNumero(_kmAtualController.text);
    if (km == null || km <= 0) {
      return 'Informe uma quilometragem válida';
    }
    if (viagem != null && km < viagem.kmInicial) {
      return 'KM (${km.toInt()}) não pode ser menor que o início (${viagem.kmInicial.toInt()} KM)';
    }
    return null;
  }

  bool _isFormularioValido(ViagemCollection? viagem) {
    if (_valorTotal <= 0) return false;
    if (_categoria == CategoriaDespesa.abastecimento) {
      final litros = _parseNumero(_litrosController.text);
      if (litros == null || litros <= 0) return false;

      final km = _parseNumero(_kmAtualController.text);
      if (km == null || km <= 0) return false;
      if (viagem != null && km < viagem.kmInicial) return false;
    }
    return true;
  }

  String? _obterMensagemBloqueio(ViagemCollection? viagem) {
    if (_valorTotal <= 0) {
      return 'Informe o valor total da despesa para habilitar o salvamento.';
    }
    if (_categoria == CategoriaDespesa.abastecimento) {
      final litros = _parseNumero(_litrosController.text);
      if (litros == null || litros <= 0) {
        return 'Informe a quantidade de litros abastecidos.';
      }
      final km = _parseNumero(_kmAtualController.text);
      if (km == null || km <= 0) {
        return 'Informe a quilometragem atual do veículo.';
      }
      if (viagem != null && km < viagem.kmInicial) {
        return 'O odômetro (${km.toInt()} KM) é menor que o início da viagem (${viagem.kmInicial.toInt()} KM).';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final homeVM = context.watch<HomeViewModel>();
    final viagemAtiva = homeVM.ultimasViagens.where((v) => v.status == 'em_andamento').firstOrNull;
    final targetViagemId = widget.viagemId ?? viagemAtiva?.uuid;

    final ViagemCollection? viagemObj = homeVM.ultimasViagens.cast<ViagemCollection?>().firstWhere(
          (v) => v?.uuid == targetViagemId,
          orElse: () => null,
        );

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.headerBackground,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: colors.primary),
          onPressed: () => _aoPressionarVoltar(),
        ),
        title: Text(
          _obterTitulo(),
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
                padding: const EdgeInsets.all(AppSpacing.xxl),
                physics: const BouncingScrollPhysics(),
                child: targetViagemId == null
                    ? _buildSemViagemAtiva(context, colors)
                    : _categoria == null
                        ? _buildSelecaoCategoria(colors)
                        : _buildFormularioDespesa(context, targetViagemId, viagemObj, colors),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _aoPressionarVoltar() {
    if (_categoria != null && widget.initialCategoria == null) {
      setState(() => _categoria = null);
      return;
    }
    _NovaDespesaDraftManager.limpar();
    Navigator.pop(context);
  }

  Widget _buildSemViagemAtiva(BuildContext context, AppColorsExtension colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.huge),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: colors.warning.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(LucideIcons.alertTriangle, size: 48, color: colors.warning),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Nenhuma viagem em andamento',
              textAlign: TextAlign.center,
              style: GoogleFonts.lexend(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Para lançar uma despesa ou comprovante, você precisa primeiro iniciar uma viagem.',
              textAlign: TextAlign.center,
              style: GoogleFonts.lexend(
                fontSize: 14,
                color: colors.textMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.md),
              ),
              child: Text(
                'Voltar ao início',
                style: GoogleFonts.lexend(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelecaoCategoria(AppColorsExtension colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Qual foi o gasto?',
          style: GoogleFonts.lexend(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Selecione a categoria da despesa abaixo',
          style: GoogleFonts.lexend(fontSize: 14, color: colors.textMuted),
        ),
        const SizedBox(height: AppSpacing.xxl),
        CategoriaSelectorGrid(
          selectedCategoria: _categoria,
          onSelected: (cat) => setState(() => _categoria = cat),
        ),
      ],
    );
  }

  Widget _buildFormularioDespesa(
    BuildContext context,
    String viagemId,
    ViagemCollection? viagemObj,
    AppColorsExtension colors,
  ) {
    final despesaVM = context.watch<DespesaViewModel>();
    final isAbastecimento = _categoria == CategoriaDespesa.abastecimento;
    final erroValor = _validarValorEmTempoReal();
    final erroLitros = _validarLitrosEmTempoReal();
    final erroKm = _validarOdometroEmTempoReal(viagemObj);
    final formValido = _isFormularioValido(viagemObj);
    final motivoBloqueio = _obterMensagemBloqueio(viagemObj);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NovaDespesaCategoriaBanner(
          categoria: _categoria!,
          podeTrocar: widget.initialCategoria == null,
          onTrocar: () => setState(() => _categoria = null),
        ),
        const SizedBox(height: AppSpacing.xl),

        CurrencyInputField(
          label: r'Valor total (R$) *',
          controller: _valorController,
          helperText: 'Digite o valor total pago na nota fiscal',
          errorText: erroValor,
          onValueChanged: (val) => setState(() => _valorTotal = val),
        ),
        const SizedBox(height: AppSpacing.xl),

        if (isAbastecimento) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: LabeledInputField(
                  label: 'Litros',
                  icon: LucideIcons.fuel,
                  controller: _litrosController,
                  hintText: '0.00',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  errorText: erroLitros,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: OdometerInputField(
                  label: 'KM atual',
                  icon: LucideIcons.gauge,
                  controller: _kmAtualController,
                  hintText: '000.000',
                  errorText: erroKm,
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildSeletorCombustivel(colors),
          const SizedBox(height: AppSpacing.xl),
        ],

        LabeledInputField(
          label: isAbastecimento ? 'Posto de combustível' : 'Local ou estabelecimento',
          icon: LucideIcons.mapPin,
          controller: _localController,
          hintText: isAbastecimento ? 'Ex: Posto Ipiranga Rodo' : 'Ex: Restaurante do Gaúcho',
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: AppSpacing.xl),

        LabeledInputField(
          label: 'Observações (opcional)',
          icon: LucideIcons.fileText,
          controller: _descricaoController,
          hintText: 'Ex: Troca de óleo de filtro, almoço...',
        ),
        const SizedBox(height: AppSpacing.xl),

        _buildCabecalhoComprovante(colors),
        const SizedBox(height: AppSpacing.sm),
        ComprovantePickerWidget(
          selectedImage: _comprovanteFile,
          onBeforePickImage: () => _salvarRascunhoAntesDaCamera(viagemId),
          onImageChanged: (file, isCamera) {
            setState(() {
              _comprovanteFile = file;
              _fotoTiradaNoApp = isCamera;
            });
          },
        ),
        const SizedBox(height: AppSpacing.huge),

        if (!formValido && motivoBloqueio != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: colors.error.withValues(alpha: 0.08),
              borderRadius: AppRadius.mdRadius,
              border: Border.all(color: colors.error.withValues(alpha: 0.25)),
            ),
            child: Row(
              children: [
                Icon(LucideIcons.alertTriangle, size: 16, color: colors.error),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    motivoBloqueio,
                    style: GoogleFonts.lexend(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: colors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        ElevatedButton(
          onPressed: (!formValido || despesaVM.isLoading)
              ? null
              : () => _salvar(context, viagemId, viagemObj, colors),
          style: ElevatedButton.styleFrom(
            backgroundColor: formValido ? colors.primary : colors.surfaceOverlay,
            disabledBackgroundColor: colors.surfaceOverlay,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
            elevation: 0,
          ),
          child: despesaVM.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      formValido ? LucideIcons.checkCircle2 : LucideIcons.lock,
                      color: formValido ? Colors.white : colors.textHint,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Salvar despesa',
                      style: GoogleFonts.lexend(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: formValido ? Colors.white : colors.textHint,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildSeletorCombustivel(AppColorsExtension colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(LucideIcons.fuel, color: colors.primary, size: 18),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Tipo de combustível',
              style: GoogleFonts.lexend(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 2),
          decoration: BoxDecoration(
            color: colors.inputBackground,
            borderRadius: AppRadius.lgRadius,
            border: Border.all(color: colors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _tipoCombustivel,
              isExpanded: true,
              dropdownColor: colors.cardBackground,
              style: GoogleFonts.lexend(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
              icon: Icon(LucideIcons.chevronDown, color: colors.textMuted),
              items: const [
                DropdownMenuItem(value: 'DIESEL_S10', child: Text('Diesel S10')),
                DropdownMenuItem(value: 'DIESEL_S500', child: Text('Diesel S500')),
                DropdownMenuItem(value: 'ARLA_32', child: Text('Arla 32')),
                DropdownMenuItem(value: 'GASOLINA', child: Text('Gasolina')),
                DropdownMenuItem(value: 'ETANOL', child: Text('Etanol')),
                DropdownMenuItem(value: 'OUTRO', child: Text('Outro')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _tipoCombustivel = val);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCabecalhoComprovante(AppColorsExtension colors) {
    return Row(
      children: [
        Icon(LucideIcons.camera, color: colors.primary, size: 18),
        const SizedBox(width: AppSpacing.sm),
        Text(
          'Foto do comprovante ou cupom fiscal',
          style: GoogleFonts.lexend(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }

  Future<void> _salvarRascunhoAntesDaCamera(String viagemId) {
    return _NovaDespesaDraftManager.salvar(
      viagemId: viagemId,
      categoria: _categoria?.name,
      valorTotal: _valorTotal,
      local: _localController.text,
      descricao: _descricaoController.text,
      litros: _litrosController.text,
      km: _kmAtualController.text,
      combustivel: _tipoCombustivel,
    );
  }

  Future<void> _salvar(
    BuildContext context,
    String viagemId,
    ViagemCollection? viagemObj,
    AppColorsExtension colors,
  ) async {
    final despesaVM = context.read<DespesaViewModel>();
    final double? litros = _parseNumero(_litrosController.text);
    final double? kmAtual = _parseNumero(_kmAtualController.text);

    // Validação centralizada de domínio
    final erroValidacao = DespesaViewModel.validarLancamento(
      valorTotal: _valorTotal,
      tipo: _categoria!.codigo,
      viagem: viagemObj,
      litros: litros,
      kmAtual: kmAtual,
    );

    if (erroValidacao != null) {
      _exibirAlerta(context, erroValidacao, colors.warning);
      return;
    }

    final sucesso = await despesaVM.salvarDespesa(
      viagemId: viagemId,
      tipo: _categoria!.codigo,
      valorTotal: _valorTotal,
      data: DateTime.now(),
      local: _localController.text.trim(),
      descricao: _descricaoController.text.trim(),
      comprovanteFile: _comprovanteFile,
      fotoTiradaNoApp: _fotoTiradaNoApp,
      litros: litros,
      valorLitro: (litros != null && litros > 0) ? (_valorTotal / litros) : null,
      tipoCombustivel: _categoria == CategoriaDespesa.abastecimento ? _tipoCombustivel : null,
      kmAtual: kmAtual,
    );

    if (!context.mounted) return;

    if (!sucesso) {
      _exibirAlerta(context, despesaVM.errorMessage ?? 'Falha ao salvar a despesa.', colors.error);
      return;
    }

    _exibirAlerta(context, 'Despesa registrada com sucesso!', colors.success);
    await _NovaDespesaDraftManager.limpar();
    if (!context.mounted) return;
    Navigator.pop(context);
  }

  void _exibirAlerta(BuildContext context, String mensagem, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: cor,
      ),
    );
  }
}

// Gerenciador isolado para guardar e recuperar dados digitados quando o sistema operacional descarta a Activity da câmera
abstract class _NovaDespesaDraftManager {
  static Future<void> salvar({
    required String viagemId,
    required String? categoria,
    required double valorTotal,
    required String local,
    required String descricao,
    required String litros,
    required String km,
    required String combustivel,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('despesa_draft_viagem_id', viagemId);
      if (categoria != null) {
        await prefs.setString('despesa_draft_categoria', categoria);
      }
      await prefs.setDouble('despesa_draft_valor', valorTotal);
      await prefs.setString('despesa_draft_local', local);
      await prefs.setString('despesa_draft_descricao', descricao);
      await prefs.setString('despesa_draft_litros', litros);
      await prefs.setString('despesa_draft_km', km);
      await prefs.setString('despesa_draft_combustivel', combustivel);
    } catch (e) {
      debugPrint('[_NovaDespesaDraftManager] Erro ao salvar rascunho: $e');
    }
  }

  static Future<void> limpar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      const chaves = [
        'despesa_draft_viagem_id',
        'despesa_draft_categoria',
        'despesa_draft_valor',
        'despesa_draft_local',
        'despesa_draft_descricao',
        'despesa_draft_litros',
        'despesa_draft_km',
        'despesa_draft_combustivel',
      ];
      for (final chave in chaves) {
        await prefs.remove(chave);
      }
    } catch (e) {
      debugPrint('[_NovaDespesaDraftManager] Erro ao limpar rascunho: $e');
    }
  }

  static Future<File?> recuperarFotoPerdida() async {
    try {
      final picker = ImagePicker();
      final LostDataResponse response = await picker.retrieveLostData();
      if (!response.isEmpty && response.file != null) {
        return File(response.file!.path);
      }
    } catch (e) {
      debugPrint('[_NovaDespesaDraftManager] Erro ao recuperar foto perdida: $e');
    }
    return null;
  }
}
