// lib/features/auth/redefinir_senha_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../routes.dart';
import 'auth_viewmodel.dart';

class RedefinirSenhaPage extends StatefulWidget {
  final String? initialToken;

  const RedefinirSenhaPage({
    super.key,
    this.initialToken,
  });

  @override
  State<RedefinirSenhaPage> createState() => _RedefinirSenhaPageState();
}

class _RedefinirSenhaPageState extends State<RedefinirSenhaPage> {
  late final TextEditingController _tokenController;
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();

  bool _sucesso = false;
  bool _obscureSenha = true;
  bool _obscureConfirmar = true;

  @override
  void initState() {
    super.initState();
    _tokenController = TextEditingController(text: widget.initialToken ?? '');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_tokenController.text.isEmpty) {
      final routeArg = ModalRoute.of(context)?.settings.arguments;
      if (routeArg is String && routeArg.isNotEmpty) {
        _tokenController.text = routeArg;
      }
    }
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    final token = _tokenController.text.trim();
    final senha = _senhaController.text;
    final confirmar = _confirmarSenhaController.text;

    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, informe o token de recuperação.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (senha.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A senha deve ter no mínimo 8 caracteres.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (senha != confirmar) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('As senhas não coincidem.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final authVM = context.read<AuthViewModel>();
    final success = await authVM.resetPassword(
      token: token,
      newPassword: senha,
    );

    if (mounted) {
      if (success) {
        setState(() {
          _sucesso = true;
        });
      } else if (authVM.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authVM.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    final isLoading = authVM.isLoadingReset;
    final hasToken = (widget.initialToken != null && widget.initialToken!.isNotEmpty) ||
        _tokenController.text.isNotEmpty;

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
            // Header Section
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 48, bottom: 32),
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
                    const SizedBox(height: 6),
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

            // Form / Content Section
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
                  vertical: 32.0,
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_sucesso) ...[
                        // Estado de Sucesso (idêntico ao painel web)
                        const SizedBox(height: 16),
                        Center(
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.success.withValues(alpha: 0.35),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.check_circle_outline,
                              color: AppColors.success,
                              size: 40,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Senha atualizada com sucesso!',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Sua nova senha foi salva. Você já pode fazer login normalmente no aplicativo.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              Routes.login,
                              (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 54),
                          ),
                          child: const Text('Ir para o Login'),
                        ),
                      ] else ...[
                        // Estado Inicial do Formulário
                        Text(
                          'Nova Senha',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Escolha uma nova senha forte para acessar sua conta.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        // Input Token (exibe apenas se não veio pelo link inicial)
                        if (!hasToken) ...[
                          Text(
                            'Token de recuperação',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _tokenController,
                            decoration: InputDecoration(
                              hintText: 'Cole o token recebido no e-mail',
                              prefixIcon: const Icon(
                                LucideIcons.key,
                                color: AppColors.textHint,
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(LucideIcons.clipboardPaste),
                                tooltip: 'Colar da área de transferência',
                                onPressed: () async {
                                  final data = await Clipboard.getData(Clipboard.kTextPlain);
                                  if (data?.text != null && data!.text!.isNotEmpty) {
                                    setState(() {
                                      _tokenController.text = data.text!.trim();
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Input Nova Senha
                        Text(
                          'Nova Senha',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _senhaController,
                          obscureText: _obscureSenha,
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: AppColors.textHint,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureSenha ? Icons.visibility_off : Icons.visibility,
                                color: AppColors.textHint,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureSenha = !_obscureSenha;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Input Confirmar Nova Senha
                        Text(
                          'Confirmar Nova Senha',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _confirmarSenhaController,
                          obscureText: _obscureConfirmar,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _handleSubmit(),
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: AppColors.textHint,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmar ? Icons.visibility_off : Icons.visibility,
                                color: AppColors.textHint,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmar = !_obscureConfirmar;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Botão Redefinir
                        ElevatedButton(
                          onPressed: isLoading ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 54),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.textPrimary,
                                  ),
                                )
                              : const Text('Redefinir Senha'),
                        ),
                      ],

                      const Spacer(),
                      const SizedBox(height: 24),

                      // Botão Voltar para o Login com ArrowLeft
                      Center(
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              Routes.login,
                              (route) => false,
                            );
                          },
                          icon: const Icon(
                            LucideIcons.arrowLeft,
                            size: 18,
                            color: AppColors.textSecondary,
                          ),
                          label: Text(
                            'Voltar para o login',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
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
