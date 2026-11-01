// lib/core/widgets/full_screen_image_viewer.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// Visualizador de imagem em tela cheia com suporte a zoom interativo (pinch to zoom),
// carregamento local/remoto e fechamento intuitivo
class FullScreenImageViewer extends StatelessWidget {
  final File? file;
  final String? url;
  final String? title;
  final String? heroTag;

  const FullScreenImageViewer({
    super.key,
    this.file,
    this.url,
    this.title,
    this.heroTag,
  });

  static Future<void> show(
    BuildContext context, {
    File? file,
    String? url,
    String? title,
    String? heroTag,
  }) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (context, animation, secondaryAnimation) => FullScreenImageViewer(
          file: file,
          url: url,
          title: title,
          heroTag: heroTag,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (file != null && file!.existsSync()) {
      imageWidget = Image.file(
        file!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildErrorState('Erro ao carregar arquivo local'),
      );
    } else if (url != null && url!.trim().isNotEmpty) {
      imageWidget = Image.network(
        url!,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          final expected = progress.expectedTotalBytes;
          final loaded = progress.cumulativeBytesLoaded;
          final double? value = expected != null && expected > 0 ? loaded / expected : null;
          return Center(
            child: CircularProgressIndicator(
              value: value,
              color: Colors.white,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => _buildErrorState('Não foi possível carregar a imagem remota'),
      );
    } else {
      imageWidget = _buildErrorState('Nenhuma imagem disponível');
    }

    if (heroTag != null) {
      imageWidget = Hero(tag: heroTag!, child: imageWidget);
    }

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.95),
      body: SafeArea(
        child: Stack(
          children: [
            // Área de Zoom / Pan interativo
            Center(
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 5.0,
                child: imageWidget,
              ),
            ),

            // Barra superior com título e botão fechar
            Positioned(
              top: 8,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: title != null && title!.isNotEmpty
                        ? Text(
                            title!,
                            style: GoogleFonts.lexend(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : const SizedBox.shrink(),
                  ),
                  Material(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: const Icon(LucideIcons.x, color: Colors.white, size: 22),
                      tooltip: 'Fechar',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),

            // Dica de instrução na parte inferior
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.zoomIn, size: 14, color: Colors.white70),
                      const SizedBox(width: 6),
                      Text(
                        'Pince ou afaste para ajustar o zoom',
                        style: GoogleFonts.lexend(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
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

  Widget _buildErrorState(String message) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          LucideIcons.imageOff,
          size: 48,
          color: Colors.white54,
        ),
        const SizedBox(height: 12),
        Text(
          message,
          style: GoogleFonts.lexend(
            color: Colors.white70,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
