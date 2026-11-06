// lib/features/perfil/widgets/perfil_motorista_card.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../auth/auth_viewmodel.dart';

// Componente modular que renderiza as informações de identidade do motorista, incluindo avatar com fallback, documentos habilitatórios (CNH, CPF) e vínculo com a transportadora
class PerfilMotoristaCard extends StatefulWidget {
  final String? userId;
  final String userName;
  final String userEmail;
  final String? userPhotoUrl;
  final String? userCpf;
  final String? userCnh;
  final String? userTelefone;
  final String? empresaNome;
  final String? empresaCargo;

  const PerfilMotoristaCard({
    super.key,
    this.userId,
    required this.userName,
    required this.userEmail,
    this.userPhotoUrl,
    this.userCpf,
    this.userCnh,
    this.userTelefone,
    this.empresaNome,
    this.empresaCargo,
  });

  @override
  State<PerfilMotoristaCard> createState() => _PerfilMotoristaCardState();
}

class _PerfilMotoristaCardState extends State<PerfilMotoristaCard> {
  bool _isExpanded = false;

  Future<void> _abrirOpcoesFoto() async {
    final colors = context.colors;
    final localFile = await AvatarCacheService.getLocalAvatar(widget.userId);
    final hasRemote = widget.userPhotoUrl != null && widget.userPhotoUrl!.trim().isNotEmpty;
    final hasPhoto = localFile != null || hasRemote;

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(ctx).size.height * 0.9,
        ),
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
          border: Border(top: BorderSide(color: colors.borderSubtle, width: 1)),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: colors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Foto de perfil',
                style: GoogleFonts.lexend(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tire uma nova foto ou selecione da galeria para seu perfil.',
                style: GoogleFonts.lexend(
                  fontSize: 13,
                  color: colors.textMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: _buildModalOption(
                      ctx,
                      icon: LucideIcons.camera,
                      label: 'Tirar foto',
                      color: colors.primary,
                      onTap: () async {
                        Navigator.pop(ctx);
                        await Future.delayed(const Duration(milliseconds: 150));
                        _selecionarFoto(ImageSource.camera);
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildModalOption(
                      ctx,
                      icon: LucideIcons.image,
                      label: 'Galeria',
                      color: colors.primary,
                      onTap: () async {
                        Navigator.pop(ctx);
                        await Future.delayed(const Duration(milliseconds: 150));
                        _selecionarFoto(ImageSource.gallery);
                      },
                    ),
                  ),
                ],
              ),
              if (hasPhoto) ...[
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _confirmarRemoverFoto();
                    },
                    icon: Icon(LucideIcons.trash2, size: 16, color: colors.error),
                    label: Text(
                      'Remover foto',
                      style: GoogleFonts.lexend(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.error,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colors.error.withValues(alpha: 0.3)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModalOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 26, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.lexend(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selecionarFoto(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
        requestFullMetadata: false,
      );

      if (picked == null) return;
      if (!mounted) return;

      final authVM = context.read<AuthViewModel>();
      final messenger = ScaffoldMessenger.of(context);
      final colors = context.colors;

      messenger.showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
              SizedBox(width: 10),
              Text('Processando foto de perfil...'),
            ],
          ),
          duration: Duration(seconds: 1),
        ),
      );

      final onlineSuccess = await authVM.updateProfilePhoto(File(picked.path));

      if (!mounted) return;
      messenger.hideCurrentSnackBar();

