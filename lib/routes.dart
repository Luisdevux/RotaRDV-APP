// lib/routes.dart

import 'package:flutter/material.dart';
import 'features/auth/login_page.dart';
import 'features/main_navigation/main_navigation_shell.dart';
import 'features/viagem/nova_viagem_page.dart';
import 'features/viagem/viagens_list_page.dart';
import 'features/despesas/nova_despesa_page.dart';
import 'features/despesas/despesas_viagem_page.dart';
import 'features/perfil/perfil_page.dart';

// Define as rotas da aplicação, associando cada rota a uma página específica
class Routes {
  static const String login = '/login';
  static const String home = '/home';
  static const String novaViagem = '/nova_viagem';
  static const String viagens = '/viagens';
  static const String novaDespesa = '/nova_despesa';
  static const String despesas = '/despesas';
  static const String perfil = '/perfil';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (_) => const LoginPage(),
      home: (_) => const MainNavigationShell(),
      novaViagem: (_) => const NovaViagemPage(),
      viagens: (_) => const ViagensListPage(),
      novaDespesa: (_) => const NovaDespesaPage(),
      despesas: (_) => const DespesasViagemPage(),
      perfil: (_) => const PerfilPage(),
    };
  }
}
