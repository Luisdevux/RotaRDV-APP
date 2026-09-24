// lib/features/perfil/widgets/perfil_motorista_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';

// Componente modular que renderiza as informações de identidade do motorista, incluindo avatar com fallback, documentos habilitatórios (CNH, CPF) e vínculo com a transportadora
class PerfilMotoristaCard extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasPhoto = widget.userPhotoUrl != null && widget.userPhotoUrl!.trim().isNotEmpty;

    return Column(
      children: [
        // Bloco de Identificação e Avatar
        AppCard(
          backgroundColor: colors.cardBackground,
          borderColor: colors.borderSubtle,
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: hasPhoto
                      ? Image.network(
                          widget.userPhotoUrl!,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildAvatarFallback(colors),
                        )
                      : _buildAvatarFallback(colors),
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
                              color: colors.primary,
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
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.10),
                            borderRadius: AppRadius.smRadius,
                          ),
                          child: Icon(LucideIcons.idCard, size: 18, color: colors.primary),
                        ),
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

  Widget _buildAvatarFallback(AppColorsExtension colors) {
    return Container(
      width: 64,
      height: 64,
      color: colors.primary.withValues(alpha: 0.12),
      child: Icon(
        LucideIcons.user,
        color: colors.primary,
        size: 32,
      ),
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
