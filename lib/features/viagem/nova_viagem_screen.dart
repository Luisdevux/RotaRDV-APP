import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/local_database.dart';
import '../../models/viagem_collection.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import '../home/home_viewmodel.dart';
import '../../core/widgets/labeled_input_field.dart';
import '../../core/widgets/odometer_input_field.dart';

class NovaViagemScreen extends StatefulWidget {
  const NovaViagemScreen({super.key});

  @override
  State<NovaViagemScreen> createState() => _NovaViagemScreenState();
}

class _NovaViagemScreenState extends State<NovaViagemScreen> {
  final TextEditingController _origemController = TextEditingController();
  final TextEditingController _origemUFController = TextEditingController();
  final TextEditingController _destinoController = TextEditingController();
  final TextEditingController _destinoUFController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();

  @override
  void dispose() {
    _origemController.dispose();
    _origemUFController.dispose();
    _destinoController.dispose();
    _destinoUFController.dispose();
    _kmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
              const SizedBox(height: 32),

              // Origin Field
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 7,
                    child: LabeledInputField(
                      label: 'Origem',
                      icon: LucideIcons.mapPin,
                      controller: _origemController,
                      hintText: 'Cidade de partida',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: LabeledInputField(
                      label: 'UF',
                      icon: LucideIcons.map,
                      controller: _origemUFController,
                      hintText: 'MT',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Destination Field
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 7,
                    child: LabeledInputField(
                      label: 'Destino',
                      icon: LucideIcons.flag,
                      controller: _destinoController,
                      hintText: 'Cidade de destino',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: LabeledInputField(
                      label: 'UF',
                      icon: LucideIcons.map,
                      controller: _destinoUFController,
                      hintText: 'PA',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Odometer Field
              OdometerInputField(
                label: 'KM Inicial',
                icon: LucideIcons.gauge,
                controller: _kmController,
                hintText: 'Ex: 000.000.000',
              ),

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
  }

  void _iniciarViagem(BuildContext context) async {
    final origem = _origemController.text.trim();
    final origemUF = _origemUFController.text.trim();
    final destino = _destinoController.text.trim();
    final destinoUF = _destinoUFController.text.trim();
    final kmText = _kmController.text.trim();

    if (origem.isEmpty || origemUF.isEmpty || destino.isEmpty || destinoUF.isEmpty || kmText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
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
