import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Componente modular e reutilizável de Cartão (Surface / Card) do Figma.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool isHighlighted;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? AppRadius.xlRadius;
    final effectiveBg = backgroundColor ??
        (isHighlighted ? AppColors.cardBackground : AppColors.cardBackground);
    final effectiveBorder = borderColor ??
        (isHighlighted ? AppColors.primaryBorder : AppColors.borderSubtle);

    final cardContent = Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: effectiveRadius,
        border: Border.all(
          color: effectiveBorder,
          width: isHighlighted ? 1.5 : 1.0,
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return Padding(
        padding: margin ?? EdgeInsets.zero,
        child: Material(
          color: Colors.transparent,
          borderRadius: effectiveRadius,
          child: InkWell(
            onTap: onTap,
            borderRadius: effectiveRadius,
            splashColor: AppColors.primary.withValues(alpha: 0.1),
            highlightColor: AppColors.primary.withValues(alpha: 0.05),
            child: cardContent,
          ),
        ),
      );
    }

    if (margin != null) {
      return Padding(
        padding: margin!,
        child: cardContent,
      );
    }

    return cardContent;
  }
}
