import 'package:flutter/material.dart';
import 'package:app_despesas/features/auth/presentation/pages/login_page.dart';
import 'package:app_despesas/features/home/home_page.dart';

class Routes {
  static const String login = '/login';
  static const String home = '/home';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (_) => const LoginPage(),
      home: (_) => const HomePage(),
    };
  }
}
