import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:app_despesas/core/theme/app_theme.dart';
import 'package:app_despesas/features/auth/auth_viewmodel.dart';
import 'package:app_despesas/routes.dart';
import 'package:app_despesas/core/widgets/network_status_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _cpfController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _obscurePassword = true;

  final _cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: { "#": RegExp(r'[0-9]') },
  );

  @override
  void dispose() {
    _cpfController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    final authVM = context.read<AuthViewModel>();
    final success = await authVM.loginWithGoogle();

    if (!mounted) return;

    if (success && authVM.currentUser != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bem-vindo, ${authVM.currentUser!['nome']}!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pushReplacementNamed(context, Routes.home);
    } else if (authVM.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authVM.errorMessage!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    final _isLoadingGoogle = authVM.isLoadingGoogle;
    return Scaffold(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Theme.of(context).colorScheme.surface,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            // Barra Animada de Conexão
            const SliverToBoxAdapter(
              child: SafeArea(bottom: false, child: NetworkStatusBar()),
            ),

            // Header Section
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 24, bottom: 32),
                color: Theme.of(context).appBarTheme.backgroundColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/rotardv-icone.png', height: 64),
                    const SizedBox(height: 12),
                    Text(
                      'RotaRDV',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Controle de Gastos',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Form Section
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 24.0,
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Acesso do Motorista',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // CPF Input
                      Text(
                        'CPF',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _cpfController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [_cpfFormatter],
                        decoration: const InputDecoration(
                          hintText: '000.000.000-00',
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: AppColors.textHint,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Senha Input
                      Text(
                        'Senha',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _senhaController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: AppColors.textHint,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.textHint,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Esqueci minha senha
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Ação esqueci a senha
                          },
                          child: const Text('Esqueci minha senha'),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Botão Entrar
                      ElevatedButton(
                        onPressed: () {
                          // Ação de login
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 54),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Entrar no App'),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Divider "Ou entrar com"
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(color: AppColors.border),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Ou entrar com',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.textHint),
                            ),
                          ),
                          const Expanded(
                            child: Divider(color: AppColors.border),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Botão Google
                      OutlinedButton.icon(
                        onPressed: _isLoadingGoogle
                            ? null
                            : _handleGoogleSignIn,
                        icon: _isLoadingGoogle
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/120px-Google_%22G%22_logo.svg.png',
                                height: 24,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.g_mobiledata, size: 28),
                              ),
                        label: Text(
                          _isLoadingGoogle
                              ? 'Autenticando...'
                              : 'Continuar com Google',
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Visual Support Element
                      const Spacer(),

                      Center(
                        child: Text(
                          '"Boa viagem e dirija com segurança."',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.textSecondary,
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Footer Info Centered
                      Center(
                        child: Text(
                          '© 2026 Registro de Despesas • v1.4.0',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textHint),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
