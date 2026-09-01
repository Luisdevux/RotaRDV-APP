// lib/services/deep_link_service.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import '../routes.dart';

class DeepLinkService {
  static final AppLinks _appLinks = AppLinks();
  static StreamSubscription<Uri>? _linkSubscription;

  /// Inicializa o listener de Deep Links no Flutter
  static Future<void> init(GlobalKey<NavigatorState> navigatorKey) async {
    // 1. Captura o link inicial caso o app tenha sido aberto a partir do estado fechado
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleUri(initialUri, navigatorKey);
      }
    } catch (e) {
      debugPrint('[DeepLink] Erro ao obter link inicial: $e');
    }

    // 2. Escuta novos links recebidos enquanto o app estiver aberto ou em segundo plano
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        _handleUri(uri, navigatorKey);
      },
      onError: (err) {
        debugPrint('[DeepLink] Erro no stream de deep links: $err');
      },
    );
  }

  /// Trata a rota e ação solicitada pelo Deep Link
  static void _handleUri(Uri uri, GlobalKey<NavigatorState> navigatorKey) {
    debugPrint('[DeepLink] Link recebido: $uri');

    if (uri.scheme == 'rotardv') {
      final context = navigatorKey.currentContext;

      // Caso 1: Verificação de E-mail concluída
      // Exemplo: rotardv://auth/verified
      if (uri.host == 'auth' && (uri.path == '/verified' || uri.path == 'verified')) {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          Routes.login,
          (route) => false,
        );

        if (context != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Color(0xFF2E7D32),
              behavior: SnackBarBehavior.floating,
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'E-mail verificado com sucesso! Faça seu login.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
    }
  }

  /// Cancela o listener quando necessário
  static void dispose() {
    _linkSubscription?.cancel();
  }
}
