// lib/core/widgets/odometer_input_field.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'thousands_formatter.dart';

// Input personalizado para odômetro, com ícone, label, campo de texto, unidade (KM),
// foco visual e seleção automática do valor ao tocar
class OdometerInputField extends StatefulWidget {
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
  State<OdometerInputField> createState() => _OdometerInputFieldState();
}

class _OdometerInputFieldState extends State<OdometerInputField> {
  bool _isFocused = false;

  void _selecionarTudo() {
    if (widget.controller.text.isNotEmpty) {
      widget.controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: widget.controller.text.length,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(widget.icon, color: colors.primary, size: 18),
            const SizedBox(width: AppSpacing.sm),
            Text(
              widget.label,
              style: GoogleFonts.lexend(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Focus(
          onFocusChange: (hasFocus) {
            setState(() => _isFocused = hasFocus);
            if (hasFocus) {
              _selecionarTudo();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: colors.inputBackground,
              border: Border.all(
                color: widget.errorText != null
                    ? colors.error
                    : _isFocused
                        ? colors.primary
                        : colors.border,
                width: (_isFocused || widget.errorText != null) ? 1.5 : 1.0,
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
                    controller: widget.controller,
                    onChanged: widget.onChanged,
                    onTap: _selecionarTudo,
                    keyboardType: TextInputType.number,
                    inputFormatters: [ThousandsFormatter()],
                    enableInteractiveSelection: true,
                    style: GoogleFonts.lexend(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                      height: 1.25,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hintText,
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
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.errorText!,
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
