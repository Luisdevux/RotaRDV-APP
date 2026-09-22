import 'package:flutter_test/flutter_test.dart';

double? parseNumero(String texto) {
  final limpo = texto.replaceAll('.', '').replaceAll(',', '.').trim();
  return double.tryParse(limpo);
}

String? validarKmInicialEmTempoReal(String kmText, double? ultimaKmConhecida) {
  final text = kmText.trim();
  if (text.isEmpty) return null;
  final km = parseNumero(text);
  if (km == null || km <= 0) {
    return 'Informe uma quilometragem inicial maior que zero';
  }
  if (ultimaKmConhecida != null && km < ultimaKmConhecida) {
    return 'KM (${km.toInt()}) não pode ser menor que o da última viagem (${ultimaKmConhecida.toInt()} KM)';
  }
  return null;
}

void main() {
  group('Viagem - Validação de Odômetro Inicial', () {
    const double ultimaKmConcluida = 652844.0;

    test('deve rejeitar odômetro menor que o encerramento da última rota realizada', () {
      final erro = validarKmInicialEmTempoReal('650000', ultimaKmConcluida);
      expect(erro, isNotNull);
      expect(erro, contains('não pode ser menor que o da última viagem'));
    });

    test('deve rejeitar valor negativo ou zero', () {
      final erroZero = validarKmInicialEmTempoReal('0', ultimaKmConcluida);
      expect(erroZero, isNotNull);

      final erroNegativo = validarKmInicialEmTempoReal('-10', ultimaKmConcluida);
      expect(erroNegativo, isNotNull);
    });

    test('deve aprovar quando o odômetro for maior ou igual ao último conhecido', () {
      final semErroIgual = validarKmInicialEmTempoReal('652844', ultimaKmConcluida);
      expect(semErroIgual, isNull);

      final semErroMaior = validarKmInicialEmTempoReal('653218', ultimaKmConcluida);
      expect(semErroMaior, isNull);
    });
  });
}
