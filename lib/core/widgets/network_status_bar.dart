import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:app_despesas/core/theme/app_theme.dart';

class NetworkStatusBar extends StatefulWidget {
  const NetworkStatusBar({Key? key}) : super(key: key);

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
    
    // Initial check
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
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _isVisible ? 32.0 : 0.0,
      width: double.infinity,
      color: _isOffline ? AppColors.warning : AppColors.success,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          height: 32.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isOffline ? Icons.wifi_off : Icons.wifi,
                color: Colors.black,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                _isOffline ? 'Status: Offline' : 'Status: Online',
                style: const TextStyle(
                  color: Colors.black,
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
