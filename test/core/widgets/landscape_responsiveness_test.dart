import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:app_despesas/core/theme/app_theme.dart';
import 'package:app_despesas/core/widgets/app_dialog.dart';
import 'package:app_despesas/core/widgets/app_empty_state.dart';
import 'package:app_despesas/core/widgets/cidade_estado_picker.dart';
import 'package:app_despesas/core/widgets/network_status_bar.dart';
import 'package:app_despesas/features/despesas/despesa_viewmodel.dart';
import 'package:app_despesas/features/despesas/widgets/categoria_selector_grid.dart';
import 'package:app_despesas/features/despesas/widgets/comprovante_picker_widget.dart';
import 'package:app_despesas/features/despesas/widgets/despesas_resumo_gastos_card.dart';
import 'package:app_despesas/features/despesas/widgets/nova_despesa_sem_viagem.dart';
import 'package:app_despesas/features/home/widgets/home_header_widget.dart';
import 'package:app_despesas/features/home/widgets/home_jornada_card.dart';
import 'package:app_despesas/models/viagem_collection.dart';
import 'package:app_despesas/services/sync_service.dart';

void main() {
  Widget wrapInLandscapeApp(Widget child, {Size size = const Size(800, 320), double bottomInset = 0}) {
    return MediaQuery(
      data: MediaQueryData(
        size: size,
        viewInsets: EdgeInsets.only(bottom: bottomInset),
      ),
      child: MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: SizedBox(
            width: size.width,
            height: size.height,
            child: child,
          ),
        ),
      ),
    );
  }

  group('Responsividade Horizontal (Landscape) - Sem RenderFlex Overflow', () {
    testWidgets('AppEmptyState não estoura em containers baixos na horizontal', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 320));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        wrapInLandscapeApp(
          const SizedBox(
            height: 110,
            child: AppEmptyState(
              icon: LucideIcons.truck,
              title: 'Nenhuma viagem encontrada',
              subtitle: 'Toque no botão acima para iniciar sua rota.',
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Nenhuma viagem encontrada'), findsOneWidget);
    });

    testWidgets('AppDialog rola suavemente sem estourar na horizontal com textos longos', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 300));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        wrapInLandscapeApp(
          AppDialog(
            title: 'Atenção Crítica',
            message:
                'Você possui registros salvos apenas neste aparelho.\n\nSe você sair da conta, as fotos dos comprovantes e os dados só poderão ser sincronizados se você entrar novamente com este mesmo usuário neste mesmo celular.\n\nTem certeza que deseja sair mesmo assim?',
            confirmText: 'Sair mesmo assim',
            cancelText: 'Cancelar e manter conectado',
            isDestructive: true,
            icon: LucideIcons.alertOctagon,
            onConfirm: () {},
            onCancel: () {},
          ),
          size: const Size(800, 300),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Atenção Crítica'), findsOneWidget);
    });

    testWidgets('CategoriaSelectorGrid adapta para 4 colunas em telas largas (horizontal)', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 360));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        wrapInLandscapeApp(
          SingleChildScrollView(
            child: CategoriaSelectorGrid(
              selectedCategoria: CategoriaDespesa.abastecimento,
              onSelected: (_) {},
            ),
          ),
          size: const Size(800, 360),
        ),
      );

      expect(tester.takeException(), isNull);
      final grid = tester.widget<GridView>(find.byType(GridView));
      final delegate = grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 4);
    });

    testWidgets('ComprovantePickerWidget modal não estoura na horizontal (320px de altura)', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 320));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        wrapInLandscapeApp(
          ComprovantePickerWidget(
            selectedImage: null,
            onImageChanged: (_, _) {},
          ),
          size: const Size(800, 320),
        ),
      );

      await tester.tap(find.text('Tirar foto ou anexar da galeria'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Anexar Comprovante / Cupom'), findsOneWidget);
    });

    testWidgets('HomeHeaderWidget + HomeJornadaCard + DespesasResumoGastosCard + NovaDespesaSemViagem em landscape', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 320));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final viagem = ViagemCollection()
        ..uuid = 'v1'
        ..origemCidade = 'São Paulo'
        ..origemEstado = 'SP'
        ..destinoCidade = 'Ribeirão Preto'
        ..destinoEstado = 'SP'
        ..kmInicial = 120000
        ..dataInicio = DateTime.now()
        ..status = 'em_andamento'
        ..statusSincronizacao = 'sincronizado';

      final despesaVM = DespesaViewModel();

      await tester.pumpWidget(
        wrapInLandscapeApp(
          SingleChildScrollView(
            child: Column(
              children: [
                const HomeHeaderWidget(
                  userName: 'Luis Felipe Lopes',
                  veiculo: {'modelo': 'Scania R450', 'placa': 'ABC1D23'},
                ),
                HomeJornadaCard(
                  viagemAtiva: viagem,
                  onAcessarViagem: () {},
                ),
                DespesasResumoGastosCard(
                  despesaVM: despesaVM,
                  viagem: viagem,
                ),
                NovaDespesaSemViagem(onVoltar: () {}),
                CidadeEstadoPicker(
                  label: 'Origem',
                  icon: LucideIcons.mapPin,
                  cidade: 'São Paulo',
                  uf: 'SP',
                  onSelected: (_, _) {},
                ),
              ],
            ),
          ),
          size: const Size(800, 320),
        ),
      );

      expect(tester.takeException(), isNull);
    });
  });

  group('NetworkStatusBar - Feedback de Sincronização em Tempo Real', () {
    testWidgets('deve exibir "Sincronizando..." em amarelo por 2s, depois "Sincronizado" em verde por 2s e recolher', (tester) async {
      final syncService = SyncService();
      syncService.isSyncingNotifier.value = false;
      syncService.syncStateNotifier.value = const SyncState(isSyncing: false);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: Column(
              children: [
                NetworkStatusBar(),
              ],
            ),
          ),
        ),
      );

      // Inicialmente recolhida (0px de altura)
      AnimatedContainer container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      expect(container.constraints?.maxHeight, 0.0);

      // Dispara início da sincronização (tentativa 1/3)
      syncService.isSyncingNotifier.value = true;
      syncService.syncStateNotifier.value = const SyncState(
        isSyncing: true,
        currentAttempt: 1,
        maxRetries: 3,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Sincronizando...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      expect(container.constraints?.maxHeight, 32.0);
      expect((container.decoration as BoxDecoration).color, AppColorsExtension.dark.warning);

      // Finaliza sincronização com sucesso rapidamente
      syncService.isSyncingNotifier.value = false;
      syncService.syncStateNotifier.value = const SyncState(
        isSyncing: false,
        currentAttempt: 1,
        maxRetries: 3,
        lastSyncSuccess: true,
      );
      await tester.pump();

      // Antes de 2s continua em "Sincronizando..."
      await tester.pump(const Duration(milliseconds: 1000));
      expect(find.text('Sincronizando...'), findsOneWidget);

      // Após completar 2s de "Sincronizando...", muda para "Sincronizado" em verde (success)
      await tester.pump(const Duration(milliseconds: 1100));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Sincronizado'), findsOneWidget);
      container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      expect(container.constraints?.maxHeight, 32.0);
      expect((container.decoration as BoxDecoration).color, AppColorsExtension.dark.success);

      // Após mais 2s em "Sincronizado", recolhe suavemente
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(milliseconds: 300));
      container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      expect(container.constraints?.maxHeight, 0.0);
    });

    testWidgets('deve exibir tentativas (1/3, 2/3, 3/3) em amarelo quando houver retentativas', (tester) async {
      final syncService = SyncService();
      syncService.isSyncingNotifier.value = false;
      syncService.syncStateNotifier.value = const SyncState(isSyncing: false);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: Column(
              children: [
                NetworkStatusBar(),
              ],
            ),
          ),
        ),
      );

      // Tentativa 2/3
      syncService.isSyncingNotifier.value = true;
      syncService.syncStateNotifier.value = const SyncState(
        isSyncing: true,
        currentAttempt: 2,
        maxRetries: 3,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Sincronizando... (tentativa 2/3)'), findsOneWidget);

      // Tentativa 3/3
      syncService.syncStateNotifier.value = const SyncState(
        isSyncing: true,
        currentAttempt: 3,
        maxRetries: 3,
      );
      await tester.pump();
      expect(find.text('Sincronizando... (tentativa 3/3)'), findsOneWidget);

      // Falha após as 3 tentativas (não deve exibir "Sincronizado" em verde)
      syncService.isSyncingNotifier.value = false;
      syncService.syncStateNotifier.value = const SyncState(
        isSyncing: false,
        currentAttempt: 3,
        maxRetries: 3,
        lastSyncSuccess: false,
      );
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Sincronizado'), findsNothing);
    });
  });
}
