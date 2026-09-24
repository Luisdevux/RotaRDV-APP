// lib/features/auth/widgets/reauth_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/network/dio_client.dart';
import '../../../services/sync_service.dart';
import '../auth_viewmodel.dart';

class ReauthBottomSheet extends StatefulWidget {
  final String? initialEmail;

  const ReauthBottomSheet({super.key, this.initialEmail});

  static Future<bool?> show(BuildContext context, {String? email}) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReauthBottomSheet(initialEmail: email),
    );
  }

  @override
  State<ReauthBottomSheet> createState() => _ReauthBottomSheetState();
}

class _ReauthBottomSheetState extends State<ReauthBottomSheet> {
  late final TextEditingController _emailController;
  final TextEditingController _senhaController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _handleLocalReauth() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      setState(() {
        _errorMessage = 'Preencha o e-mail e a senha para continuar.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authVM = context.read<AuthViewModel>();
    final success = await authVM.login(email, senha);

    if (!mounted) return;

    if (success) {
      DioClient.resetSessionExpired();
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sessão revalidada com sucesso! Sincronizando dados pendentes...'),
          backgroundColor: AppColors.success,
        ),
      );
      SyncService().syncAll();
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = authVM.errorMessage ?? 'Credenciais incorretas. Tente novamente.';
      });
    }
  }

  Future<void> _handleGoogleReauth() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authVM = context.read<AuthViewModel>();
    final success = await authVM.loginWithGoogle();

    if (!mounted) return;

    if (success) {
      DioClient.resetSessionExpired();
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sessão revalidada via Google! Sincronizando dados pendentes...'),
          backgroundColor: AppColors.success,
        ),
      );
      SyncService().syncAll();
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = authVM.errorMessage ?? 'Falha ao autenticar com o Google.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        border: Border(
          top: BorderSide(color: colors.borderSubtle),
          left: BorderSide(color: colors.borderSubtle),
          right: BorderSide(color: colors.borderSubtle),
        ),
      ),
      padding: EdgeInsets.only(
        top: AppSpacing.md,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 44,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header com ícone de alerta
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colors.warning.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.shieldAlert,
                    color: colors.warning,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reconectar Sessão',
                        style: GoogleFonts.lexend(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Seus dados locais estão 100% salvos e seguros',
                        style: GoogleFonts.lexend(
                          fontSize: 12,
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // Card informativo
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.warning.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: colors.warning.withValues(alpha: 0.25)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(LucideIcons.info, size: 16, color: colors.warning),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Sua sessão remota expirou após o período offline. Digite sua senha ou use o Google para restabelecer a sincronização com a central.',
                      style: GoogleFonts.lexend(
                        fontSize: 12,
                        color: colors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: colors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: colors.error.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(LucideIcons.alertCircle, size: 16, color: colors.error),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: GoogleFonts.lexend(fontSize: 12, color: colors.error),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: AppSpacing.lg),

            // Campo de e-mail
            Text(
              'E-mail',
              style: GoogleFonts.lexend(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              enabled: !_isLoading,
              style: GoogleFonts.lexend(fontSize: 14, color: colors.textPrimary),
              decoration: InputDecoration(
                hintText: 'motorista@transportes.com',
                prefixIcon: Icon(LucideIcons.mail, size: 18, color: colors.textMuted),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Campo de senha
            Text(
              'Senha',
              style: GoogleFonts.lexend(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _senhaController,
              obscureText: _obscurePassword,
              enabled: !_isLoading,
              style: GoogleFonts.lexend(fontSize: 14, color: colors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Sua senha de acesso',
                prefixIcon: Icon(LucideIcons.lock, size: 18, color: colors.textMuted),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? LucideIcons.eyeOff : LucideIcons.eye,
                    size: 18,
                    color: colors.textMuted,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              onSubmitted: (_) => _handleLocalReauth(),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Botão Reconectar
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _handleLocalReauth,
              icon: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(LucideIcons.refreshCw, size: 18),
              label: Text(
                _isLoading ? 'Reconectando...' : 'Reconectar e Sincronizar',
                style: GoogleFonts.lexend(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // Botão Google
            OutlinedButton.icon(
              onPressed: _isLoading ? null : _handleGoogleReauth,
              icon: const Icon(LucideIcons.globe, size: 18),
              label: Text(
                'Entrar com Google',
                style: GoogleFonts.lexend(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colors.border),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
              ),
            ),

            const SizedBox(height: AppSpacing.xs),

            // Botão Continuar Offline
            TextButton(
              onPressed: _isLoading ? null : () => Navigator.pop(context, false),
              child: Text(
                'Continuar operando offline',
                style: GoogleFonts.lexend(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
