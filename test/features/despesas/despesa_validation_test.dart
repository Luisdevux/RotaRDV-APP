import 'package:flutter_test/flutter_test.dart';
import 'package:app_despesas/core/widgets/liters_formatter.dart';
import 'package:app_despesas/features/despesas/despesa_viewmodel.dart';
import 'package:app_despesas/models/viagem_collection.dart';

void main() {
  group('DespesaViewModel - Validação de Domínio no Lançamento', () {
    final viagemMock = ViagemCollection()
      ..uuid = 'viagem-mock-001'
      ..kmInicial = 653218.0
      ..status = 'em_andamento';

    test('deve rejeitar despesa com valor total zero ou negativo', () {
      final erroZero = DespesaViewModel.validarLancamento(
        valorTotal: 0,
        tipo: 'ALIMENTACAO',
        viagem: viagemMock,
      );
      expect(erroZero, isNotNull);
      expect(erroZero, contains('maior que zero'));

      final erroNegativo = DespesaViewModel.validarLancamento(
        valorTotal: -100,
        tipo: 'ALIMENTACAO',
        viagem: viagemMock,
      );
      expect(erroNegativo, isNotNull);
    });

    test('deve rejeitar abastecimento com litros ausente ou zerado', () {
      final erroSemLitros = DespesaViewModel.validarLancamento(
        valorTotal: 400.0,
        tipo: 'ABASTECIMENTO',
        viagem: viagemMock,
        litros: null,
        kmAtual: 653400.0,
      );
      expect(erroSemLitros, isNotNull);

      final erroLitrosZero = DespesaViewModel.validarLancamento(
        valorTotal: 400.0,
        tipo: 'ABASTECIMENTO',
        viagem: viagemMock,
        litros: 0,
        kmAtual: 653400.0,
      );
      expect(erroLitrosZero, isNotNull);
    });

    test('deve rejeitar abastecimento com odômetro menor que o início da rota', () {
      final erroOdometro = DespesaViewModel.validarLancamento(
        valorTotal: 400.0,
        tipo: 'ABASTECIMENTO',
        viagem: viagemMock,
        litros: 60.0,
        kmAtual: 300000.0, // Odômetro regredindo gravemente
      );
      expect(erroOdometro, isNotNull);
      expect(erroOdometro, contains('não pode ser menor que o odômetro inicial'));
    });

    test('deve rejeitar abastecimento com odômetro zerado ou nulo', () {
      final erroSemKm = DespesaViewModel.validarLancamento(
        valorTotal: 400.0,
        tipo: 'ABASTECIMENTO',
        viagem: viagemMock,
        litros: 60.0,
        kmAtual: null,
      );
      expect(erroSemKm, isNotNull);
    });

    test('deve rejeitar abastecimento com litros superior a 50.000 L', () {
      final erroExcessoLitros = DespesaViewModel.validarLancamento(
        valorTotal: 400.0,
        tipo: 'ABASTECIMENTO',
        viagem: viagemMock,
        litros: 50000.01,
        kmAtual: 653400.0,
      );
      expect(erroExcessoLitros, isNotNull);
      expect(erroExcessoLitros, contains('não pode ultrapassar 50.000 L'));
    });

    test('deve rejeitar abastecimento com odômetro superior a 10.000.000 KM', () {
      final erroExcessoKm = DespesaViewModel.validarLancamento(
        valorTotal: 400.0,
        tipo: 'ABASTECIMENTO',
        viagem: viagemMock,
        litros: 60.0,
        kmAtual: 10000001.0,
      );
      expect(erroExcessoKm, isNotNull);
      expect(erroExcessoKm, contains('excede o limite máximo permitido'));
    });

    test('deve aprovar abastecimento consistente com kmAtual superior ao inicial', () {
      final validacao = DespesaViewModel.validarLancamento(
        valorTotal: 400.0,
        tipo: 'ABASTECIMENTO',
        viagem: viagemMock,
        litros: 60.0,
        kmAtual: 653800.0,
      );
      expect(validacao, isNull);
    });
  });

  group('LitersTextInputFormatter - Formatação e Limites de Entrada', () {
    final formatter = LitersTextInputFormatter();

    test('deve formatar milhares com ponto separador', () {
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '65000'),
      );
      expect(result.text, equals('65.000'));
    });

    test('deve manter casas decimais com vírgula', () {
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '65000,50'),
      );
      expect(result.text, equals('65.000,50'));
    });

    test('deve limitar dígitos inteiros a 6 posições impedindo números gigantes como 6500000000000', () {
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '6500000000000'),
      );
      expect(result.text, equals('650.000'));
    });

    test('deve limitar casas decimais a no máximo 2', () {
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '120,456'),
      );
      expect(result.text, equals('120,45'));
    });
  });
}
