// lib/core/widgets/custom_refresh_indicator.dart

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// Refresh do sistema com as cores padrão do sistema
class CustomRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const CustomRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return RefreshIndicator(
      color: colors.primary,
      backgroundColor: colors.cardBackground,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
