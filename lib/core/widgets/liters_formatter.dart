// lib/core/widgets/liters_formatter.dart

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// Formatador numérico para litros de combustível estilo centesimal (primeiro centésimos após a vírgula, depois unidades e milhares).
class LitersTextInputFormatter extends TextInputFormatter {
  final int maxIntegerDigits;
  final int maxDecimalDigits;
  final NumberFormat _formatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: '',
    decimalDigits: 2,
  );

  LitersTextInputFormatter({
    this.maxIntegerDigits = 6, // Máximo 999.999 L
    this.maxDecimalDigits = 2,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return const TextEditingValue(text: '');
    }

    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(text: '');
    }

    // Remove zeros à esquerda adicionais para evitar travamento em 000
    digitsOnly = digitsOnly.replaceFirst(RegExp(r'^0+'), '');
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(text: '');
    }

    // Limita o total de dígitos (ex: 6 inteiros + 2 decimais = 8 dígitos)
    final maxTotalDigits = maxIntegerDigits + maxDecimalDigits;
    if (digitsOnly.length > maxTotalDigits) {
      digitsOnly = digitsOnly.substring(0, maxTotalDigits);
    }

    final double value = double.parse(digitsOnly) / 100.0;
    final String formatted = _formatter.format(value).trim();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
