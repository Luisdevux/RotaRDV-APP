import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import '../../core/database/local_database.dart';
import '../../models/viagem_collection.dart';
import '../sync/sync_service.dart';
import '../auth/auth_viewmodel.dart';

class HomeViewModel extends ChangeNotifier {
  final SyncService _syncService = SyncService();
  AuthViewModel authViewModel;

  // Começa carregamento
  bool isLoading = true;
  List<ViagemCollection> ultimasViagens = [];

  HomeViewModel(this.authViewModel);

  Future<void> init() async {
    // Garante que o loading reapareça toda vez que entrar na tela
    isLoading = true;
    notifyListeners();

    // Carrega as últimas viagens do banco local que se já sincronizaram com a API
    await carregarDadosBancoLocal();

    // Tira o loading da tela
    isLoading = false;
    notifyListeners();

    // Em 2º plano, o app tenta bater na API para checar os dados mais recentes
    try {
      final token = authViewModel.currentUser?['accessToken'] ?? '';
      await _syncService.pullSync(token);
      // Se trouxer dados novos, atualiza a tela
      await carregarDadosBancoLocal();
    } catch (e) {
      // Se estiver sem internet, ele "falha" silenciosamente e o usuário continua vendo os dados do banco local
      debugPrint("API fora do ar ou usuário sem internet. Mostrando dados do banco local.");
      debugPrint("Erro no pullSync: $e");
    }
  }

  Future<void> carregarDadosBancoLocal() async {
    final isar = LocalDatabase.isar;

    // Busca as viagens ordenando as mais recentes primeiro e limitando a 3 para a home
    final viagensLocal = await isar.viagemCollections
        .where()
        // Filtro para não trazer dados da sincronização com status 'deletado'
        .filter()
        .not().statusSincronizacaoEqualTo('deletado')
        .sortByDataInicioDesc()
        .limit(3)
        .findAll();

    ultimasViagens = viagensLocal;
    notifyListeners(); // Avisa a tela que os dados foram atualizados
  }
}