      if (onlineSuccess) {
        messenger.showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(LucideIcons.checkCircle2, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('Foto de perfil atualizada com sucesso!'),
              ],
            ),
            backgroundColor: colors.success,
          ),
        );
      } else {
        messenger.showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(LucideIcons.cloudCheck, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text('Foto atualizada no aparelho. Será enviada ao servidor quando houver conexão.'),
                ),
              ],
            ),
            backgroundColor: colors.warning,
          ),
        );
      }
    } catch (e) {
      debugPrint('[PerfilMotoristaCard] Erro ao selecionar foto: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Não foi possível alterar a foto de perfil.'),
            backgroundColor: context.colors.error,
          ),
        );
      }
    }
  }

  Future<void> _confirmarRemoverFoto() async {
    final messenger = ScaffoldMessenger.of(context);
    final colors = context.colors;
    final authVM = context.read<AuthViewModel>();

    final confirmar = await AppDialog.show(
      context: context,
      title: 'Remover foto',
      message: 'Deseja realmente remover sua foto de perfil?',
      confirmText: 'Remover',
      cancelText: 'Cancelar',
      isDestructive: true,
      icon: LucideIcons.trash2,
    );

    if (confirmar == true && mounted) {
      final success = await authVM.deleteProfilePhoto();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Foto de perfil removida com sucesso.'
                : 'Foto removida no aparelho. A remoção será sincronizada quando houver conexão.',
          ),
          backgroundColor: success ? colors.success : colors.warning,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      children: [
        // Bloco de Identificação e Avatar Interativo
        AppCard(
          backgroundColor: colors.cardBackground,
          borderColor: colors.borderSubtle,
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              GestureDetector(
                onTap: _abrirOpcoesFoto,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AppAvatar(
                      userId: widget.userId,
                      photoUrl: widget.userPhotoUrl,
                      name: widget.userName,
                      size: 64,
                    ),
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: colors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colors.cardBackground,
                            width: 2.5,
                          ),
                        ),
                        child: const Icon(
                          LucideIcons.camera,
                          size: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userName,
                      style: GoogleFonts.lexend(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.userEmail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lexend(
                        fontSize: 12,
                        color: colors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.badgeCheck,
                            size: 12,
                            color: colors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Motorista ativo',
                            style: GoogleFonts.lexend(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.6,
                              color: colors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Bloco de Dados Cadastrais e Documentos
        AppCard(
          backgroundColor: colors.cardBackground,
          borderColor: colors.borderSubtle,
          padding: EdgeInsets.zero,
          child: ClipRRect(
            borderRadius: AppRadius.mdRadius,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Row(
                      children: [
                        Icon(LucideIcons.idCard, size: 20, color: colors.primary),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dados do motorista',
                                style: GoogleFonts.lexend(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: colors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'CPF, CNH e transportadora',
                                style: GoogleFonts.lexend(
                                  fontSize: 12,
                                  color: colors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedRotation(
                          turns: _isExpanded ? 0.5 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          child: Icon(
                            LucideIcons.chevronDown,
                            size: 20,
                            color: colors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox(width: double.infinity),
                  secondChild: Column(
                    children: [
                      Divider(height: 1, color: colors.borderSubtle),
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildPerfilItem(
                              icon: LucideIcons.fileCheck,
                              label: 'CPF',
                              value: widget.userCpf ?? 'Não informado',
                              colors: colors,
                            ),
                            const Divider(height: AppSpacing.lg),
                            _buildPerfilItem(
                              icon: LucideIcons.car,
                              label: 'CNH',
                              value: widget.userCnh ?? 'Não informada',
                              colors: colors,
                            ),
                            if (widget.userTelefone != null && widget.userTelefone!.isNotEmpty) ...[
                              const Divider(height: AppSpacing.lg),
                              _buildPerfilItem(
                                icon: LucideIcons.phone,
                                label: 'Telefone',
                                value: widget.userTelefone!,
                                colors: colors,
                              ),
                            ],
                            if (widget.empresaNome != null && widget.empresaNome!.isNotEmpty) ...[
                              const Divider(height: AppSpacing.lg),
                              _buildPerfilItem(
                                icon: LucideIcons.building2,
                                label: 'Transportadora',
                                value: widget.empresaNome!,
                                subtitle: widget.empresaCargo,
                                colors: colors,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  crossFadeState: _isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 250),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPerfilItem({
    required IconData icon,
    required String label,
    required String value,
    String? subtitle,
    required AppColorsExtension colors,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: colors.textMuted),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.lexend(
                  fontSize: 11,
                  color: colors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.lexend(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              if (subtitle != null && subtitle.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.lexend(
                    fontSize: 11,
                    color: colors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
