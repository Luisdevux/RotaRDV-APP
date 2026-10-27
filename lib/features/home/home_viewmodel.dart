// lib/features/home/home_viewmodel.dart

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import '../../core/database/local_database.dart';
import '../../core/network/dio_client.dart';
import '../../models/viagem_collection.dart';
import '../../services/sync_service.dart';
import '../auth/auth_viewmodel.dart';

// ViewModel responsável por gerenciar o estado da tela inicial, incluindo carregamento de dados locais, sincronização com a API e gerenciamento de sessão expirada
class HomeViewModel extends ChangeNotifier {
  final SyncService _syncService = SyncService();
  AuthViewModel authViewModel;

  bool isLoading = true;
  List<ViagemCollection> ultimasViagens = [];
  List<ViagemCollection> todasViagens = [];
  VoidCallback? _syncListener;
  VoidCallback? _sessionExpiredListener;

  bool get isSessionExpired => DioClient.sessionExpiredNotifier.value;
  Map<String, dynamic>? get veiculo => authViewModel.currentVehicle;

  HomeViewModel(this.authViewModel) {
    _syncListener = () async {
      await authViewModel.reloadUserFromStorage(notify: false);
      await carregarDadosBancoLocal();
    };
    _syncService.syncEventNotifier.addListener(_syncListener!);

    _sessionExpiredListener = () {
      notifyListeners();
    };
    DioClient.sessionExpiredNotifier.addListener(_sessionExpiredListener!);
  }

  @override
  void dispose() {
    if (_syncListener != null) {
      _syncService.syncEventNotifier.removeListener(_syncListener!);
    }
    if (_sessionExpiredListener != null) {
      DioClient.sessionExpiredNotifier.removeListener(_sessionExpiredListener!);
    }
    super.dispose();
  }

  Future<void> init() async {
    isLoading = true;
    notifyListeners();

    // Carrega imediatamente os dados locais do Isar e usuário em cache
    await authViewModel.reloadUserFromStorage(notify: false);
    await carregarDadosBancoLocal();

    // Remove o loading da tela
    isLoading = false;
    notifyListeners();

    // Em segundo plano, atualiza perfil e sincroniza viagens e despesas
    try {
      await authViewModel.fetchProfile();
      await _syncService.syncAll();
      await authViewModel.reloadUserFromStorage(notify: false);
      await carregarDadosBancoLocal();
    } catch (e) {
      debugPrint('[HomeViewModel] API indisponível ou offline. Dados locais preservados: $e');
    }
  }

  Future<void> carregarDadosBancoLocal() async {
    final isar = LocalDatabase.isar;

    // Busca todas as viagens ordenando as mais recentes primeiro (para histórico completo) e deriva as 3 últimas para a Home
    final viagensLocal = await isar.viagemCollections
        .where()
        .filter()
        .not().statusSincronizacaoEqualTo('deletado')
        .sortByDataInicioDesc()
        .findAll();

    todasViagens = viagensLocal;
    ultimasViagens = viagensLocal.take(3).toList();
    notifyListeners();
  }

  Future<void> refresh() async {
    try {
      await authViewModel.fetchProfile(force: true);
      await _syncService.syncAll();
      await authViewModel.reloadUserFromStorage(notify: false);
      await carregarDadosBancoLocal();
    } catch (e) {
      debugPrint('[HomeViewModel] Erro no refresh: $e');
    }
  }
}
