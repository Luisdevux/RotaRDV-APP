// lib/core/widgets/app_avatar.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import '../theme/app_theme.dart';

// Gerenciador de cache local persistente para foto de perfil do motorista
class AvatarCacheService {
  static final ValueNotifier<int> avatarUpdateNotifier = ValueNotifier<int>(0);

  static void notifyAvatarChanged() {
    avatarUpdateNotifier.value++;
  }

  static Future<File?> getLocalAvatar(String? userId) async {
    if (userId == null || userId.isEmpty) return null;
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final file = File('${appDir.path}/avatar_$userId.jpg');
      if (await file.exists()) {
        return file;
      }
    } catch (_) {}
    return null;
  }

  static Future<File> saveLocalAvatar(String? userId, File sourceFile) async {
    if (userId == null || userId.isEmpty) throw Exception('userId nulo ou vazio');
    final appDir = await getApplicationDocumentsDirectory();
    final targetFile = File('${appDir.path}/avatar_$userId.jpg');
    if (await targetFile.exists()) {
      await targetFile.delete();
    }
    await sourceFile.copy(targetFile.path);
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
    notifyAvatarChanged();
    return targetFile;
  }

  static Future<void> deleteLocalAvatar(String? userId) async {
    if (userId == null || userId.isEmpty) return;
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final file = File('${appDir.path}/avatar_$userId.jpg');
      if (await file.exists()) {
        await file.delete();
      }
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
    } catch (_) {}
    notifyAvatarChanged();
  }

  static Future<void> cacheAvatar(String? userId, String? url) async {
    if (userId == null || userId.isEmpty || url == null || url.trim().isEmpty) return;
    if (!url.startsWith('http://') && !url.startsWith('https://')) return;

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final file = File('${appDir.path}/avatar_$userId.jpg');
      final dio = Dio();
      final response = await dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200 && response.data != null && response.data!.isNotEmpty) {
        await file.writeAsBytes(response.data!);
        PaintingBinding.instance.imageCache.clear();
        PaintingBinding.instance.imageCache.clearLiveImages();
        debugPrint('[AvatarCacheService] Foto do usuário $userId armazenada com sucesso para visualização offline.');
        notifyAvatarChanged();
      }
    } catch (e) {
      debugPrint('[AvatarCacheService] Falha silenciosa ao sincronizar avatar em cache: $e');
    }
  }
}

// Componente inteligente de Avatar com tolerância a offline, cache local e fallback de iniciais
class AppAvatar extends StatefulWidget {
  final String? userId;
  final String? photoUrl;
  final String name;
  final double size;

  const AppAvatar({
    super.key,
    required this.userId,
    this.photoUrl,
    required this.name,
    this.size = 52,
  });

  @override
  State<AppAvatar> createState() => _AppAvatarState();
}

class _AppAvatarState extends State<AppAvatar> {
  File? _localAvatarFile;
  int _cacheBuster = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    AvatarCacheService.avatarUpdateNotifier.addListener(_onAvatarUpdated);
    _checkLocalCache();
  }

  @override
  void dispose() {
    AvatarCacheService.avatarUpdateNotifier.removeListener(_onAvatarUpdated);
    super.dispose();
  }

  void _onAvatarUpdated() {
    if (mounted) {
      _checkLocalCache();
    }
  }

  @override
  void didUpdateWidget(covariant AppAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId || oldWidget.photoUrl != widget.photoUrl) {
      _checkLocalCache();
    }
  }

  Future<void> _checkLocalCache() async {
    final file = await AvatarCacheService.getLocalAvatar(widget.userId);
    if (mounted) {
      setState(() {
        _localAvatarFile = file;
        _cacheBuster = DateTime.now().millisecondsSinceEpoch;
      });
    }

    // Se possui URL remota e não há arquivo local, tenta baixar cache em segundo plano
    if (widget.photoUrl != null && widget.photoUrl!.trim().isNotEmpty && file == null) {
      AvatarCacheService.cacheAvatar(widget.userId, widget.photoUrl!).then((_) async {
        final updatedFile = await AvatarCacheService.getLocalAvatar(widget.userId);
        if (updatedFile != null && mounted) {
          setState(() => _localAvatarFile = updatedFile);
        }
      });
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  Widget _buildFallback(AppColorsExtension colors) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(
          color: colors.primary.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          _getInitials(widget.name),
          style: GoogleFonts.lexend(
            fontSize: widget.size * 0.38,
            fontWeight: FontWeight.bold,
            color: colors.primary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasRemoteUrl = widget.photoUrl != null && widget.photoUrl!.trim().isNotEmpty;

    final cacheDim = (widget.size * 2.5).round();

    if (_localAvatarFile != null) {
      return Container(
        width: widget.size,
        height: widget.size,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: ClipOval(
          child: Image.file(
            _localAvatarFile!,
            key: ValueKey('${_localAvatarFile!.path}_$_cacheBuster'),
            cacheWidth: cacheDim,
            cacheHeight: cacheDim,
            width: widget.size,
            height: widget.size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildFallback(colors),
          ),
        ),
      );
    }

    if (hasRemoteUrl) {
      return Container(
        width: widget.size,
        height: widget.size,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: ClipOval(
          child: Image.network(
            widget.photoUrl!,
            cacheWidth: cacheDim,
            cacheHeight: cacheDim,
            width: widget.size,
            height: widget.size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildFallback(colors),
          ),
        ),
      );
    }

    return _buildFallback(colors);
  }
}
