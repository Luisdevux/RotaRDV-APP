import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Componente modular e reutilizável para exibição de Diálogos / Modais de Alerta e Confirmação.
class AppDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final Color? iconColor;
  final String confirmText;
  final VoidCallback onConfirm;
  final String? cancelText;
  final VoidCallback? onCancel;
  final bool isDestructive;
  final bool isLoading;

  const AppDialog({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.iconColor,
    this.confirmText = 'Confirmar',
    required this.onConfirm,
    this.cancelText = 'Cancelar',
    this.onCancel,
    this.isDestructive = false,
    this.isLoading = false,
  });

  /// Método utilitário estático para abrir o diálogo de forma padronizada.
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    IconData? icon,
    Color? iconColor,
    String confirmText = 'Confirmar',
    String? cancelText = 'Cancelar',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AppDialog(
        title: title,
        message: message,
        icon: icon,
        iconColor: iconColor,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
        onConfirm: () => Navigator.of(ctx).pop(true),
        onCancel: () => Navigator.of(ctx).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.headerBackground,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.xlRadius,
        side: const BorderSide(color: AppColors.border),
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxl,
        vertical: AppSpacing.huge,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (icon != null) ...[
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: (iconColor ?? (isDestructive ? AppColors.error : AppColors.primary))
                          .withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: iconColor ?? (isDestructive ? AppColors.error : AppColors.primary),
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.lexend(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.lexend(
                  fontSize: 14,
                  height: 1.4,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Row(
                children: [
                  if (cancelText != null && onCancel != null) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isLoading ? null : onCancel,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textMuted,
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.mdRadius,
                          ),
                        ),
                        child: Text(
                          cancelText!,
                          style: GoogleFonts.lexend(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : onConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDestructive ? AppColors.error : AppColors.primary,
                        foregroundColor: AppColors.textPrimary,
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.mdRadius,
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.textPrimary,
                              ),
                            )
                          : Text(
                              confirmText,
                              style: GoogleFonts.lexend(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
