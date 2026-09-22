import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/app_theme.dart';

class LabeledInputField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const LabeledInputField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: colors.primary, size: 18),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: GoogleFonts.lexend(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: colors.inputBackground,
            border: Border.all(
              color: errorText != null ? colors.error : colors.border,
              width: errorText != null ? 1.5 : 1.0,
            ),
            borderRadius: AppRadius.lgRadius,
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: GoogleFonts.lexend(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: colors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.lexend(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: colors.textHint,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: 14,
              ),
              filled: false,
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Icon(LucideIcons.alertCircle, size: 14, color: colors.error),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  errorText!,
                  style: GoogleFonts.lexend(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: colors.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
