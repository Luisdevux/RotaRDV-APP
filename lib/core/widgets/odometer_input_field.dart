import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'thousands_formatter.dart';

class OdometerInputField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String hintText;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const OdometerInputField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    required this.hintText,
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
            ),
            borderRadius: AppRadius.lgRadius,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 14,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  keyboardType: TextInputType.number,
                  inputFormatters: [ThousandsFormatter()],
                  style: GoogleFonts.lexend(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                    height: 1.25,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: GoogleFonts.lexend(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: colors.textHint,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    filled: false,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.cardBackground,
                  borderRadius: AppRadius.xsRadius,
                  border: Border.all(color: colors.borderSubtle),
                ),
                child: Text(
                  'KM',
                  style: GoogleFonts.lexend(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            errorText!,
            style: GoogleFonts.lexend(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colors.error,
            ),
          ),
        ],
      ],
    );
  }
}
