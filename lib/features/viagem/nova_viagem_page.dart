import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:isar/isar.dart';
import '../../core/database/local_database.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_dialog.dart';
import '../../core/widgets/cidade_estado_picker.dart';
import '../../core/widgets/odometer_input_field.dart';
import '../../models/viagem_collection.dart';
import '../../services/sync_service.dart';
import '../auth/auth_viewmodel.dart';
import '../home/home_viewmodel.dart';

// Formulário operacional para início de uma nova viagem
// Permite definir a origem e destino utilizando a base geográfica do IBGE, odômetro inicial do veículo e validação de concorrência com rotas ativas
class NovaViagemPage extends StatefulWidget {
  const NovaViagemPage({super.key});

  @override
  State<NovaViagemPage> createState() => _NovaViagemPageState();
}

class _NovaViagemPageState extends State<NovaViagemPage> {
  String? _origemCidade;
  String? _origemUF;
  String? _destinoCidade;
  String? _destinoUF;
  final TextEditingController _kmController = TextEditingController();

  bool _isSaving = false;
  ViagemCollection? _viagemAtiva;
  double? _ultimaKmRegistrada;

  @override
  void initState() {
    super.initState();
    _carregarDadosLocais();
  }

  Future<void> _carregarDadosLocais() async {
    try {
      final isar = LocalDatabase.isar;

      final ativa = await isar.viagemCollections
          .filter()
          .statusEqualTo('em_andamento')
          .findFirst();

      final concluidas = await isar.viagemCollections
          .filter()
          .statusEqualTo('concluida')
          .or()
          .statusEqualTo('concluída')
          .sortByDataFimDesc()
          .findAll();

      final ultimaConcluida = concluidas
          .where((v) => v.kmFinal != null && v.kmFinal! > 0)
          .firstOrNull;

      if (mounted) {
        setState(() {
          _viagemAtiva = ativa;
          _ultimaKmRegistrada = ultimaConcluida?.kmFinal;
        });
      }
    } catch (e) {
      debugPrint('[NovaViagem] Erro ao carregar dados locais: $e');
    }
  }

  @override
  void dispose() {
    _kmController.dispose();
    super.dispose();
  }

  double? _parseNumero(String texto) {
    final limpo = texto.replaceAll('.', '').replaceAll(',', '.').trim();
    return double.tryParse(limpo);
  }

  bool get _isOrigemIgualDestino {
    if (_origemCidade == null || _origemUF == null || _destinoCidade == null || _destinoUF == null) {
      return false;
    }
    return _origemCidade!.trim().toLowerCase() == _destinoCidade!.trim().toLowerCase() &&
        _origemUF!.trim().toUpperCase() == _destinoUF!.trim().toUpperCase();
  }

  String? get _erroDestino {
    if (_isOrigemIgualDestino) {
      return 'O destino não pode ser a mesma cidade de origem';
    }
    return null;
  }

  String? _validarKmInicialEmTempoReal(double? ultimaKmConhecida) {
    final kmText = _kmController.text.trim();
    if (kmText.isEmpty) return null;
    final km = _parseNumero(kmText);
    if (km == null || km <= 0) {
      return 'Informe uma quilometragem inicial maior que zero';
    }
    if (km > 10000000) {
      return 'Quilometragem inválida (limite excedido)';
    }
    if (ultimaKmConhecida != null && km < ultimaKmConhecida) {
      return 'KM (${NumberFormat('#,###', 'pt_BR').format(km.toInt())}) não pode ser menor que o da última viagem (${NumberFormat('#,###', 'pt_BR').format(ultimaKmConhecida.toInt())} KM)';
    }
    return null;
  }

