// lib/core/widgets/liters_formatter.dart

import 'package:flutter/services.dart';

// Formatador numérico com separador de milhar (.) e decimal (,) com limitação de dígitos para litros de combustível
class LitersTextInputFormatter extends TextInputFormatter {
  final int maxIntegerDigits;
  final int maxDecimalDigits;

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
      return newValue.copyWith(text: '');
    }

    String text = newValue.text;

    // Detectar se o usuário apagou a vírgula com backspace
    if (oldValue.text.contains(',') && !text.contains(',') && oldValue.text.length - text.length == 1) {
      String rawInt = text.replaceAll(RegExp(r'\D'), '');
      if (rawInt.length > maxIntegerDigits) {
        rawInt = rawInt.substring(0, maxIntegerDigits);
      }
      String formatted = _formatThousands(rawInt);
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    bool hasComma = text.contains(',');
    // Tratar ponto como vírgula decimal se digitado no final
    if (!hasComma && text.endsWith('.')) {
      text = '${text.substring(0, text.length - 1)},';
      hasComma = true;
    }

    String intPart = '';
    String decPart = '';

    if (hasComma) {
      final parts = text.split(',');
      intPart = parts[0].replaceAll(RegExp(r'\D'), '');
      decPart = parts.length > 1 ? parts.sublist(1).join('').replaceAll(RegExp(r'\D'), '') : '';
    } else {
      intPart = text.replaceAll(RegExp(r'\D'), '');
    }

    if (intPart.length > maxIntegerDigits) {
      intPart = intPart.substring(0, maxIntegerDigits);
    }

    if (decPart.length > maxDecimalDigits) {
      decPart = decPart.substring(0, maxDecimalDigits);
    }

    if (intPart.isEmpty && decPart.isEmpty && !hasComma) {
      return newValue.copyWith(text: '');
    }

    String formattedInt = _formatThousands(intPart);
    if (formattedInt.isEmpty && hasComma) {
      formattedInt = '0';
    }

    String result = hasComma ? '$formattedInt,$decPart' : formattedInt;

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }

  String _formatThousands(String digits) {
    if (digits.isEmpty) return '';
    String res = '';
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 3 == 0) {
        res = '.$res';
      }
      res = '${digits[digits.length - 1 - i]}$res';
    }
    return res;
  }
}
