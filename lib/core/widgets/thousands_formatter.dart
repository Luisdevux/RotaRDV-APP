import 'package:flutter/services.dart';

class ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    
    // Remove tudo que não for numero
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (newText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Adiciona os pontos a cada 3 digitos da direita pra esquerda
    String formattedText = '';
    for (int i = 0; i < newText.length; i++) {
      if (i > 0 && i % 3 == 0) {
        formattedText = '.' + formattedText;
      }
      formattedText = newText[newText.length - 1 - i] + formattedText;
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
