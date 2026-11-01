// lib/features/despesas/widgets/currency_input_field.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';

// Campo de texto com máscara automática para digitação de moeda em reais (R$),
// foco visual e seleção de texto ao tocar
class CurrencyInputField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? helperText;
  final String? errorText;
  final ValueChanged<double>? onValueChanged;

  const CurrencyInputField({
    super.key,
    required this.label,
    required this.controller,
    this.helperText,
    this.errorText,
    this.onValueChanged,
  });

  @override
  State<CurrencyInputField> createState() => _CurrencyInputFieldState();
}

class _CurrencyInputFieldState extends State<CurrencyInputField> {
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
            Icon(LucideIcons.circleDollarSign, color: colors.primary, size: 18),
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
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: colors.inputBackground,
              borderRadius: AppRadius.lgRadius,
              border: Border.all(
                color: widget.errorText != null
                    ? colors.error
                    : _isFocused
                        ? colors.primary
                        : colors.textHint.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Text(
                  'R\$',
                  style: GoogleFonts.lexend(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: widget.errorText != null
                        ? colors.error
                        : _isFocused
                            ? colors.primary
                            : colors.textHint,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    onTap: _selecionarTudo,
                    enableInteractiveSelection: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _CurrencyTextInputFormatter(
                        onChanged: widget.onValueChanged,
                      ),
                    ],
                    style: GoogleFonts.lexend(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: '0,00',
                      hintStyle: GoogleFonts.lexend(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: colors.textHint,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Icon(LucideIcons.alertCircle, size: 14, color: colors.error),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  widget.errorText!,
                  style: GoogleFonts.lexend(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: colors.error,
                  ),
                ),
              ),
            ],
          ),
        ] else if (widget.helperText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.helperText!,
            style: GoogleFonts.lexend(
              fontSize: 12,
              color: colors.textHint,
            ),
          ),
        ],
      ],
    );
  }
}

class _CurrencyTextInputFormatter extends TextInputFormatter {
  final ValueChanged<double>? onChanged;
  final NumberFormat _formatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: '',
    decimalDigits: 2,
  );

  _CurrencyTextInputFormatter({this.onChanged});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      if (onChanged != null) onChanged!(0.0);
      return newValue.copyWith(text: '');
    }

    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.isEmpty) {
      if (onChanged != null) onChanged!(0.0);
      return const TextEditingValue(text: '');
    }

    double value = double.parse(digitsOnly) / 100.0;
    if (onChanged != null) {
      onChanged!(value);
    }

    String newText = _formatter.format(value).trim();
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
