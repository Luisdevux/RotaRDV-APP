import 'package:flutter_test/flutter_test.dart';

double? parseNumero(String texto) {
  final limpo = texto.replaceAll('.', '').replaceAll(',', '.').trim();
  return double.tryParse(limpo);
}

bool isOrigemIgualDestino({
  String? origemCidade,
  String? origemUF,
  String? destinoCidade,
  String? destinoUF,
}) {
  if (origemCidade == null || origemUF == null || destinoCidade == null || destinoUF == null) {
    return false;
  }
  return origemCidade.trim().toLowerCase() == destinoCidade.trim().toLowerCase() &&
      origemUF.trim().toUpperCase() == destinoUF.trim().toUpperCase();
}

String? validarKmInicialEmTempoReal(String kmText, double? ultimaKmConhecida) {
  final text = kmText.trim();
  if (text.isEmpty) return null;
  final km = parseNumero(text);
  if (km == null || km <= 0) {
    return 'Informe uma quilometragem inicial maior que zero';
  }
  if (km > 10000000) {
    return 'Quilometragem inválida (limite excedido)';
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

    test('deve rejeitar odômetro acima de 10.000.000 KM (limite máximo)', () {
      final erroLimite = validarKmInicialEmTempoReal('10000001', ultimaKmConcluida);
      expect(erroLimite, isNotNull);
      expect(erroLimite, contains('limite excedido'));
    });

    test('deve aprovar quando o odômetro for maior ou igual ao último conhecido', () {
      final semErroIgual = validarKmInicialEmTempoReal('652844', ultimaKmConcluida);
      expect(semErroIgual, isNull);

      final semErroMaior = validarKmInicialEmTempoReal('653218', ultimaKmConcluida);
      expect(semErroMaior, isNull);
    });

    test('deve permitir campo vazio sem disparar erro em tempo real', () {
      final vazio = validarKmInicialEmTempoReal('', ultimaKmConcluida);
      expect(vazio, isNull);
    });
  });

  group('Viagem - Validação de Origem e Destino', () {
    test('deve identificar quando origem e destino são idênticos (mesma cidade e estado)', () {
      final igual = isOrigemIgualDestino(
        origemCidade: 'Cascavel',
        origemUF: 'PR',
        destinoCidade: 'Cascavel',
        destinoUF: 'PR',
      );
      expect(igual, isTrue);
    });

    test('deve ignorar diferenças de maiúsculas/minúsculas e espaços extras', () {
      final igualCase = isOrigemIgualDestino(
        origemCidade: '  Curitiba ',
        origemUF: 'pr ',
        destinoCidade: 'curitiba',
        destinoUF: 'PR',
      );
      expect(igualCase, isTrue);
    });

    test('deve permitir cidades de mesmo nome em estados diferentes', () {
      final estadosDiferentes = isOrigemIgualDestino(
        origemCidade: 'Planalto',
        origemUF: 'PR',
        destinoCidade: 'Planalto',
        destinoUF: 'RS',
      );
      expect(estadosDiferentes, isFalse);
    });

    test('deve permitir cidades diferentes no mesmo estado', () {
      final cidadesDiferentes = isOrigemIgualDestino(
        origemCidade: 'Curitiba',
        origemUF: 'PR',
        destinoCidade: 'Londrina',
        destinoUF: 'PR',
      );
      expect(cidadesDiferentes, isFalse);
    });

    test('deve retornar falso se qualquer campo estiver nulo', () {
      expect(isOrigemIgualDestino(origemCidade: 'Curitiba', origemUF: 'PR'), isFalse);
      expect(isOrigemIgualDestino(destinoCidade: 'São Paulo', destinoUF: 'SP'), isFalse);
    });
  });
}
