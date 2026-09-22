import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:isar/isar.dart';
import '../../core/database/local_database.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/cidade_estado_picker.dart';
import '../../core/widgets/odometer_input_field.dart';
import '../../models/viagem_collection.dart';
import '../../services/sync_service.dart';
import '../auth/auth_viewmodel.dart';
import '../home/home_viewmodel.dart';

/*──────────────────────────────────────────────────────────────*/
/* TELA: ABERTURA E REGISTRO DE NOVA VIAGEM                     */
/*──────────────────────────────────────────────────────────────*/

/// Formulário operacional para início de uma nova jornada rodoviária.
/// Permite definir a origem e destino utilizando a base geográfica do IBGE,
/// odômetro inicial do veículo e validação de concorrência com rotas ativas.
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

  @override
  void dispose() {
    _kmController.dispose();
    super.dispose();
  }

  double? _parseNumero(String texto) {
    final limpo = texto.replaceAll('.', '').replaceAll(',', '.').trim();
    return double.tryParse(limpo);
  }

  String? _validarKmInicialEmTempoReal(double? ultimaKmConhecida) {
    final kmText = _kmController.text.trim();
    if (kmText.isEmpty) return null;
    final km = _parseNumero(kmText);
    if (km == null || km <= 0) {
      return 'Informe uma quilometragem inicial maior que zero';
    }
    if (ultimaKmConhecida != null && km < ultimaKmConhecida) {
      return 'KM (${km.toInt()}) não pode ser menor que o da última viagem (${ultimaKmConhecida.toInt()} KM)';
    }
    return null;
  }

  /*──────────────────────────────────────────────────────────────*/
  /* GRAVAÇÃO LOCAL E DISPARO DE SINCRONIZAÇÃO                    */
  /*──────────────────────────────────────────────────────────────*/

  Future<void> _iniciarViagem(AppColorsExtension colors) async {
    final origem = _origemCidade?.trim() ?? '';
    final origemUF = _origemUF?.trim() ?? '';
    final destino = _destinoCidade?.trim() ?? '';
    final destinoUF = _destinoUF?.trim() ?? '';
    final kmText = _kmController.text.trim();

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

    if (kmText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Por favor, informe a quilometragem inicial do caminhão!'),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Você já possui uma viagem em andamento! Conclua-a primeiro.'),
            backgroundColor: colors.error,
          ),
        );
        return;
      }

      final kmDouble = double.parse(kmText.replaceAll('.', '').replaceAll(',', '.'));

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
          content: const Text('Viagem iniciada com sucesso!'),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final authVM = context.watch<AuthViewModel>();
    final homeVM = context.watch<HomeViewModel>();
    final veiculo = authVM.currentVehicle;

    final ultimaViagemConcluida = homeVM.ultimasViagens
        .where((v) => v.status == 'concluida' && v.kmFinal != null)
        .firstOrNull;
    final double? ultimaKmConhecida = ultimaViagemConcluida?.kmFinal;
    final erroKm = _validarKmInicialEmTempoReal(ultimaKmConhecida);
    final kmInicialNum = _parseNumero(_kmController.text);

    final bool formValido = (_origemCidade?.isNotEmpty ?? false) &&
        (_origemUF?.isNotEmpty ?? false) &&
        (_destinoCidade?.isNotEmpty ?? false) &&
        (_destinoUF?.isNotEmpty ?? false) &&
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

                      // Card do Veículo Vinculado
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: colors.cardBackground,
                          borderRadius: AppRadius.mdRadius,
                          border: Border.all(
                            color: veiculo != null
                                ? colors.primaryBorder
                                : colors.warning.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.sm),
                              decoration: BoxDecoration(
                                color: veiculo != null
                                    ? colors.primaryLight
                                    : colors.warning.withValues(alpha: 0.15),
                              borderRadius: AppRadius.smRadius,
                            ),
                            child: Icon(
                              veiculo != null ? LucideIcons.truck : LucideIcons.triangleAlert,
                              color: veiculo != null ? colors.primary : colors.warning,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  veiculo != null
                                      ? (veiculo['modelo'] ?? 'Veículo do Motorista')
                                      : 'Nenhum veículo vinculado',
                                  style: GoogleFonts.lexend(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: colors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  veiculo != null
                                      ? 'Placa: ${veiculo['placa'] ?? '---'}${veiculo['reboque']?['modelo'] != null && veiculo['reboque']['modelo'].toString().isNotEmpty ? ' • ${veiculo['reboque']['modelo']}' : ''}'
                                      : 'Vincule um veículo no painel para registrar viagens.',
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
                      onSelected: (cidade, uf) {
                        setState(() {
                          _destinoCidade = cidade;
                          _destinoUF = uf;
                        });
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),

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
                      onPressed: formValido ? () => _iniciarViagem(colors) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: formValido ? colors.success : colors.surfaceOverlay,
                        disabledBackgroundColor: colors.surfaceOverlay,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.xlRadius,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                        elevation: 0,
                      ),
                      child: Row(
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
