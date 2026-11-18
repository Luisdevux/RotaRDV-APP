// lib/core/widgets/thousands_formatter.dart

import 'package:flutter/services.dart';
import '../utils/odometer_validator.dart';

// Formata o valor do odômetro com pontos a cada 3 dígitos, da direita para a esquerda, respeitando o limite máximo de dígitos.
class ThousandsFormatter extends TextInputFormatter {
  final int maxDigits;

  ThousandsFormatter({this.maxDigits = OdometerValidator.maxOdometroDigits});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove tudo que não for número
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    if (newText.length > maxDigits) {
      final oldDigits = oldValue.text.replaceAll(RegExp(r'[^0-9]'), '');
      final replacedEntireText = oldValue.text.isNotEmpty &&
          (oldValue.selection.extentOffset - oldValue.selection.baseOffset).abs() >=
              oldValue.text.length;

      if (!replacedEntireText &&
          oldDigits.length >= maxDigits &&
          newText.length > oldDigits.length) {
        return oldValue;
      }
      newText = newText.substring(0, maxDigits);
    }

    // Adiciona os pontos a cada 3 digitos da direita pra esquerda
    String formattedText = '';
    for (int i = 0; i < newText.length; i++) {
      if (i > 0 && i % 3 == 0) {
        formattedText = '.$formattedText';
      }
      formattedText = '${newText[newText.length - 1 - i]}$formattedText';
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
