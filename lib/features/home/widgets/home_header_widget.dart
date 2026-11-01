// lib/features/home/widgets/home_header_widget.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_avatar.dart';

// Componente modular para exibição da identificação do condutor, foto de perfil com cache offline e os dados essenciais do veículo
class HomeHeaderWidget extends StatelessWidget {
  final String? userId;
  final String userName;
  final String? userPhotoUrl;
  final Map<String, dynamic>? veiculo;

  const HomeHeaderWidget({
    super.key,
    this.userId,
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
          AppAvatar(
            userId: userId,
            photoUrl: userPhotoUrl,
            name: userName,
            size: 52,
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
}
