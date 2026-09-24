// lib/core/network/time_logging_interceptor.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

// Interceptador para auditoria e medição de desempenho de requisições HTTP
// Calcula e registra no console de desenvolvimento o tempo de resposta das chamadas de rede
class TimeLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['startTime'] = DateTime.now();
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra['startTime'] as DateTime?;
    if (startTime != null && kDebugMode) {
      final duration = DateTime.now().difference(startTime);
      debugPrint(
        '[DioClient] [${response.requestOptions.method}] ${response.requestOptions.uri} '
        'concluído em ${duration.inMilliseconds}ms (Status: ${response.statusCode})',
      );
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime = err.requestOptions.extra['startTime'] as DateTime?;
    if (startTime != null && kDebugMode) {
      final duration = DateTime.now().difference(startTime);
      debugPrint(
        '[DioClient] [FALHA] ${err.requestOptions.method} ${err.requestOptions.uri} '
        'em ${duration.inMilliseconds}ms: ${err.message}',
      );
    }
    super.onError(err, handler);
  }
}
