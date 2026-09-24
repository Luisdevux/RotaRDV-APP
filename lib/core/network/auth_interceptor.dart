// lib/core/network/auth_interceptor.dart

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

// Interceptador em fila (QueuedInterceptor) responsável pela injeção do token JWT e renovação automática de credenciais via refresh token de forma segura e não bloqueante
class AuthInterceptor extends QueuedInterceptor {
  final Dio dio;
  final ValueNotifier<bool> sessionExpiredNotifier;

  // Instância dedicada isolada do Dio para requisições de renovação de credenciais, evitando recursão infinita e bloqueio de interceptores
  final Dio _tokenDio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  AuthInterceptor({
    required this.dio,
    required this.sessionExpiredNotifier,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final requiresAuth = options.extra['requiresAuth'] ?? true;

    if (requiresAuth) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    final requiresAuth = response.requestOptions.extra['requiresAuth'] ?? true;
    final isRetry = response.requestOptions.extra['isRetry'] ?? false;

    // Se a resposta for 401 ou 498 e ainda não foi feita retentativa
    if (requiresAuth && !isRetry && (response.statusCode == 401 || response.statusCode == 498)) {
      debugPrint('[AuthInterceptor] Resposta ${response.statusCode} detectada. Tentando renovação de token...');
      final novoToken = await _executarRefreshToken();

      if (novoToken != null && novoToken.isNotEmpty) {
        final options = response.requestOptions;
        options.extra['isRetry'] = true;
        options.headers['Authorization'] = 'Bearer $novoToken';

        try {
          final retentativa = await dio.fetch(options);
          return handler.resolve(retentativa);
        } catch (e) {
          debugPrint('[AuthInterceptor] Falha na retentativa após renovação: $e');
        }
      } else {
        sessionExpiredNotifier.value = true;
      }
    }

    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final requiresAuth = err.requestOptions.extra['requiresAuth'] ?? true;
    final isRetry = err.requestOptions.extra['isRetry'] ?? false;

    if (requiresAuth && !isRetry && (statusCode == 401 || statusCode == 498)) {
      debugPrint('[AuthInterceptor] Erro $statusCode recebido. Renovando token via refresh...');
      final novoToken = await _executarRefreshToken();

      if (novoToken != null && novoToken.isNotEmpty) {
        final options = err.requestOptions;
        options.extra['isRetry'] = true;
        options.headers['Authorization'] = 'Bearer $novoToken';

        try {
          final retentativa = await dio.fetch(options);
          return handler.resolve(retentativa);
        } catch (e) {
          debugPrint('[AuthInterceptor] Erro ao reexecutar requisição: $e');
        }
      } else {
        sessionExpiredNotifier.value = true;
      }
    }

    handler.next(err);
  }

  // Executa chamada à rota /refresh da API utilizando o refresh_token armazenado localmente
  Future<String?> _executarRefreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedRefreshToken = prefs.getString('refreshToken');

      if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
        debugPrint('[AuthInterceptor] Nenhum refresh token disponível no armazenamento local.');
        return null;
      }

      final response = await _tokenDio.post(
        '/refresh',
        data: jsonEncode({'refresh_token': storedRefreshToken}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic rawData = response.data;
        final data = rawData is String ? jsonDecode(rawData) : rawData;
        final user = data?['data']?['user'];

        if (user != null) {
          final newAccessToken = user['accessToken'] ?? user['accesstoken'] ?? '';
          final newRefreshToken = user['refreshToken'] ?? user['refreshtoken'] ?? storedRefreshToken;

          if (newAccessToken.isNotEmpty) {
            await prefs.setString('accessToken', newAccessToken);
            await prefs.setString('refreshToken', newRefreshToken);
            sessionExpiredNotifier.value = false;
            debugPrint('[AuthInterceptor] Credenciais renovadas com sucesso!');
            return newAccessToken;
          }
        }
      }

      debugPrint('[AuthInterceptor] Resposta inválida na renovação de credenciais (${response.statusCode})');
      return null;
    } catch (e) {
      debugPrint('[AuthInterceptor] Exceção durante renovação de token: $e');
      return null;
    }
  }
}
