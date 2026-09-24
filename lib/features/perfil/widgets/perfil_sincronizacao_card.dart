// lib/features/perfil/widgets/perfil_sincronizacao_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';

// Componente modular que permite disparar a sincronização imediata entre o armazenamento local (Isar) e o servidor backend.
class PerfilSincronizacaoCard extends StatelessWidget {
  final bool isSyncing;
  final VoidCallback onSincronizar;

  const PerfilSincronizacaoCard({
    super.key,
    required this.isSyncing,
    required this.onSincronizar,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppCard(
      backgroundColor: colors.cardBackground,
      borderColor: colors.borderSubtle,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.cloud, size: 16, color: colors.primary),
              const SizedBox(width: 8),
              Text(
                'Sincronização offline',
                style: GoogleFonts.lexend(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6,
                  color: colors.textHint,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Viagens e despesas são gravadas no aparelho e sincronizadas com o servidor quando houver conexão.',
            style: GoogleFonts.lexend(
              fontSize: 12,
              color: colors.textMuted,
              height: 1.3,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: isSyncing ? null : onSincronizar,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colors.primaryBorder),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.smRadius,
                ),
              ),
              child: isSyncing
                  ? SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.textPrimary,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.refreshCw, size: 16, color: colors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Sincronizar dados agora',
                          style: GoogleFonts.lexend(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
