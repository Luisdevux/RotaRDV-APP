import 'package:flutter/foundation.dart';
import 'package:app_despesas/services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  bool isLoadingGoogle = false;
  String? errorMessage;
  Map<String, dynamic>? currentUser;

  Future<bool> loginWithGoogle() async {
    isLoadingGoogle = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.signInWithGoogle();
      if (result != null) {
        currentUser = result['data']['user'];
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
}
