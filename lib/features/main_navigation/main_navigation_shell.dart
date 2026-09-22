import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/database/local_database.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/custom_bottom_nav_bar.dart';
import '../../models/viagem_collection.dart';
import '../despesas/nova_despesa_page.dart';
import '../despesas/despesa_viewmodel.dart';
import '../home/home_page.dart';
import '../viagem/viagem_tab_page.dart';
import '../viagem/viagens_list_page.dart';
import '../perfil/perfil_page.dart';

class MainNavigationShell extends StatefulWidget {
  final int initialIndex;

  const MainNavigationShell({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _verificarFotoPendenteCamera();
  }

  Future<void> _verificarFotoPendenteCamera() async {
    if (!Platform.isAndroid) return;
    try {
      final picker = ImagePicker();
      final LostDataResponse response = await picker.retrieveLostData();
      if (!response.isEmpty && response.file != null) {
        debugPrint('[MainNavigationShell] Foto resgatada da câmera: ${response.file!.path}');
        final prefs = await SharedPreferences.getInstance();
        final lastViagemId = prefs.getString('despesa_draft_viagem_id');
        final lastCategoriaStr = prefs.getString('despesa_draft_categoria');
        final lastValor = prefs.getDouble('despesa_draft_valor') ?? 0.0;
        final lastLocal = prefs.getString('despesa_draft_local') ?? '';
        final lastDesc = prefs.getString('despesa_draft_descricao') ?? '';
        final lastLitros = prefs.getString('despesa_draft_litros') ?? '';
        final lastKm = prefs.getString('despesa_draft_km') ?? '';
        final lastCombustivel = prefs.getString('despesa_draft_combustivel') ?? 'DIESEL_S10';

        final isar = LocalDatabase.isar;
        final viagemAtiva = await isar.viagemCollections
            .filter()
            .statusEqualTo('em_andamento')
            .findFirst();

        final targetViagemId = lastViagemId ?? viagemAtiva?.uuid;

        CategoriaDespesa? cat;
        if (lastCategoriaStr != null) {
          cat = CategoriaDespesa.values.where((c) => c.name == lastCategoriaStr).firstOrNull;
        }

        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => NovaDespesaPage(
                  viagemId: targetViagemId,
                  initialCategoria: cat,
                  fotoRecuperada: File(response.file!.path),
                  initialValor: lastValor > 0 ? lastValor : null,
                  initialLocal: lastLocal.isNotEmpty ? lastLocal : null,
                  initialDescricao: lastDesc.isNotEmpty ? lastDesc : null,
                  initialLitros: lastLitros.isNotEmpty ? lastLitros : null,
                  initialKm: lastKm.isNotEmpty ? lastKm : null,
                  initialCombustivel: lastCombustivel,
                ),
              ),
            );
          });
        }
      }
    } catch (e) {
      debugPrint('[MainNavigationShell] Erro ao verificar LostData da câmera: $e');
    }
  }

  void switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomePage(onNavigateToTab: switchTab),
          ViagemTabPage(onNavigateToTab: switchTab),
          ViagensListPage(isTab: true, onNavigateToTab: switchTab),
          PerfilPage(isTab: true, onNavigateToTab: switchTab),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
