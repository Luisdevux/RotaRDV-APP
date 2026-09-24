// lib/services/auth_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../core/database/local_database.dart';
import '../core/network/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Serviço responsável por autenticação de usuários (login, logout, refresh token)
class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
      'openid',
    ],
    serverClientId: dotenv.env['GOOGLE_CLIENT_ID'],
  );

  Future<Map<String, dynamic>?> login(String email, String senha) async {
    try {
      final response = await ApiClient.post(
        '/login',
        body: {
          'email': email,
          'senha': senha,
        },
        requiresAuth: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['customMessage'] ?? error['message'] ?? 'Erro ao fazer login.');
      }
    } catch (e) {
      debugPrint('Erro no login local: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      // 1. Iniciar o fluxo do Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // Usuário cancelou o login
        return null;
      }

      // 2. Obter os detalhes da autenticação (onde fica o idToken)
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception('Não foi possível obter o ID Token do Google.');
      }

      // 3. Enviar o token para a API Node.js
      final response = await ApiClient.post(
        '/google',
        body: {'idToken': idToken},
        requiresAuth: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Erro ao autenticar na API');
      }
    } catch (e) {
      debugPrint('Erro no login com Google: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> refreshToken(String refreshToken) async {
    try {
      final response = await ApiClient.post(
        '/refresh',
        body: {'refresh_token': refreshToken},
        requiresAuth: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['customMessage'] ?? error['message'] ?? 'Falha ao renovar sessão.');
      }
    } catch (e) {
      debugPrint('Erro ao renovar token na API: $e');
      rethrow;
    }
  }

  Future<void> signOut({bool clearDatabase = false}) async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint('[AuthService] Erro ao deslogar Google: $e');
    }

    // Apenas limpa o banco se explicitamente solicitado (ex: troca de usuário confirmada)
    if (clearDatabase) {
      final isar = LocalDatabase.isar;
      await isar.writeTxn(() async {
        await isar.clear();
      });
      debugPrint('[AuthService] Banco Isar limpo com segurança.');
    } else {
      debugPrint('[AuthService] Banco Isar preservado para integridade offline.');
    }

    final prefs = await SharedPreferences.getInstance();

    // Preserva o último email e ID logado para validação em próximos logins
    final userStr = prefs.getString('currentUser');
    if (userStr != null) {
      try {
        final userMap = jsonDecode(userStr);
        if (userMap['email'] != null) {
          await prefs.setString('lastUserEmail', userMap['email'].toString());
        }
        final uid = userMap['_id'] ?? userMap['id'];
        if (uid != null) {
          await prefs.setString('lastUserId', uid.toString());
        }
      } catch (_) {}
    }

    // Remove apenas as chaves de sessão ativa, preservando configurações e logs
    await prefs.remove('currentUser');
    await prefs.remove('currentVehicle');
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.remove('last_pull_sync_date');
  }
}



