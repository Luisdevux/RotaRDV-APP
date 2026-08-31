import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import '../../core/database/local_database.dart';
import '../../models/viagem_collection.dart';
import '../sync/sync_service.dart';
import '../auth/auth_viewmodel.dart';

class HomeViewModel extends ChangeNotifier {
  final SyncService _syncService = SyncService();
  AuthViewModel authViewModel;

  bool isLoading = true;
  List<ViagemCollection> ultimasViagens = [];
  VoidCallback? _syncListener;

  HomeViewModel(this.authViewModel) {
    _syncListener = () {
      carregarDadosBancoLocal();
    };
    _syncService.syncEventNotifier.addListener(_syncListener!);
  }

  @override
  void dispose() {
    if (_syncListener != null) {
      _syncService.syncEventNotifier.removeListener(_syncListener!);
    }
    super.dispose();
  }

  Future<void> init() async {
    isLoading = true;
    notifyListeners();

    // Carrega imediatamente os dados locais do Isar
    await carregarDadosBancoLocal();

    // Remove o loading da tela
    isLoading = false;
    notifyListeners();

    // Em segundo plano, dispara a sincronização completa (Push pendências -> Pull novidades) com até 3 tentativas
    try {
      await _syncService.syncAll();
      await carregarDadosBancoLocal();
    } catch (e) {
      debugPrint('[HomeViewModel] API indisponível ou offline. Dados locais preservados: $e');
    }
  }

  Future<void> carregarDadosBancoLocal() async {
    final isar = LocalDatabase.isar;

    // Busca as viagens ordenando as mais recentes primeiro e limitando a 3 para a home
    final viagensLocal = await isar.viagemCollections
        .where()
        .filter()
        .not().statusSincronizacaoEqualTo('deletado')
        .sortByDataInicioDesc()
        .limit(3)
        .findAll();

    ultimasViagens = viagensLocal;
    notifyListeners();
  }

  Future<void> refresh() async {
    try {
      await _syncService.syncAll();
      await carregarDadosBancoLocal();
    } catch (e) {
      debugPrint('[HomeViewModel] Erro no refresh: $e');
    }
  }
}
