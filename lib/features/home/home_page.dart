import 'package:flutter/material.dart';
import 'package:app_despesas/core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:app_despesas/features/auth/auth_viewmodel.dart';
import 'package:app_despesas/routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () async {
            final authVM = context.read<AuthViewModel>();
            await authVM.logout();
            if (context.mounted) {
              Navigator.of(context).pushReplacementNamed(Routes.login);
            }
          },
          icon: const Icon(Icons.logout),
          label: const Text('Sair'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
        ),
      ),
    );
  }
}
