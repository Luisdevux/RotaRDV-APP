import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_despesas/core/network/dio_client.dart';
import 'package:app_despesas/core/network/time_logging_interceptor.dart';

void main() {
  group('DioClient & ResponseCompatExtension', () {
    test('ResponseCompatExtension deve fornecer .body compatível com string e json', () {
      final responseMap = Response(
        requestOptions: RequestOptions(path: '/teste'),
        data: {'mensagem': 'sucesso', 'codigo': 200},
        statusCode: 200,
      );

      expect(responseMap.body, contains('sucesso'));
      final decoded = jsonDecode(responseMap.body);
      expect(decoded['mensagem'], 'sucesso');
      expect(decoded['codigo'], 200);

      final responseStr = Response(
        requestOptions: RequestOptions(path: '/teste-str'),
        data: '{"status":"ok"}',
        statusCode: 200,
      );
      expect(responseStr.body, '{"status":"ok"}');

      final responseNull = Response(
        requestOptions: RequestOptions(path: '/teste-null'),
        data: null,
        statusCode: 204,
      );
      expect(responseNull.body, '');
    });

    test('DioClient deve inicializar instância singleton com interceptores de tempo e autenticação', () {
      DioClient.init();
      final dio = DioClient.instance;

      expect(dio, isNotNull);
      expect(dio.interceptors.any((i) => i is TimeLoggingInterceptor), isTrue);
    });

    test('resetSessionExpired deve resetar notificador de sessão', () {
      DioClient.sessionExpiredNotifier.value = true;
      expect(DioClient.sessionExpiredNotifier.value, isTrue);

      DioClient.resetSessionExpired();
      expect(DioClient.sessionExpiredNotifier.value, isFalse);
    });
  });
}
