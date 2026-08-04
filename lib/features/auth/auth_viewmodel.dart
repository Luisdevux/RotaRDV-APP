import 'package:flutter/foundation.dart';
import '../../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
        await prefs.setString('currentUser', jsonEncode(currentUser));
        await prefs.setString('accessToken', accessToken);
        if (refreshToken.isNotEmpty) {
          await prefs.setString('refreshToken', refreshToken);
        }

        isLoadingLocal = false;
        notifyListeners();
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
        await prefs.setString('currentUser', jsonEncode(currentUser));
        await prefs.setString('accessToken', accessToken);
        if (refreshToken.isNotEmpty) {
          await prefs.setString('refreshToken', refreshToken);
        }

        isLoadingGoogle = false;
        notifyListeners();
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

  Future<void> logout() async {
    await _authService.signOut();
    currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUser');
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
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

