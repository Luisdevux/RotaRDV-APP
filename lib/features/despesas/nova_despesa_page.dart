// lib/features/despesas/nova_despesa_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/labeled_input_field.dart';
import '../../core/widgets/liters_input_field.dart';
import '../../core/widgets/network_status_bar.dart';
import '../../core/widgets/odometer_input_field.dart';
import '../../models/viagem_collection.dart';
import '../auth/auth_viewmodel.dart';
import '../home/home_viewmodel.dart';
import 'despesa_viewmodel.dart';
import 'nova_despesa_draft_manager.dart';
import 'nova_despesa_field_helper.dart';
import 'nova_despesa_form_validator.dart';
import 'widgets/categoria_selector_grid.dart';
import 'widgets/comprovante_picker_widget.dart';
import 'widgets/currency_input_field.dart';
import 'widgets/nova_despesa_categoria_banner.dart';
import 'widgets/nova_despesa_seletor_combustivel.dart';
import 'widgets/nova_despesa_sem_viagem.dart';

// Tela de lançamento e auditoria de despesas operacionais e abastecimentos
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
  bool _combustivelInicializado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Inicializa o combustível padrão com base nas preferências cadastradas do veículo
    if (!_combustivelInicializado) {
      _combustivelInicializado = true;
      if (widget.initialCombustivel == null || widget.initialCombustivel!.isEmpty) {
        final authVM = context.read<AuthViewModel>();
        final veiculo = authVM.currentVehicle;
        final pref = veiculo?['combustivel_preferencial']?.toString().toUpperCase();
        if (pref != null && pref.isNotEmpty) {
          final isDiesel = pref == 'DIESEL_S10' || pref == 'DIESEL_S500';
          _tipoCombustivel = isDiesel ? pref : 'GASOLINA';
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _categoria = widget.initialCategoria;
    _inicializarCampos();
    _recuperarFotoSePendente();
  }

  // Restaura valores iniciais fornecidos por parâmetros de rota ou deep links
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

  // Recupera comprovante pendente caso a câmera externa tenha reiniciado o processo
  Future<void> _recuperarFotoSePendente() async {
    final file = await NovaDespesaDraftManager.recuperarFotoPerdida();
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

  // Trata a navegação de retorno (gesto do Android e botão voltar do AppBar)
  void _aoPressionarVoltar() {
    if (_categoria != null && widget.initialCategoria == null) {
      setState(() => _categoria = null);
      return;
    }
    NovaDespesaDraftManager.limpar();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final homeVM = context.watch<HomeViewModel>();
    final authVM = context.watch<AuthViewModel>();
    final veiculo = authVM.currentVehicle;

    double? capacidadeTanque;
    double? capacidadeArla;
    String? combustivelPreferencial;
    if (veiculo != null) {
      if (veiculo['capacidade_tanque'] != null) {
        capacidadeTanque = double.tryParse(veiculo['capacidade_tanque'].toString());
      }
      if (veiculo['capacidade_arla'] != null) {
        capacidadeArla = double.tryParse(veiculo['capacidade_arla'].toString());
      }
      if (veiculo['combustivel_preferencial'] != null) {
        combustivelPreferencial = veiculo['combustivel_preferencial'].toString().toUpperCase();
      }
    }

    final viagemAtiva = homeVM.ultimasViagens.where((v) => v.status == 'em_andamento').firstOrNull;
    final targetViagemId = widget.viagemId ?? viagemAtiva?.uuid;

    final ViagemCollection? viagemObj = homeVM.ultimasViagens.cast<ViagemCollection?>().firstWhere(
          (v) => v?.uuid == targetViagemId,
          orElse: () => null,
        );

    final bool canPopDireto = _categoria == null || widget.initialCategoria != null;

    return PopScope(
      canPop: canPopDireto,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;
        _aoPressionarVoltar();
      },
      child: Scaffold(
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
            NovaDespesaFieldHelper.obterTitulo(_categoria),
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
                      ? NovaDespesaSemViagem(onVoltar: () => Navigator.pop(context))
                      : _categoria == null
                          ? _buildSelecaoCategoria(colors)
                          : _buildFormularioDespesa(
                              context: context,
                              viagemId: targetViagemId,
                              viagemObj: viagemObj,
                              colors: colors,
                              capacidadeTanque: capacidadeTanque,
                              capacidadeArla: capacidadeArla,
                              combustivelPreferencial: combustivelPreferencial,
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Constrói a tela de seleção inicial quando a categoria ainda não foi escolhida
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

  // Constrói o formulário detalhado para inserção dos valores e comprovante
  Widget _buildFormularioDespesa({
    required BuildContext context,
    required String viagemId,
    required ViagemCollection? viagemObj,
    required AppColorsExtension colors,
    required double? capacidadeTanque,
    required double? capacidadeArla,
    required String? combustivelPreferencial,
  }) {
    final despesaVM = context.watch<DespesaViewModel>();
    final isAbastecimento = _categoria == CategoriaDespesa.abastecimento;

    final erroValor = NovaDespesaFormValidator.validarValorEmTempoReal(
      valorTotal: _valorTotal,
      textoValor: _valorController.text,
    );
    final erroLitros = NovaDespesaFormValidator.validarLitrosEmTempoReal(
      categoria: _categoria,
      textoLitros: _litrosController.text,
      tipoCombustivel: _tipoCombustivel,
      capacidadeTanque: capacidadeTanque,
      capacidadeArla: capacidadeArla,
    );
    final erroKm = NovaDespesaFormValidator.validarOdometroEmTempoReal(
      categoria: _categoria,
      textoKm: _kmAtualController.text,
      viagem: viagemObj,
    );
    final formValido = NovaDespesaFormValidator.isFormularioValido(
      categoria: _categoria,
      valorTotal: _valorTotal,
      textoLitros: _litrosController.text,
      textoKm: _kmAtualController.text,
      tipoCombustivel: _tipoCombustivel,
      viagem: viagemObj,
      capacidadeTanque: capacidadeTanque,
      capacidadeArla: capacidadeArla,
      combustivelPreferencial: combustivelPreferencial,
    );
    final motivoBloqueio = NovaDespesaFormValidator.obterMensagemBloqueio(
      categoria: _categoria,
      valorTotal: _valorTotal,
      textoLitros: _litrosController.text,
      textoKm: _kmAtualController.text,
      tipoCombustivel: _tipoCombustivel,
      viagem: viagemObj,
      capacidadeTanque: capacidadeTanque,
      capacidadeArla: capacidadeArla,
      combustivelPreferencial: combustivelPreferencial,
    );

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
          helperText: NovaDespesaFieldHelper.obterHelperValor(_categoria),
          errorText: erroValor,
          onValueChanged: (val) => setState(() => _valorTotal = val),
        ),
        const SizedBox(height: AppSpacing.xl),

        if (isAbastecimento) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: LitersInputField(
                  label: 'Litros',
                  icon: LucideIcons.fuel,
                  controller: _litrosController,
                  hintText: '0,00',
                  helperText: _tipoCombustivel == 'ARLA_32'
                      ? ((capacidadeArla != null && capacidadeArla > 0)
                          ? 'Máx. ${capacidadeArla == capacidadeArla.toInt() ? capacidadeArla.toInt() : capacidadeArla.toStringAsFixed(1).replaceAll('.', ',')} L (Arla 32)'
                          : 'Máx. 150 L (Arla 32)')
                      : ((capacidadeTanque != null && capacidadeTanque > 0)
                          ? 'Máx. ${capacidadeTanque == capacidadeTanque.toInt() ? capacidadeTanque.toInt() : capacidadeTanque.toStringAsFixed(1).replaceAll('.', ',')} L (tanque)'
                          : null),
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
          NovaDespesaSeletorCombustivel(
            tipoCombustivel: _tipoCombustivel,
            combustivelPreferencial: combustivelPreferencial,
            onChanged: (val) => setState(() => _tipoCombustivel = val),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],

        LabeledInputField(
          label: NovaDespesaFieldHelper.obterLabelLocal(_categoria),
          icon: LucideIcons.mapPin,
          controller: _localController,
          hintText: NovaDespesaFieldHelper.obterHintLocal(_categoria),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: AppSpacing.xl),

        LabeledInputField(
          label: 'Observações (opcional)',
          icon: LucideIcons.fileText,
          controller: _descricaoController,
          hintText: NovaDespesaFieldHelper.obterHintDescricao(_categoria),
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
              : () => _salvar(
                    context: context,
                    viagemId: viagemId,
                    viagemObj: viagemObj,
                    colors: colors,
                    capacidadeTanque: capacidadeTanque,
                    capacidadeArla: capacidadeArla,
                    combustivelPreferencial: combustivelPreferencial,
                  ),
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

  // Cabeçalho da seção de captura do comprovante fiscal
  Widget _buildCabecalhoComprovante(AppColorsExtension colors) {
    return Row(
      children: [
        Icon(LucideIcons.camera, color: colors.primary, size: 18),
        const SizedBox(width: AppSpacing.sm),
        Text(
          NovaDespesaFieldHelper.obterLabelComprovante(_categoria),
          style: GoogleFonts.lexend(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }

  // Salva rascunho temporário antes de delegar o controle para o aplicativo de câmera
  Future<void> _salvarRascunhoAntesDaCamera(String viagemId) {
    return NovaDespesaDraftManager.salvar(
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

  // Valida e envia a despesa para persistência local e sincronização
  Future<void> _salvar({
    required BuildContext context,
    required String viagemId,
    required ViagemCollection? viagemObj,
    required AppColorsExtension colors,
    required double? capacidadeTanque,
    required double? capacidadeArla,
    required String? combustivelPreferencial,
  }) async {
    final despesaVM = context.read<DespesaViewModel>();
    final double? litros = NovaDespesaFormValidator.parseNumero(_litrosController.text);
    final double? kmAtual = NovaDespesaFormValidator.parseNumero(_kmAtualController.text);

    // Validação estrita de domínio antes do salvamento
    final erroValidacao = DespesaViewModel.validarLancamento(
      valorTotal: _valorTotal,
      tipo: _categoria!.codigo,
      viagem: viagemObj,
      litros: litros,
      kmAtual: kmAtual,
      capacidadeTanque: capacidadeTanque,
      capacidadeArla: capacidadeArla,
      tipoCombustivel: _categoria == CategoriaDespesa.abastecimento ? _tipoCombustivel : null,
      combustivelPreferencial: combustivelPreferencial,
      descricao: _descricaoController.text.trim(),
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
      capacidadeTanque: capacidadeTanque,
      capacidadeArla: capacidadeArla,
      combustivelPreferencial: combustivelPreferencial,
    );

    if (!context.mounted) return;

    if (!sucesso) {
      _exibirAlerta(context, despesaVM.errorMessage ?? 'Falha ao salvar a despesa.', colors.error);
      return;
    }

    _exibirAlerta(context, 'Despesa registrada com sucesso!', colors.success);
    await NovaDespesaDraftManager.limpar();
    if (!context.mounted) return;
    Navigator.pop(context);
  }

  // Exibe alertas e notificações ao usuário via SnackBar
  void _exibirAlerta(BuildContext context, String mensagem, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: cor,
      ),
    );
  }
}
