import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class LabeledInputField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String hintText;

  const LabeledInputField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.lexend(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFCBD5E1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.20)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: controller,
            style: GoogleFonts.lexend(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFE2E8F0),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.lexend(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF64748B),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15.5),
              filled: false,
            ),
          ),
        ),
      ],
    );
  }
}
