// lib/features/auth/auth_viewmodel.dart

import 'package:flutter/foundation.dart';
import '../../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../core/network/dio_client.dart';
import '../../services/sync_service.dart';
import '../../core/database/local_database.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  bool isLoadingGoogle = false;
  bool isLoadingLocal = false;
  String? errorMessage;
  Map<String, dynamic>? currentUser;

  Future<bool> login(String email, String senha) async {
    isLoadingLocal = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.login(email, senha);
      if (result != null && result['data']?['user'] != null) {
        final user = Map<String, dynamic>.from(result['data']['user']);
        final accessToken = user['accessToken'] ?? user['accesstoken'] ?? '';
        final refreshToken = user['refreshToken'] ?? user['refreshtoken'] ?? '';
        
        user['accessToken'] = accessToken;
        user['refreshToken'] = refreshToken;
        currentUser = user;

        final prefs = await SharedPreferences.getInstance();
        final lastUserId = prefs.getString('lastUserId');
        final currentUserId = (user['_id'] ?? user['id'] ?? '').toString();

        // Se for um usuário DIFERENTE do anterior:
        if (lastUserId != null && lastUserId.isNotEmpty && currentUserId.isNotEmpty && lastUserId != currentUserId) {
          debugPrint('[AuthViewModel] Novo usuário detectado ($lastUserId -> $currentUserId)');
          final hasPending = await SyncService().hasPendingSync();
          if (!hasPending) {
            final isar = LocalDatabase.isar;
            await isar.writeTxn(() async {
              await isar.clear();
            });
            debugPrint('[AuthViewModel] Banco Isar resetado para o novo motorista (sem pendências).');
          } else {
            debugPrint('[AuthViewModel] Há pendências locais do motorista anterior. Registros preservados no Isar.');
          }
        }

        await prefs.setString('currentUser', jsonEncode(currentUser));
        await prefs.setString('accessToken', accessToken);
        if (refreshToken.isNotEmpty) {
          await prefs.setString('refreshToken', refreshToken);
        }
        if (user['veiculo_id'] is Map) {
          await prefs.setString('currentVehicle', jsonEncode(user['veiculo_id']));
        }
        await prefs.setString('lastUserId', currentUserId);
        if (user['email'] != null) {
          await prefs.setString('lastUserEmail', user['email'].toString());
        }

        // Reseta o estado de sessão expirada
        DioClient.resetSessionExpired();

        isLoadingLocal = false;
        notifyListeners();

        // Dispara sincronização em segundo plano imediatamente após reautenticação
        SyncService().syncAll();

        return true;
      }
      isLoadingLocal = false;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
      isLoadingLocal = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    isLoadingGoogle = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.signInWithGoogle();
      if (result != null && result['data']?['user'] != null) {
        final user = Map<String, dynamic>.from(result['data']['user']);
        final accessToken = user['accessToken'] ?? user['accesstoken'] ?? '';
        final refreshToken = user['refreshToken'] ?? user['refreshtoken'] ?? '';
        
        user['accessToken'] = accessToken;
        user['refreshToken'] = refreshToken;
        currentUser = user;

        final prefs = await SharedPreferences.getInstance();
        final lastUserId = prefs.getString('lastUserId');
        final currentUserId = (user['_id'] ?? user['id'] ?? '').toString();

        // Se for um usuário DIFERENTE do anterior:
        if (lastUserId != null && lastUserId.isNotEmpty && currentUserId.isNotEmpty && lastUserId != currentUserId) {
          debugPrint('[AuthViewModel] Novo usuário Google detectado ($lastUserId -> $currentUserId)');
          final hasPending = await SyncService().hasPendingSync();
          if (!hasPending) {
            final isar = LocalDatabase.isar;
            await isar.writeTxn(() async {
              await isar.clear();
            });
            debugPrint('[AuthViewModel] Banco Isar resetado para o novo motorista (sem pendências).');
          } else {
            debugPrint('[AuthViewModel] Há pendências locais do motorista anterior. Registros preservados no Isar.');
          }
        }

        await prefs.setString('currentUser', jsonEncode(currentUser));
        await prefs.setString('accessToken', accessToken);
        if (refreshToken.isNotEmpty) {
          await prefs.setString('refreshToken', refreshToken);
        }
        if (user['veiculo_id'] is Map) {
          await prefs.setString('currentVehicle', jsonEncode(user['veiculo_id']));
        }
        await prefs.setString('lastUserId', currentUserId);
        if (user['email'] != null) {
          await prefs.setString('lastUserEmail', user['email'].toString());
        }

        // Reseta o estado de sessão expirada
        DioClient.resetSessionExpired();

        isLoadingGoogle = false;
        notifyListeners();

        // Dispara sincronização em segundo plano imediatamente após reautenticação
        SyncService().syncAll();

        return true;
      }
      isLoadingGoogle = false;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
      isLoadingGoogle = false;
      notifyListeners();
      return false;
    }
  }

  Map<String, dynamic>? get currentVehicle {
    if (currentUser != null && currentUser!['veiculo_id'] is Map) {
      return Map<String, dynamic>.from(currentUser!['veiculo_id']);
    }
    return null;
  }

  /// Recarrega os dados do motorista e veículo salvos no SharedPreferences
  Future<void> reloadUserFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userStr = prefs.getString('currentUser');
      if (userStr != null) {
        currentUser = Map<String, dynamic>.from(jsonDecode(userStr));
      }
      final vehicleStr = prefs.getString('currentVehicle');
      if (vehicleStr != null && currentUser != null) {
        currentUser!['veiculo_id'] = jsonDecode(vehicleStr);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('[AuthViewModel] Erro ao recarregar dados do usuário: $e');
    }
  }

  /// Busca os dados cadastrais mais recentes do motorista na API (/usuarios/:id)
  Future<void> fetchProfile() async {
    try {
      final userId = currentUser?['_id'] ?? currentUser?['id'];
      if (userId == null) return;

      final response = await DioClient.get('/usuarios/$userId');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        final userData = body['data'];
        if (userData != null && userData is Map) {
          currentUser = {...?currentUser, ...Map<String, dynamic>.from(userData)};
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('currentUser', jsonEncode(currentUser));
          if (userData['veiculo_id'] is Map) {
            await prefs.setString('currentVehicle', jsonEncode(userData['veiculo_id']));
          }
          notifyListeners();
          debugPrint('[AuthViewModel] Perfil do motorista atualizado com sucesso da API.');
        }
      }
    } catch (e) {
      debugPrint('[AuthViewModel] Não foi possível atualizar perfil da API (offline ou erro): $e');
    }
  }

  Future<void> logout({bool clearDatabase = false}) async {
    await _authService.signOut(clearDatabase: clearDatabase);
    currentUser = null;
    notifyListeners();
  }

  Future<bool> checkAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      final refreshToken = prefs.getString('refreshToken');

      if ((token != null && token.isNotEmpty) || (refreshToken != null && refreshToken.isNotEmpty)) {
        final userStr = prefs.getString('currentUser');
        if (userStr != null) {
          currentUser = Map<String, dynamic>.from(jsonDecode(userStr));
          if (token != null) currentUser!['accessToken'] = token;
          if (refreshToken != null) currentUser!['refreshToken'] = refreshToken;

          final vehicleStr = prefs.getString('currentVehicle');
          if (vehicleStr != null) {
            currentUser!['veiculo_id'] = jsonDecode(vehicleStr);
          }
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<String?> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedRefreshToken = prefs.getString('refreshToken') ??
          currentUser?['refreshToken'] ??
          currentUser?['refreshtoken'];

      if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
        debugPrint('Nenhum refresh token disponível.');
        return null;
      }

      final result = await _authService.refreshToken(storedRefreshToken);
      if (result != null && result['data']?['user'] != null) {
        final user = Map<String, dynamic>.from(result['data']['user']);
        final newAccessToken = user['accessToken'] ?? user['accesstoken'] ?? '';
        final newRefreshToken = user['refreshToken'] ?? user['refreshtoken'] ?? storedRefreshToken;

        if (newAccessToken.isNotEmpty) {
          user['accessToken'] = newAccessToken;
          user['refreshToken'] = newRefreshToken;
          currentUser = {...?currentUser, ...user};

          await prefs.setString('currentUser', jsonEncode(currentUser));
          await prefs.setString('accessToken', newAccessToken);
          await prefs.setString('refreshToken', newRefreshToken);
          notifyListeners();
          debugPrint('Token JWT renovado com sucesso via Refresh Token!');
          return newAccessToken;
        }
      }
      return null;
    } catch (e) {
      debugPrint('Erro ao renovar token no AuthViewModel: $e');
      return null;
    }
  }
}

