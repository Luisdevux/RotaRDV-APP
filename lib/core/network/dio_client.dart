// lib/core/network/dio_client.dart

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import '../constants/api_constants.dart';
import 'auth_interceptor.dart';
import 'time_logging_interceptor.dart';

// Cliente centralizado de comunicação HTTP baseado na biblioteca Dio
// Implementa padrão Singleton, interceptores de autenticação (JWT/Refresh Token), medição de tempo de resposta e envio otimizado de arquivos via FormData
class DioClient {
  static late final Dio _dio;
  static bool _initialized = false;

  // Notificador reativo de expiração irrecuperável de sessão (quando refresh token falha)
  static final ValueNotifier<bool> sessionExpiredNotifier = ValueNotifier<bool>(false);

  // Reseta o notificador de expiração de sessão após login bem-sucedido
  static void resetSessionExpired() {
    sessionExpiredNotifier.value = false;
  }

  // Instância centralizada do Dio
  static Dio get instance {
    if (!_initialized) init();
    return _dio;
  }

  // URL base configurada para o ambiente
  static String get baseUrl => _dio.options.baseUrl;

  // Inicializa as configurações base e a cadeia de interceptores do Dio
  static void init() {
    if (_initialized) return;

    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 45),
        responseType: ResponseType.json,
        validateStatus: (status) => status != null && status < 500,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors
      ..add(TimeLoggingInterceptor())
      ..add(AuthInterceptor(dio: dio, sessionExpiredNotifier: sessionExpiredNotifier));

    _dio = dio;
    _initialized = true;
  }

  /*────────────────── MÉTODOS HTTP ──────────────────*/

  static Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
  }) async {
    if (!_initialized) init();
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: Options(
        headers: headers,
        extra: {'requiresAuth': requiresAuth},
      ),
    );
  }

  static Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
  }) async {
    if (!_initialized) init();
    return _dio.post<T>(
      path,
      data: data ?? body,
      queryParameters: queryParameters,
      options: Options(
        headers: headers,
        extra: {'requiresAuth': requiresAuth},
      ),
    );
  }

  static Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
  }) async {
    if (!_initialized) init();
    return _dio.put<T>(
      path,
      data: data ?? body,
      queryParameters: queryParameters,
      options: Options(
        headers: headers,
        extra: {'requiresAuth': requiresAuth},
      ),
    );
  }

  static Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
  }) async {
    if (!_initialized) init();
    return _dio.patch<T>(
      path,
      data: data ?? body,
      queryParameters: queryParameters,
      options: Options(
        headers: headers,
        extra: {'requiresAuth': requiresAuth},
      ),
    );
  }

  static Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
  }) async {
    if (!_initialized) init();
    return _dio.delete<T>(
      path,
      data: data ?? body,
      queryParameters: queryParameters,
      options: Options(
        headers: headers,
        extra: {'requiresAuth': requiresAuth},
      ),
    );
  }

  /// Realiza envio de arquivo (upload de foto de comprovante) utilizando multipart/form-data nativo do Dio
  static Future<Response<T>> uploadFile<T>(
    String path, {
    required File file,
    required String fieldName,
    Map<String, dynamic>? fields,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
  }) async {
    if (!_initialized) init();

    final ext = file.path.split('.').last.toLowerCase();
    final MediaType contentType;
    if (ext == 'png') {
      contentType = MediaType('image', 'png');
    } else if (ext == 'svg') {
      contentType = MediaType('image', 'svg+xml');
    } else {
      contentType = MediaType('image', 'jpeg');
    }

    final multipartFile = await MultipartFile.fromFile(
      file.path,
      contentType: contentType,
    );

    final formData = FormData.fromMap({
      fieldName: multipartFile,
      ...?fields,
    });

    return _dio.post<T>(
      path,
      data: formData,
      options: Options(
        headers: headers,
        extra: {'requiresAuth': requiresAuth},
      ),
    );
  }
}

// Extensão de compatibilidade para Response do Dio, provendo acesso a `.body` serializado
extension ResponseCompatExtension on Response {
  String get body {
    if (data is String) return data as String;
    if (data == null) return '';
    try {
      return jsonEncode(data);
    } catch (_) {
      return data.toString();
    }
  }
}