  Future<void> _iniciarViagem(AppColorsExtension colors, dynamic veiculo) async {
    if (_isSaving) return;

    final origem = _origemCidade?.trim() ?? '';
    final origemUF = _origemUF?.trim() ?? '';
    final destino = _destinoCidade?.trim() ?? '';
    final destinoUF = _destinoUF?.trim() ?? '';
    final kmText = _kmController.text.trim();

    if (veiculo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('É obrigatório ter um veículo vinculado para iniciar uma viagem!'),
          backgroundColor: colors.error,
        ),
      );
      return;
    }

    if (origem.isEmpty || origemUF.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Por favor, selecione a cidade e estado de Origem!'),
          backgroundColor: colors.warning,
        ),
      );
      return;
    }

    if (destino.isEmpty || destinoUF.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Por favor, selecione a cidade e estado de Destino!'),
          backgroundColor: colors.warning,
        ),
      );
      return;
    }

    if (_isOrigemIgualDestino) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('A cidade de destino não pode ser igual à de origem!'),
          backgroundColor: colors.warning,
        ),
      );
      return;
    }

    if (kmText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Por favor, informe a quilometragem inicial do caminhão!'),
          backgroundColor: colors.warning,
        ),
      );
      return;
    }

    final kmDouble = _parseNumero(kmText);
    if (kmDouble == null || kmDouble <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('A quilometragem inicial deve ser maior que zero!'),
          backgroundColor: colors.warning,
        ),
      );
      return;
    }

    try {
      final isar = LocalDatabase.isar;

      final viagemAtiva = await isar.viagemCollections
          .filter()
          .statusEqualTo('em_andamento')
          .findFirst();

      if (viagemAtiva != null) {
        if (!mounted) return;
        setState(() {
          _viagemAtiva = viagemAtiva;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Você já possui uma viagem em andamento! Conclua-a primeiro.'),
            backgroundColor: colors.error,
          ),
        );
        return;
      }

      if (!mounted) return;

      // Alerta de discrepância acentuada (ex: diferença > 10.000 KM em relação ao último odômetro)
      if (_ultimaKmRegistrada != null && (kmDouble - _ultimaKmRegistrada!) > 10000) {
        final bool? confirmarSalto = await AppDialog.show(
          context: context,
          title: 'Quilometragem discrepante',
          message: 'O KM informado (${NumberFormat('#,###', 'pt_BR').format(kmDouble.toInt())} KM) é mais de 10.000 KM superior ao último registro (${NumberFormat('#,###', 'pt_BR').format(_ultimaKmRegistrada!.toInt())} KM).\n\nConfirma que este valor está correto?',
          confirmText: 'Sim, está correto',
          cancelText: 'Revisar',
          icon: LucideIcons.alertTriangle,
        );
        if (confirmarSalto != true || !mounted) return;
      }

      if (!mounted) return;

      // Modal de Confirmação da Viagem
      final bool? confirm = await AppDialog.show(
        context: context,
        title: 'Iniciar viagem',
        message: 'Confirma o início da rota de $origem ($origemUF) para $destino ($destinoUF) com odômetro inicial de ${NumberFormat('#,###', 'pt_BR').format(kmDouble.toInt())} KM?',
        confirmText: 'Começar viagem',
        cancelText: 'Revisar dados'
      );

      if (confirm != true || !mounted) return;

      setState(() {
        _isSaving = true;
      });

      final novaViagem = ViagemCollection()
        ..uuid = const Uuid().v4()
        ..origemCidade = origem
        ..origemEstado = origemUF
        ..destinoCidade = destino
        ..destinoEstado = destinoUF
        ..kmInicial = kmDouble
        ..dataInicio = DateTime.now()
        ..status = 'em_andamento'
        ..statusSincronizacao = 'criado';

      await isar.writeTxn(() async {
        await isar.viagemCollections.put(novaViagem);
      });

      SyncService().syncAll();

      if (!mounted) return;
      context.read<HomeViewModel>().carregarDadosBancoLocal();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(LucideIcons.checkCircle2, color: Colors.white),
              SizedBox(width: 8),
              Expanded(child: Text('Viagem iniciada com sucesso!')),
            ],
          ),
          backgroundColor: colors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar viagem: $e'),
          backgroundColor: colors.error,
        ),
      );
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
    final authVM = context.watch<AuthViewModel>();
    final homeVM = context.watch<HomeViewModel>();
    final veiculo = authVM.currentVehicle;
    final bool temVeiculo = veiculo != null;

    final ultimaVM = homeVM.ultimasViagens
        .where((v) => (v.status == 'concluida' || v.status == 'concluída') && v.kmFinal != null)
        .firstOrNull;
    final double? ultimaKmConhecida = _ultimaKmRegistrada ?? ultimaVM?.kmFinal;
    final erroKm = _validarKmInicialEmTempoReal(ultimaKmConhecida);
    final kmInicialNum = _parseNumero(_kmController.text);
    final erroDestino = _erroDestino;

    final bool formValido = temVeiculo &&
        _viagemAtiva == null &&
        !_isSaving &&
        (_origemCidade?.isNotEmpty ?? false) &&
        (_origemUF?.isNotEmpty ?? false) &&
        (_destinoCidade?.isNotEmpty ?? false) &&
        (_destinoUF?.isNotEmpty ?? false) &&
        erroDestino == null &&
        (kmInicialNum != null && kmInicialNum > 0) &&
        erroKm == null;

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
          'Nova viagem',
          style: GoogleFonts.lexend(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 32.0),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Boa viagem, motorista!',
                        style: GoogleFonts.lexend(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Preencha os dados abaixo para iniciar.',
                        style: GoogleFonts.lexend(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: colors.textMuted,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Banner de Alerta de Viagem Ativa em Andamento
                      if (_viagemAtiva != null) ...[
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: colors.error.withValues(alpha: 0.10),
                            borderRadius: AppRadius.mdRadius,
                            border: Border.all(color: colors.error.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(LucideIcons.alertTriangle, color: colors.error, size: 20),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Viagem em andamento detectada',
                                      style: GoogleFonts.lexend(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: colors.error,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Você já possui uma rota ativa (${_viagemAtiva!.origemCidade} ➔ ${_viagemAtiva!.destinoCidade}). Conclua a rota atual antes de iniciar um novo percurso.',
                                      style: GoogleFonts.lexend(
                                        fontSize: 11,
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Card do Veículo Vinculado
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: colors.cardBackground,
                          borderRadius: AppRadius.mdRadius,
                          border: Border.all(
                            color: temVeiculo
                                ? colors.borderSubtle
                                : colors.error.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              temVeiculo ? LucideIcons.truck : LucideIcons.triangleAlert,
                              color: temVeiculo ? colors.primary : colors.error,
                              size: 20,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    temVeiculo
                                        ? (veiculo['modelo'] ?? 'Veículo do Motorista')
                                        : 'Nenhum veículo vinculado ao perfil',
                                    style: GoogleFonts.lexend(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: temVeiculo ? colors.textPrimary : colors.error,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    temVeiculo
                                        ? 'Placa: ${veiculo['placa'] ?? '---'}${veiculo['reboque']?['modelo'] != null && veiculo['reboque']['modelo'].toString().isNotEmpty ? ' • ${veiculo['reboque']['modelo']}' : ''}'
                                        : 'É obrigatório vincular um veículo no painel para registrar viagens.',
                                    style: GoogleFonts.lexend(
                                      fontSize: 11,
                                      color: colors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      CidadeEstadoPicker(
                        label: 'Origem',
                        icon: LucideIcons.mapPin,
                        cidade: _origemCidade,
                        uf: _origemUF,
                        hintCidade: 'Selecione a cidade de partida',
                        hintUF: 'UF',
                        onSelected: (cidade, uf) {
                          setState(() {
                            _origemCidade = cidade;
                            _origemUF = uf;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      CidadeEstadoPicker(
                        label: 'Destino',
                        icon: LucideIcons.flag,
                        cidade: _destinoCidade,
                        uf: _destinoUF,
                        hintCidade: 'Selecione a cidade de destino',
                        hintUF: 'UF',
                        errorText: erroDestino,
                        onSelected: (cidade, uf) {
                          setState(() {
                            _destinoCidade = cidade;
                            _destinoUF = uf;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Informação de referência do último odômetro
                      if (ultimaKmConhecida != null) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(LucideIcons.history, size: 12, color: colors.textMuted),
                                const SizedBox(width: 4),
                                Text(
                                  'Último registro: ${NumberFormat('#,###', 'pt_BR').format(ultimaKmConhecida.toInt())} KM',
                                  style: GoogleFonts.lexend(
                                    fontSize: 11,
                                    color: colors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                _kmController.text = NumberFormat('#,###', 'pt_BR').format(ultimaKmConhecida.toInt());
                                setState(() {});
                              },
                              borderRadius: AppRadius.xsRadius,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                child: Row(
                                  children: [
                                    Icon(LucideIcons.copy, size: 12, color: colors.primary),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Usar último KM',
                                      style: GoogleFonts.lexend(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: colors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                      ],

                      OdometerInputField(
                        label: 'KM inicial',
                        icon: LucideIcons.gauge,
                        controller: _kmController,
                        hintText: 'Ex: 000.000.000',
                        errorText: erroKm,
                        onChanged: (_) => setState(() {}),
                      ),

                      const SizedBox(height: AppSpacing.xl),
                      const Spacer(),

                      ElevatedButton(
                        onPressed: formValido ? () => _iniciarViagem(colors, veiculo) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: formValido ? colors.success : colors.surfaceOverlay,
                          disabledBackgroundColor: colors.surfaceOverlay,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.lgRadius,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                          elevation: 0,
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    formValido ? LucideIcons.playCircle : LucideIcons.lock,
                                    color: formValido ? Colors.white : colors.textHint,
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text(
                                    'Começar viagem',
                                    style: GoogleFonts.lexend(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: formValido ? Colors.white : colors.textHint,
                                      letterSpacing: 0.9,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
