// lib/core/widgets/network_status_bar.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/sync_service.dart';
import '../theme/app_theme.dart';

enum _NetworkBarMode {
  offline,
  online,
  syncing,
  synced,
}

// Barra de status de rede e sincronização que exibe o estado da conexão e disparos de sync em segundo plano
// Utiliza exclusivamente duas cores de status: Amarelo (warning) e Verde (success)
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
  static const Duration _syncingMinDuration = Duration(seconds: 2);
  static const Duration _syncedDisplayDuration = Duration(seconds: 2);
  static const Duration _onlineDisplayDuration = Duration(seconds: 3);

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isVisible = false;
  bool _isOffline = false;
  _NetworkBarMode _mode = _NetworkBarMode.online;
  int _currentAttempt = 1;
  int _maxRetries = 3;

  Timer? _hideTimer;
  Timer? _syncPhaseTimer;
  DateTime? _syncStartedAt;

  @override
  void initState() {
    super.initState();

    final syncService = SyncService();
    syncService.syncStateNotifier.addListener(_onSyncStateChanged);
    syncService.isSyncingNotifier.addListener(_onSyncStateChanged);

    if (syncService.isSyncing) {
      final state = syncService.syncStateNotifier.value;
      _currentAttempt = state.currentAttempt > 0 ? state.currentAttempt : 1;
      _maxRetries = state.maxRetries > 0 ? state.maxRetries : 3;
      _mode = _NetworkBarMode.syncing;
      _isVisible = true;
      _syncStartedAt = DateTime.now();
    }

    _subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final isNowOffline = results.contains(ConnectivityResult.none) || results.isEmpty;
      _showConnectivityStatus(isOffline: isNowOffline);
    });

    // Verificação inicial de conectividade
    Connectivity().checkConnectivity().then((results) {
      if (!mounted) return;
      final isNowOffline = results.contains(ConnectivityResult.none) || results.isEmpty;
      if (isNowOffline) {
        _showConnectivityStatus(isOffline: true);
      }
    });
  }

  void _onSyncStateChanged() {
    if (!mounted) return;
    final syncService = SyncService();
    final state = syncService.syncStateNotifier.value;
    final syncingNow = syncService.isSyncing || state.isSyncing;

    if (syncingNow) {
      _hideTimer?.cancel();
      _syncPhaseTimer?.cancel();
      _syncStartedAt ??= DateTime.now();

      setState(() {
        _currentAttempt = state.currentAttempt > 0 ? state.currentAttempt : 1;
        _maxRetries = state.maxRetries > 0 ? state.maxRetries : 3;
        _mode = _NetworkBarMode.syncing;
        _isVisible = true;
      });
    } else {
      // Sincronização finalizada
      final bool syncSucceeded = (state.lastSyncSuccess ?? true) && !_isOffline;

      if (syncSucceeded) {
        // Garante que "Sincronizando..." fique visível por pelo menos 2 segundos antes de exibir "Sincronizado" em verde
        final elapsed = _syncStartedAt != null
            ? DateTime.now().difference(_syncStartedAt!)
            : _syncingMinDuration;
        final remaining = _syncingMinDuration - elapsed;
        final delayToSynced = remaining.isNegative ? Duration.zero : remaining;
        _syncStartedAt = null;

        _syncPhaseTimer?.cancel();
        _syncPhaseTimer = Timer(delayToSynced, () {
          if (!mounted || SyncService().isSyncing) return;

          if (_isOffline) {
            setState(() {
              _mode = _NetworkBarMode.offline;
              _isVisible = true;
            });
            return;
          }

          setState(() {
            _mode = _NetworkBarMode.synced;
            _isVisible = true;
          });

          _hideTimer?.cancel();
          _hideTimer = Timer(_syncedDisplayDuration, () {
            if (!mounted || SyncService().isSyncing) return;
            setState(() {
              if (_isOffline) {
                _mode = _NetworkBarMode.offline;
                _isVisible = true;
              } else {
                _isVisible = false;
              }
            });
          });
        });
      } else {
        // Falhou após as tentativas (ex: aparelho offline ou servidor inacessível)
        _syncStartedAt = null;
        _syncPhaseTimer?.cancel();

        if (_isOffline) {
          setState(() {
            _mode = _NetworkBarMode.offline;
            _isVisible = true;
          });
          if (!widget.persistentWhenOffline) {
            _hideTimer?.cancel();
            _hideTimer = Timer(_onlineDisplayDuration, () {
              if (mounted && !SyncService().isSyncing) {
                setState(() {
                  _isVisible = false;
                });
              }
            });
          }
        } else {
          _hideTimer?.cancel();
          _hideTimer = Timer(const Duration(milliseconds: 400), () {
            if (mounted && !SyncService().isSyncing) {
              setState(() {
                _isVisible = false;
              });
            }
          });
        }
      }
    }
  }

  void _showConnectivityStatus({required bool isOffline}) {
    if (!mounted) return;

    _isOffline = isOffline;
    final isSyncingNow = SyncService().isSyncing;

    if (isSyncingNow) {
      // Se já estiver sincronizando, mantém o modo syncing (que exibirá as tentativas se estiver offline)
      setState(() {
        _mode = _NetworkBarMode.syncing;
        _isVisible = true;
      });
      return;
    }

    _syncPhaseTimer?.cancel();
    _hideTimer?.cancel();

    setState(() {
      _mode = isOffline ? _NetworkBarMode.offline : _NetworkBarMode.online;
      _isVisible = true;
    });

    // Se for online ou se não estiver configurado para persistir offline, esconde após 3 segundos
    if (!isOffline || !widget.persistentWhenOffline) {
      _hideTimer = Timer(_onlineDisplayDuration, () {
        if (mounted && !SyncService().isSyncing && (!_isOffline || !widget.persistentWhenOffline)) {
          setState(() {
            _isVisible = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    final syncService = SyncService();
    syncService.syncStateNotifier.removeListener(_onSyncStateChanged);
    syncService.isSyncingNotifier.removeListener(_onSyncStateChanged);
    _subscription?.cancel();
    _hideTimer?.cancel();
    _syncPhaseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // Apenas 2 cores de barra: Amarelo (warning) para Offline/Sincronizando e Verde (success) para Online/Sincronizado
    final bool isGreenState = _mode == _NetworkBarMode.online || _mode == _NetworkBarMode.synced;
    final Color backgroundColor = isGreenState ? colors.success : colors.warning;
    final Color textColor = colors.textDark;

    final String statusText;
    switch (_mode) {
      case _NetworkBarMode.offline:
        statusText = 'Status: Offline';
        break;
      case _NetworkBarMode.online:
        statusText = 'Status: Online';
        break;
      case _NetworkBarMode.syncing:
        final bool mostrarTentativa = _isOffline || _currentAttempt > 1;
        statusText = mostrarTentativa
            ? 'Sincronizando... (tentativa $_currentAttempt/$_maxRetries)'
            : 'Sincronizando...';
        break;
      case _NetworkBarMode.synced:
        statusText = 'Sincronizado';
        break;
    }

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
              if (_mode == _NetworkBarMode.syncing)
                SizedBox(
                  width: 13,
                  height: 13,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: textColor,
                  ),
                )
              else
                Icon(
                  _mode == _NetworkBarMode.offline
                      ? Icons.wifi_off
                      : (_mode == _NetworkBarMode.synced
                          ? Icons.check_circle_outline
                          : Icons.wifi),
                  color: textColor,
                  size: 16,
                ),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text(
                  statusText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lexend(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
