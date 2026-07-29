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
      if (result != null) {
        currentUser = result['data']['user'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('currentUser', jsonEncode(currentUser));
        await prefs.setString('accessToken', result['data']['user']['accessToken']);
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
      if (result != null) {
        currentUser = result['data']['user'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('currentUser', jsonEncode(currentUser));
        await prefs.setString('accessToken', result['data']['user']['accessToken']);
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
    notifyListeners();
  }

  Future<bool> checkAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      if (token != null && token.isNotEmpty) {
        final userStr = prefs.getString('currentUser');
        if (userStr != null) {
          currentUser = jsonDecode(userStr);
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
}

}
