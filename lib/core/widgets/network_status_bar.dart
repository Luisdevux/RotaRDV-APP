import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class NetworkStatusBar extends StatefulWidget {
  final bool persistentWhenOffline;

  const NetworkStatusBar({
    super.key,
    this.persistentWhenOffline = true,
  });

  @override
  State<NetworkStatusBar> createState() => _NetworkStatusBarState();
}

class _NetworkStatusBarState extends State<NetworkStatusBar> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isVisible = false;
  bool _isOffline = false;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final isNowOffline = results.contains(ConnectivityResult.none) || results.isEmpty;
      _showStatus(isOffline: isNowOffline);
    });

    // Verificação inicial de conectividade
    Connectivity().checkConnectivity().then((results) {
      final isNowOffline = results.contains(ConnectivityResult.none) || results.isEmpty;
      if (isNowOffline) {
        _showStatus(isOffline: true);
      }
    });
  }

  void _showStatus({required bool isOffline}) {
    if (!mounted) return;

    setState(() {
      _isOffline = isOffline;
      _isVisible = true;
    });

    _hideTimer?.cancel();
    // Se for online ou se não estiver configurado para persistir offline, esconde após 3 segundos
    if (!isOffline || !widget.persistentWhenOffline) {
      _hideTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isVisible = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _isOffline ? AppColors.warning : AppColors.success;
    final textColor = AppColors.textDark;
    final statusIcon = _isOffline ? Icons.wifi_off : Icons.wifi;
    final statusText = _isOffline ? 'Status: Offline' : 'Status: Online';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: _isVisible ? 32.0 : 0.0,
      width: double.infinity,
      color: backgroundColor,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          height: 32.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                statusIcon,
                color: textColor,
                size: 16,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                statusText,
                style: GoogleFonts.lexend(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
