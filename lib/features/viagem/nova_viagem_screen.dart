import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/local_database.dart';
import '../../models/viagem_collection.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import '../auth/auth_viewmodel.dart';
import '../home/home_viewmodel.dart';
import '../sync/sync_service.dart';
import '../../core/widgets/odometer_input_field.dart';
import '../../core/widgets/cidade_estado_picker.dart';

class NovaViagemScreen extends StatefulWidget {
  const NovaViagemScreen({super.key});

  @override
  State<NovaViagemScreen> createState() => _NovaViagemScreenState();
}

class _NovaViagemScreenState extends State<NovaViagemScreen> {
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

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    final veiculo = authVM.currentVehicle;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0F1D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Registro de nova viagem',
          style: GoogleFonts.lexend(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFF1F5F9),
          ),
        ),
        centerTitle: true,
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
                      // Welcome Message
                      Text(
                        'Boa viagem, motorista!',
                        style: GoogleFonts.lexend(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFF1F5F9),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Preencha os dados abaixo para iniciar.',
                        style: GoogleFonts.lexend(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Card do Veículo Vinculado ao Motorista
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF131B2E),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: veiculo != null
                                ? AppColors.primary.withValues(alpha: 0.3)
                                : AppColors.warning.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: veiculo != null
                                    ? AppColors.primary.withValues(alpha: 0.15)
                                    : AppColors.warning.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                veiculo != null ? LucideIcons.truck : LucideIcons.triangleAlert,
                                color: veiculo != null ? AppColors.primary : AppColors.warning,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
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
                                      color: const Color(0xFFF1F5F9),
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
                                      color: const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Seletor de Origem (Cidade e Estado via IBGE Offline)
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
                      const SizedBox(height: 20),

                      // Seletor de Destino (Cidade e Estado via IBGE Offline)
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
                      const SizedBox(height: 20),

                      // Odometer Field
                      OdometerInputField(
                        label: 'KM Inicial',
                        icon: LucideIcons.gauge,
                        controller: _kmController,
                        hintText: 'Ex: 000.000.000',
                      ),

                      const SizedBox(height: 24),
                      const Spacer(),

                      // Botão para iniciar a viagem
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              offset: const Offset(0, 4),
                              blurRadius: 6,
                              spreadRadius: -4,
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              offset: const Offset(0, 10),
                              blurRadius: 15,
                              spreadRadius: -3,
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () => _iniciarViagem(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(LucideIcons.playCircle, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                'COMEÇAR VIAGEM',
                                style: GoogleFonts.lexend(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.9,
                                ),
                              ),
                            ],
                          ),
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

  void _iniciarViagem(BuildContext context) async {
    final origem = _origemCidade?.trim() ?? '';
    final origemUF = _origemUF?.trim() ?? '';
    final destino = _destinoCidade?.trim() ?? '';
    final destinoUF = _destinoUF?.trim() ?? '';
    final kmText = _kmController.text.trim();

    if (origem.isEmpty || origemUF.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione a cidade e estado de Origem!'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    if (destino.isEmpty || destinoUF.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione a cidade e estado de Destino!'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    if (kmText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, informe a quilometragem inicial do caminhão!'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    try {
      final isar = LocalDatabase.isar;

      // Verifica se já existe viagem em andamento
      final viagemAtiva = await isar.viagemCollections
          .filter()
          .statusEqualTo('em_andamento')
          .findFirst();

      if (viagemAtiva != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Você já possui uma viagem em andamento! Conclua-a primeiro.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }

      final kmDouble = double.parse(kmText.replaceAll('.', ''));

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

      // Dispara a sincronização em segundo plano (com retry de até 3x se a conexão oscilar)
      SyncService().syncAll();

      if (mounted) {
        // Atualiza a home para refletir a nova viagem
        context.read<HomeViewModel>().carregarDadosBancoLocal();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Viagem iniciada com sucesso!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar viagem: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
