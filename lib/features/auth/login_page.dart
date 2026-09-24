// lib/features/auth/login_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_theme.dart';
import 'auth_viewmodel.dart';
import '../../routes.dart';
import '../../core/widgets/network_status_bar.dart';
import '../../core/widgets/app_dialog.dart';
import '../../services/sync_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _obscurePassword = true;
  int _pendingCount = 0;
  String? _lastUserEmail;

  @override
  void initState() {
    super.initState();
    _checkPendingLocalData();
  }

  Future<void> _checkPendingLocalData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastEmail = prefs.getString('lastUserEmail');
      if (lastEmail != null && lastEmail.isNotEmpty) {
        _emailController.text = lastEmail;
        _lastUserEmail = lastEmail;
      }
      final summary = await SyncService().getPendingSyncSummary();
      if (mounted && summary.hasPending) {
        setState(() {
          _pendingCount = summary.totalPendencias;
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    final authVM = context.read<AuthViewModel>();
    final success = await authVM.loginWithGoogle();

    if (success && mounted) {
      Navigator.of(context).pushReplacementNamed(Routes.home);
    } else if (!success && mounted && authVM.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authVM.errorMessage!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _handleLocalLogin() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha o E-mail e a senha.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_pendingCount > 0 &&
        _lastUserEmail != null &&
        _lastUserEmail!.isNotEmpty &&
        email.toLowerCase() != _lastUserEmail!.toLowerCase()) {
      final bool? confirmar = await AppDialog.show(
        context: context,
        title: 'Troca de Motorista',
        message:
            'Existem $_pendingCount registro(s) offline do motorista $_lastUserEmail neste celular.\n\nSe você entrar com $email, os dados locais anteriores serão descartados.\n\nDeseja continuar?',
        confirmText: 'Substituir dados',
        cancelText: 'Cancelar',
        isDestructive: true,
        icon: LucideIcons.alertTriangle,
      );
      if (confirmar != true) return;
    }

    if (!mounted) return;

    final authVM = context.read<AuthViewModel>();
    final success = await authVM.login(email, senha);

    if (success && mounted) {
      Navigator.of(context).pushReplacementNamed(Routes.home);
    } else if (!success && mounted && authVM.errorMessage != null) {
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
    final isLoadingGoogle = authVM.isLoadingGoogle;
    final isLoadingLocal = authVM.isLoadingLocal;
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
                      const SizedBox(height: 16),

                      if (_pendingCount > 0) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
                          ),
                          child: Row(
                            children: [
                              Icon(LucideIcons.cloudAlert, color: AppColors.primary, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Você possui $_pendingCount registro(s) salvo(s) offline neste aparelho. Entre para enviá-los.',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ] else ...[
                        const SizedBox(height: 8),
                      ],

                      // Email Input
                      Text(
                        'E-mail',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'motorista@exemplo.com',
                          prefixIcon: Icon(
                            Icons.email_outlined,
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
                        onPressed: isLoadingLocal ? null : _handleLocalLogin,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 54),
                        ),
                        child: isLoadingLocal
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.textPrimary,
                                ),
                              )
                            : const Row(
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
                        onPressed: isLoadingGoogle
                            ? null
                            : _handleGoogleSignIn,
                        icon: isLoadingGoogle
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
                          isLoadingGoogle
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
