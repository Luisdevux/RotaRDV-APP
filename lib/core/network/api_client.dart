import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

class ApiClient {
  static String get baseUrl => ApiConstants.baseUrl;

  /// Monta os headers padrão incluindo o token JWT caso a requisição exija autenticação
  static Future<Map<String, String>> _buildHeaders({
    Map<String, String>? customHeaders,
    bool requiresAuth = true,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }

    if (requiresAuth) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  /// Tenta renovar o Access Token usando o Refresh Token salvo
  static Future<String?> _refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedRefreshToken = prefs.getString('refreshToken');

      if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
        debugPrint('[ApiClient] Nenhum refresh token disponível no SharedPreferences.');
        return null;
      }

      final url = Uri.parse('$baseUrl/refresh');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': storedRefreshToken}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final user = data['data']?['user'];
        if (user != null) {
          final newAccessToken = user['accessToken'] ?? user['accesstoken'] ?? '';
          final newRefreshToken = user['refreshToken'] ?? user['refreshtoken'] ?? storedRefreshToken;

          if (newAccessToken.isNotEmpty) {
            await prefs.setString('accessToken', newAccessToken);
            await prefs.setString('refreshToken', newRefreshToken);
            debugPrint('[ApiClient] Token renovado com sucesso via Interceptor!');
            return newAccessToken;
          }
        }
      }
      debugPrint('[ApiClient] Falha na resposta do endpoint /refresh: ${response.body}');
      return null;
    } catch (e) {
      debugPrint('[ApiClient] Erro ao tentar renovar token: $e');
      return null;
    }
  }

  /// Executa requisição com interceptor para renovação de token caso expire (401/498)
  static Future<http.Response> _sendWithRetry(
    Future<http.Response> Function(Map<String, String> headers) requestFn, {
    Map<String, String>? customHeaders,
    bool requiresAuth = true,
  }) async {
    var headers = await _buildHeaders(customHeaders: customHeaders, requiresAuth: requiresAuth);
    var response = await requestFn(headers);

    // Se a API retornar 401, 498 ou mensagem de expiração do JWT, tenta renovar e refazer a requisição
    if (requiresAuth && (response.statusCode == 401 || response.statusCode == 498 || response.body.contains('expirado'))) {
      debugPrint('[ApiClient] Token expirado detectado (${response.statusCode}). Tentando renovação...');
      final newToken = await _refreshToken();
      if (newToken != null && newToken.isNotEmpty) {
        headers = await _buildHeaders(customHeaders: customHeaders, requiresAuth: requiresAuth);
        response = await requestFn(headers);
      }
    }

    return response;
  }

  /*────────────────── MÉTODOS HTTP PÚBLICOS ──────────────────*/

  static Future<http.Response> get(
    String path, {
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) async {
    final endpoint = path.startsWith('http') ? path : '$baseUrl$path';
    final url = Uri.parse(endpoint);

    return _sendWithRetry(
      (h) => http.get(url, headers: h),
      customHeaders: headers,
      requiresAuth: requiresAuth,
    );
  }

  static Future<http.Response> post(
    String path, {
    dynamic body,
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) async {
    final endpoint = path.startsWith('http') ? path : '$baseUrl$path';
    final url = Uri.parse(endpoint);
    final encodedBody = body is String ? body : jsonEncode(body);

    return _sendWithRetry(
      (h) => http.post(url, headers: h, body: encodedBody),
      customHeaders: headers,
      requiresAuth: requiresAuth,
    );
  }

  static Future<http.Response> put(
    String path, {
    dynamic body,
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) async {
    final endpoint = path.startsWith('http') ? path : '$baseUrl$path';
    final url = Uri.parse(endpoint);
    final encodedBody = body is String ? body : jsonEncode(body);

    return _sendWithRetry(
      (h) => http.put(url, headers: h, body: encodedBody),
      customHeaders: headers,
      requiresAuth: requiresAuth,
    );
  }

  static Future<http.Response> patch(
    String path, {
    dynamic body,
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) async {
    final endpoint = path.startsWith('http') ? path : '$baseUrl$path';
    final url = Uri.parse(endpoint);
    final encodedBody = body is String ? body : jsonEncode(body);

    return _sendWithRetry(
      (h) => http.patch(url, headers: h, body: encodedBody),
      customHeaders: headers,
      requiresAuth: requiresAuth,
    );
  }

  static Future<http.Response> delete(
    String path, {
    dynamic body,
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) async {
    final endpoint = path.startsWith('http') ? path : '$baseUrl$path';
    final url = Uri.parse(endpoint);
    final encodedBody = body != null ? (body is String ? body : jsonEncode(body)) : null;

    return _sendWithRetry(
      (h) => http.delete(url, headers: h, body: encodedBody),
      customHeaders: headers,
      requiresAuth: requiresAuth,
    );
  }
}
