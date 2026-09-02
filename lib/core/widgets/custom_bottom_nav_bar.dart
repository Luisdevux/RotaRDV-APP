import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/app_theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(
            color: AppColors.borderSubtle,
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 68,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(context, 0, LucideIcons.home, 'Início'),
              _buildNavItem(context, 1, LucideIcons.truck, 'Viagens'),
              _buildNavItem(context, 2, LucideIcons.receiptText, 'Gastos'),
              _buildNavItem(context, 3, LucideIcons.user, 'Perfil'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
  ) {
    final isSelected = currentIndex == index;
    final itemColor = isSelected ? AppColors.primary : AppColors.textHint;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(index),
          borderRadius: AppRadius.lgRadius,
          splashColor: AppColors.textHint.withValues(alpha: 0.15),
          highlightColor: AppColors.textHint.withValues(alpha: 0.08),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: itemColor,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: GoogleFonts.lexend(
                      color: itemColor,
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

