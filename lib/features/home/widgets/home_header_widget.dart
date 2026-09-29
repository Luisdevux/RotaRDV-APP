// lib/features/home/widgets/home_header_widget.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';

// Componente modular para exibição da identificação do condutor, foto de perfil e os dados essenciais do veículo vinculado à operação
class HomeHeaderWidget extends StatelessWidget {
  final String userName;
  final String? userPhotoUrl;
  final Map<String, dynamic>? veiculo;

  const HomeHeaderWidget({
    super.key,
    required this.userName,
    this.userPhotoUrl,
    this.veiculo,
  });

  String _formatFirstName(String fullName) {
    final first = fullName.trim().split(' ').first;
    if (first.isEmpty) return 'Motorista';
    return '${first[0].toUpperCase()}${first.substring(1).toLowerCase()}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: userPhotoUrl != null
                  ? Image.network(
                      userPhotoUrl!,
                      width: 52,
                      height: 52,
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
                  'Olá, ${_formatFirstName(userName)}',
                  style: GoogleFonts.lexend(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  veiculo != null
                      ? '${veiculo!['modelo'] ?? 'Caminhão'} • ${veiculo!['placa'] ?? 'Placa N/D'}'
                      : 'Motorista cadastrado',
                  style: GoogleFonts.lexend(
                    fontSize: 12,
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarFallback(AppColorsExtension colors) {
    return Container(
      color: colors.primary.withValues(alpha: 0.12),
      child: Icon(
        LucideIcons.user,
        color: colors.primary,
        size: 36,
      ),
    );
  }
}
