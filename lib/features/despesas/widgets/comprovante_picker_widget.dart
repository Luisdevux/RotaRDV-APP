import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';

/*──────────────────────────────────────────────────────────────*/
/* COMPONENTE: SELETOR E CAPTURA DE COMPROVANTE FISCAL          */
/*──────────────────────────────────────────────────────────────*/

typedef OnComprovanteImageChanged = void Function(File? file, bool isCamera);

/// Componente para captura por câmera nativa ou anexo da galeria
/// de comprovantes fiscais com suporte à persistência antes do encerramento de processo.
class ComprovantePickerWidget extends StatelessWidget {
  final File? selectedImage;
  final OnComprovanteImageChanged onImageChanged;
  final Future<void> Function()? onBeforePickImage;

  const ComprovantePickerWidget({
    super.key,
    required this.selectedImage,
    required this.onImageChanged,
    this.onBeforePickImage,
  });

  Future<void> _pickImage(BuildContext context, ImageSource source, AppColorsExtension colors) async {
    try {
      if (onBeforePickImage != null) {
        await onBeforePickImage!();
      }

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 1280,
        maxHeight: 1280,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (pickedFile != null) {
        onImageChanged(File(pickedFile.path), source == ImageSource.camera);
      }
    } catch (e) {
      debugPrint('[ComprovantePicker] Erro ao selecionar imagem: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Não foi possível acessar a câmera ou galeria.'),
            backgroundColor: colors.error,
          ),
        );
      }
    }
  }

  void _showSourceModal(BuildContext context, AppColorsExtension colors) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
          border: Border(
            top: BorderSide(color: colors.border, width: 1),
          ),
        ),
        child: SafeArea(
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
                    borderRadius: AppRadius.xsRadius,
                  ),
                ),
              ),
              Text(
                'Anexar Comprovante / Cupom',
                textAlign: TextAlign.center,
                style: GoogleFonts.lexend(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Tire uma foto nítida da nota fiscal ou escolha da galeria',
                textAlign: TextAlign.center,
                style: GoogleFonts.lexend(
                  fontSize: 13,
                  color: colors.textMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _pickImage(context, ImageSource.camera, colors);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
                      ),
                      icon: const Icon(LucideIcons.camera, color: Colors.white, size: 20),
                      label: Text(
                        'Câmera',
                        style: GoogleFonts.lexend(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _pickImage(context, ImageSource.gallery, colors);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: colors.primary),
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
                      ),
                      icon: Icon(LucideIcons.image, color: colors.primary, size: 20),
                      label: Text(
                        'Galeria',
                        style: GoogleFonts.lexend(
                          color: colors.primary,
                          fontWeight: FontWeight.w600,
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

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (selectedImage != null) {
      return Stack(
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: AppRadius.lgRadius,
              border: Border.all(color: colors.primary.withValues(alpha: 0.5), width: 1.5),
            ),
            child: ClipRRect(
              borderRadius: AppRadius.lgRadius,
              child: Image.file(
                selectedImage!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => _showSourceModal(context, colors),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withValues(alpha: 0.6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(8),
                  ),
                  icon: const Icon(LucideIcons.refreshCw, size: 18),
                ),
                const SizedBox(width: 6),
                IconButton(
                  onPressed: () => onImageChanged(null, false),
                  style: IconButton.styleFrom(
                    backgroundColor: colors.error.withValues(alpha: 0.8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(8),
                  ),
                  icon: const Icon(LucideIcons.trash2, size: 18),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return AppCard(
      onTap: () => _showSourceModal(context, colors),
      backgroundColor: colors.inputBackground,
      borderColor: colors.border,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl, horizontal: AppSpacing.lg),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(LucideIcons.camera, color: colors.primary, size: 28),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Tirar foto ou anexar da galeria',
              style: GoogleFonts.lexend(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Opcional • Formato JPG ou PNG',
              style: GoogleFonts.lexend(
                fontSize: 12,
                color: colors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
