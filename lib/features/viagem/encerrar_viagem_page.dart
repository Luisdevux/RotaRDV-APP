import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../core/database/local_database.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_dialog.dart';
import '../../core/widgets/network_status_bar.dart';
import '../../core/widgets/thousands_formatter.dart';
import '../../models/viagem_collection.dart';
import '../../services/sync_service.dart';
import '../despesas/despesa_viewmodel.dart';
import '../despesas/despesas_viagem_page.dart';
import '../home/home_viewmodel.dart';
import 'widgets/encerrar_viagem_consumo_card.dart';
import 'widgets/viagem_rota_card.dart';

// Página responsável pelo registro do odômetro final, cálculo de fechamento da rota, auditoria de abastecimentos e encerramento da jornada com persistência offline
class EncerrarViagemPage extends StatefulWidget {
  final ViagemCollection viagem;

  const EncerrarViagemPage({
    super.key,
    required this.viagem,
  });

  @override
  State<EncerrarViagemPage> createState() => _EncerrarViagemPageState();
}

class _EncerrarViagemPageState extends State<EncerrarViagemPage> {
  final TextEditingController _kmFinalController = TextEditingController();
  double? _kmFinal;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.viagem.kmFinal != null && widget.viagem.kmFinal! > widget.viagem.kmInicial) {
      _kmFinal = widget.viagem.kmFinal;
      _kmFinalController.text = NumberFormat('#,###', 'pt_BR').format(_kmFinal!.toInt());
    }

    _kmFinalController.addListener(() {
      final text = _kmFinalController.text.replaceAll('.', '').replaceAll(',', '').trim();
      final val = double.tryParse(text);
      if (val != _kmFinal) {
        setState(() {
          _kmFinal = val;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DespesaViewModel>().carregarDespesas(widget.viagem.uuid);
      }
    });
  }

  @override
  void dispose() {
    _kmFinalController.dispose();
    super.dispose();
  }

  String _formatCurrency(double val) {
    try {
      return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(val);
    } catch (_) {
      return 'R\$ ${val.toStringAsFixed(2)}';
    }
  }

  Future<void> _confirmarEncerramento(BuildContext context, AppColorsExtension colors) async {
    final bool? confirm = await AppDialog.show(
      context: context,
      title: 'Encerrar viagem',
      message: 'Confirma o encerramento desta rota com KM final de ${_kmFinal!.toStringAsFixed(0)} KM?',
      confirmText: 'Encerrar viagem',
      cancelText: 'Cancelar',
      icon: LucideIcons.checkCircle2,
    );

    if (confirm != true || !context.mounted) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final isar = LocalDatabase.isar;
      await isar.writeTxn(() async {
        widget.viagem.kmFinal = _kmFinal;
        widget.viagem.dataFim = DateTime.now();
        widget.viagem.status = 'concluida';
        widget.viagem.statusSincronizacao = widget.viagem.statusSincronizacao == 'criado' ? 'criado' : 'editado';
        await isar.viagemCollections.put(widget.viagem);
      });

      if (context.mounted) {
        context.read<HomeViewModel>().init();
      }

      SyncService().syncAll();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(LucideIcons.checkCircle2, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text('Viagem encerrada com sucesso!'),
                ),
              ],
            ),
            backgroundColor: colors.success,
          ),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      debugPrint('[EncerrarViagem] Erro ao encerrar viagem: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erro ao registrar encerramento da viagem.'),
            backgroundColor: colors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final kmInicial = widget.viagem.kmInicial;
    final homeVM = context.watch<HomeViewModel>();
    final veiculo = homeVM.veiculo;
    final despesaVM = context.watch<DespesaViewModel>();

    final metricas = despesaVM.calcularMetricasConsumo(
      widget.viagem,
      kmFinalTemporario: _kmFinal,
    );

    final bool isKmMenorQueInicial = _kmFinal != null && _kmFinal! <= kmInicial;
    final bool isKmMenorQueUltimoAbastec = metricas.ultimoKmInformado != null &&
        _kmFinal != null &&
        _kmFinal! < metricas.ultimoKmInformado!;
    final bool isKmInvalido = isKmMenorQueInicial || isKmMenorQueUltimoAbastec;

    final double? kmPercorridoExibido;
    final bool isParcial;

    if (_kmFinal != null) {
      if (!isKmInvalido) {
        kmPercorridoExibido = _kmFinal! - kmInicial;
        isParcial = false;
      } else {
        kmPercorridoExibido = null;
        isParcial = false;
      }
    } else if (widget.viagem.kmFinal != null && widget.viagem.kmFinal! > kmInicial) {
      kmPercorridoExibido = widget.viagem.kmFinal! - kmInicial;
      isParcial = false;
    } else if (metricas.kmPercorridoTotal > 0) {
      kmPercorridoExibido = metricas.kmPercorridoTotal;
      isParcial = true;
    } else {
      kmPercorridoExibido = null;
      isParcial = false;
    }

    final String kmPercorridoSubtitulo;
    final Color kmPercorridoSubtituloColor;

    if (_kmFinal != null && isKmInvalido) {
      kmPercorridoSubtitulo = isKmMenorQueInicial
          ? 'Menor que o inicial'
          : 'Menor que último abastec.';
      kmPercorridoSubtituloColor = colors.error;
    } else if (isParcial && kmPercorridoExibido != null) {
      kmPercorridoSubtitulo = metricas.ultimoKmInformado != null
          ? 'Último reg.: ${metricas.ultimoKmInformado!.toStringAsFixed(0)} KM'
          : 'Parcial dos abastecimentos';
      kmPercorridoSubtituloColor = colors.textMuted;
    } else if (_kmFinal != null && kmPercorridoExibido != null) {
      kmPercorridoSubtitulo = 'Inicial: ${kmInicial.toStringAsFixed(0)} • Final: ${_kmFinal!.toStringAsFixed(0)}';
      kmPercorridoSubtituloColor = colors.textMuted;
    } else {
      kmPercorridoSubtitulo = 'Inicial: ${kmInicial.toStringAsFixed(0)} KM';
      kmPercorridoSubtituloColor = colors.textMuted;
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Encerrar viagem',
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
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ViagemRotaCard(
                      viagem: widget.viagem,
                      veiculo: veiculo,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Campo de Odômetro (KM Final)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(LucideIcons.gauge, color: colors.primary, size: 18),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'KM final (odômetro na chegada)*',
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
                          decoration: BoxDecoration(
                            color: colors.inputBackground,
                            border: Border.all(
                              color: isKmInvalido ? colors.error : colors.border,
                            ),
                            borderRadius: AppRadius.lgRadius,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _kmFinalController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [ThousandsFormatter()],
                                  style: GoogleFonts.lexend(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: colors.textPrimary,
                                    height: 1.25,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: '000.000',
                                    hintStyle: GoogleFonts.lexend(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: colors.textHint,
                                    ),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                    filled: false,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: colors.cardBackground,
                                  borderRadius: AppRadius.xsRadius,
                                  border: Border.all(color: colors.borderSubtle),
                                ),
                                child: Text(
                                  'KM',
                                  style: GoogleFonts.lexend(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isKmInvalido) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(LucideIcons.alertCircle, size: 14, color: colors.error),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  isKmMenorQueInicial
                                      ? 'O KM final deve ser maior que o KM inicial (${kmInicial.toStringAsFixed(0)} KM)'
                                      : 'O KM final não pode ser menor que o último abastecimento (${metricas.ultimoKmInformado!.toStringAsFixed(0)} KM)',
                                  style: GoogleFonts.lexend(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: colors.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Métricas: Total Percorrido e Despesas
                    Row(
                      children: [
                        Expanded(
                          child: AppCard(
                            backgroundColor: colors.cardBackground,
                            borderColor: colors.borderSubtle,
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Percorrido',
                                          style: GoogleFonts.lexend(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: colors.textHint,
                                          ),
                                        ),
                                        if (isParcial && kmPercorridoExibido != null) ...[
                                          const SizedBox(width: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                            decoration: BoxDecoration(
                                              color: colors.primary.withValues(alpha: 0.12),
                                              borderRadius: AppRadius.xsRadius,
                                            ),
                                            child: Text(
                                              'Parcial',
                                              style: GoogleFonts.lexend(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w700,
                                                color: colors.primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    Icon(LucideIcons.gauge, size: 14, color: colors.primary),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  kmPercorridoExibido != null ? '${kmPercorridoExibido.toStringAsFixed(0)} KM' : '-- KM',
                                  style: GoogleFonts.lexend(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: colors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  kmPercorridoSubtitulo,
                                  style: GoogleFonts.lexend(
                                    fontSize: 11,
                                    color: kmPercorridoSubtituloColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: AppCard(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DespesasViagemPage(
                                    viagem: widget.viagem,
                                    viagemId: widget.viagem.uuid,
                                  ),
                                ),
                              );
                            },
                            backgroundColor: colors.cardBackground,
                            borderColor: colors.borderSubtle,
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Despesas',
                                      style: GoogleFonts.lexend(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: colors.textHint,
                                      ),
                                    ),
                                    Icon(LucideIcons.chevronRight, size: 14, color: colors.textSecondary),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _formatCurrency(despesaVM.totalGasto),
                                  style: GoogleFonts.lexend(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: colors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${despesaVM.despesas.length} ${despesaVM.despesas.length == 1 ? 'lançamento' : 'lançamentos'}',
                                  style: GoogleFonts.lexend(
                                    fontSize: 11,
                                    color: colors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Card de Consumo Médio da Rota
                    EncerrarViagemConsumoCard(metricas: metricas),
                    const SizedBox(height: AppSpacing.lg),

                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: colors.surfaceOverlay,
                        borderRadius: AppRadius.mdRadius,
                        border: Border.all(color: colors.borderSubtle),
                      ),
                      child: Row(
                        children: [
                          Icon(LucideIcons.shieldCheck, size: 18, color: colors.textHint),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              'Ao encerrar, os dados da viagem e comprovantes serão sincronizados com a transportadora.',
                              style: GoogleFonts.lexend(
                                fontSize: 12,
                                color: colors.textMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.huge),

                    // Botão de Confirmação
                    Builder(
                      builder: (context) {
                        final bool botaoHabilitado = !_isSaving && _kmFinal != null && !isKmInvalido;
                        return ElevatedButton(
                          onPressed: botaoHabilitado ? () => _confirmarEncerramento(context, colors) : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: botaoHabilitado ? colors.success : colors.surfaceOverlay,
                            disabledBackgroundColor: colors.surfaceOverlay,
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                            shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      botaoHabilitado ? LucideIcons.checkCircle2 : LucideIcons.lock,
                                      color: botaoHabilitado ? Colors.white : colors.textHint,
                                      size: 20,
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    Text(
                                      'Encerrar viagem',
                                      style: GoogleFonts.lexend(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.8,
                                        color: botaoHabilitado ? Colors.white : colors.textHint,
                                      ),
                                    ),
                                  ],
                                ),
                        );
                      },
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
