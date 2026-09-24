// lib/features/perfil/widgets/perfil_pendencias_modal.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../services/sync_service.dart';
import '../../auth/auth_viewmodel.dart';

// Modal de barreira de segurança acionado antes do logout quando existirem comprovantes fiscais ou registros locais que ainda não foram sincronizados
class PerfilPendenciasModal {
  static Future<void> show(
    BuildContext context, {
    required AuthViewModel authVM,
    required AppColorsExtension colors,
    required PendingSyncSummary pending,
    required Future<void> Function(bool clearDatabase) onLogout,
  }) async {
    final syncService = SyncService();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        bool isSyncingInModal = false;
        PendingSyncSummary currentSummary = pending;
        String? statusFeedback;

        return StatefulBuilder(
          builder: (context, setModalState) {
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
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: colors.warning.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            LucideIcons.alertTriangle,
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
                                'Dados pendentes de envio',
                                style: GoogleFonts.lexend(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: colors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Existem dados que ainda não estão salvos na nuvem.',
                                style: GoogleFonts.lexend(
                                  fontSize: 12,
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: colors.surfaceOverlay,
                        borderRadius: AppRadius.mdRadius,
                        border: Border.all(color: colors.borderSubtle),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (currentSummary.viagensPendentes > 0)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Icon(LucideIcons.truck, size: 15, color: colors.warning),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${currentSummary.viagensPendentes} viagem(ns) pendente(s)',
                                    style: GoogleFonts.lexend(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (currentSummary.despesasPendentes > 0)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Icon(LucideIcons.receipt, size: 15, color: colors.warning),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${currentSummary.despesasPendentes} despesa(s) pendente(s)',
                                    style: GoogleFonts.lexend(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (currentSummary.fotosPendentes > 0)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Icon(LucideIcons.image, size: 15, color: colors.warning),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${currentSummary.fotosPendentes} foto(s) de comprovante não enviada(s)',
                                    style: GoogleFonts.lexend(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (statusFeedback != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        statusFeedback!,
                        style: GoogleFonts.lexend(
                          fontSize: 12,
                          color: colors.warning,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton.icon(
                      onPressed: isSyncingInModal
                          ? null
                          : () async {
                              setModalState(() {
                                isSyncingInModal = true;
                                statusFeedback = 'Enviando dados para a nuvem...';
                              });
                              await syncService.syncAll();
                              final novoResumo = await syncService.getPendingSyncSummary();
                              setModalState(() {
                                isSyncingInModal = false;
                                currentSummary = novoResumo;
                                statusFeedback = novoResumo.hasPending
                                    ? 'Ainda restam itens pendentes. Tente novamente quando estiver conectado.'
                                    : 'Todos os dados foram sincronizados com sucesso!';
                              });
                              if (!novoResumo.hasPending && modalContext.mounted) {
                                await Future.delayed(const Duration(milliseconds: 700));
                                if (modalContext.mounted) {
                                  Navigator.pop(modalContext);
                                  await onLogout(true);
                                }
                              }
                            },
                      icon: isSyncingInModal
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(LucideIcons.cloudUpload, size: 18, color: Colors.white),
                      label: Text(
                        isSyncingInModal ? 'Sincronizando...' : 'Sincronizar agora e sair',
                        style: GoogleFonts.lexend(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    OutlinedButton.icon(
                      onPressed: isSyncingInModal ? null : () => Navigator.pop(modalContext),
                      icon: Icon(LucideIcons.shieldCheck, size: 16, color: colors.success),
                      label: Text(
                        'Permanecer conectado',
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
                    TextButton.icon(
                      onPressed: isSyncingInModal
                          ? null
                          : () async {
                              final bool? confirmarForcado = await AppDialog.show(
                                context: context,
                                title: 'Atenção Crítica',
                                message:
                                    'Você possui registros salvos apenas neste aparelho.\n\nSe você sair da conta, ${currentSummary.fotosPendentes > 0 ? "as fotos dos comprovantes e " : ""}os dados só poderão ser sincronizados se você entrar novamente com este mesmo usuário neste mesmo celular.\n\nTem certeza que deseja sair mesmo assim?',
                                confirmText: 'Sair mesmo assim',
                                cancelText: 'Cancelar e manter conectado',
                                isDestructive: true,
                                icon: LucideIcons.alertOctagon,
                              );

                              if (confirmarForcado == true && context.mounted) {
                                Navigator.pop(modalContext);
                                await onLogout(false);
                              }
                            },
                      icon: Icon(LucideIcons.logOut, size: 14, color: colors.error),
                      label: Text(
                        'Sair sem sincronizar',
                        style: GoogleFonts.lexend(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: colors.error,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: colors.error,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
