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

    test('deve rejeitar abastecimento de diesel que excede capacidade do tanque do veículo', () {
      final erro = DespesaViewModel.validarLancamento(
        valorTotal: 3000.0,
        tipo: 'ABASTECIMENTO',
        viagem: viagemMock,
        litros: 650.0,
        kmAtual: 653800.0,
        capacidadeTanque: 600.0,
        tipoCombustivel: 'DIESEL_S10',
      );
      expect(erro, isNotNull);
      expect(erro, contains('excede a capacidade máxima do tanque do veículo'));
    });

    test('deve rejeitar abastecimento de Arla 32 que excede capacidade do reservatório de Arla', () {
      final erro = DespesaViewModel.validarLancamento(
        valorTotal: 400.0,
        tipo: 'ABASTECIMENTO',
        viagem: viagemMock,
        litros: 95.0,
        kmAtual: 653800.0,
        capacidadeTanque: 600.0,
        capacidadeArla: 80.0,
        tipoCombustivel: 'ARLA_32',
      );
      expect(erro, isNotNull);
      expect(erro, contains('excede a capacidade do reservatório'));
    });

    test('deve aprovar abastecimento de Arla 32 dentro da capacidade do reservatório de Arla', () {
      final validacao = DespesaViewModel.validarLancamento(
        valorTotal: 250.0,
        tipo: 'ABASTECIMENTO',
        viagem: viagemMock,
        litros: 50.0,
        kmAtual: 653800.0,
        capacidadeTanque: 600.0,
        capacidadeArla: 80.0,
        tipoCombustivel: 'ARLA_32',
      );
      expect(validacao, isNull);
    });

    test('deve rejeitar Arla 32 acima de 150 L mesmo sem capacidade informada e tanque principal sendo 1000 L', () {
      final erro = DespesaViewModel.validarLancamento(
        valorTotal: 800.0,
        tipo: 'ABASTECIMENTO',
        viagem: viagemMock,
        litros: 200.0,
        kmAtual: 653800.0,
        capacidadeTanque: 1000.0,
        capacidadeArla: null,
        tipoCombustivel: 'ARLA_32',
      );
      expect(erro, isNotNull);
      expect(erro, contains('excede a capacidade do reservatório (150 L)'));
    });

    test('deve rejeitar Gasolina em veículo cujo combustível preferencial é Diesel S10', () {
      final erro = DespesaViewModel.validarLancamento(
        valorTotal: 500.0,
        tipo: 'ABASTECIMENTO',
        viagem: viagemMock,
        litros: 80.0,
        kmAtual: 653800.0,
        capacidadeTanque: 600.0,
        tipoCombustivel: 'GASOLINA',
        combustivelPreferencial: 'DIESEL_S10',
      );
      expect(erro, isNotNull);
      expect(erro, contains('não é permitido para este veículo'));
    });

    test('deve rejeitar Etanol em veículo cujo combustível preferencial é Diesel S500', () {
      final erro = DespesaViewModel.validarLancamento(
        valorTotal: 400.0,
        tipo: 'ABASTECIMENTO',
        viagem: viagemMock,
        litros: 80.0,
        kmAtual: 653800.0,
        capacidadeTanque: 600.0,
        tipoCombustivel: 'ETANOL',
        combustivelPreferencial: 'DIESEL_S500',
      );
      expect(erro, isNotNull);
      expect(erro, contains('não é permitido para este veículo'));
    });

    test('deve rejeitar Diesel em veículo cujo combustível preferencial é Gasolina', () {
      final erro = DespesaViewModel.validarLancamento(
        valorTotal: 300.0,
        tipo: 'ABASTECIMENTO',
        viagem: viagemMock,
        litros: 50.0,
        kmAtual: 653800.0,
        capacidadeTanque: 60.0,
        tipoCombustivel: 'DIESEL_S10',
        combustivelPreferencial: 'GASOLINA',
      );
      expect(erro, isNotNull);
      expect(erro, contains('não é compatível com veículos não-diesel'));
    });

    test('deve rejeitar estritamente Diesel S500 em veículo cadastrado com Diesel S10 mesmo com descrição', () {
      final erro = DespesaViewModel.validarLancamento(
        valorTotal: 800.0,
        tipo: 'ABASTECIMENTO',
        viagem: viagemMock,
        litros: 150.0,
        kmAtual: 653800.0,
        capacidadeTanque: 600.0,
        tipoCombustivel: 'DIESEL_S500',
        combustivelPreferencial: 'DIESEL_S10',
        descricao: 'Tentativa de abastecimento emergencial',
      );
      expect(erro, isNotNull);
      expect(erro, contains('não é permitido para este veículo'));
      expect(erro, contains('exclusivamente com DIESEL_S10'));
    });

    test('deve aprovar Arla 32 em veículo Diesel S10', () {
      final validacao = DespesaViewModel.validarLancamento(
        valorTotal: 150.0,
        tipo: 'ABASTECIMENTO',
        viagem: viagemMock,
        litros: 30.0,
        kmAtual: 653800.0,
        capacidadeArla: 60.0,
        tipoCombustivel: 'ARLA_32',
        combustivelPreferencial: 'DIESEL_S10',
      );
      expect(validacao, isNull);
    });

    test('deve rejeitar Arla 32 em veículo cujo combustível preferencial é Gasolina', () {
      final erro = DespesaViewModel.validarLancamento(
        valorTotal: 150.0,
        tipo: 'ABASTECIMENTO',
        viagem: viagemMock,
        litros: 20.0,
        kmAtual: 653800.0,
        capacidadeTanque: 50.0,
        tipoCombustivel: 'ARLA_32',
        combustivelPreferencial: 'GASOLINA',
      );
      expect(erro, isNotNull);
      expect(erro, contains('não é compatível com veículos não-diesel'));
    });

    test('deve aprovar Etanol em veículo cujo combustível preferencial é Gasolina (motor flex)', () {
      final validacao = DespesaViewModel.validarLancamento(
        valorTotal: 200.0,
        tipo: 'ABASTECIMENTO',
        viagem: viagemMock,
        litros: 50.0,
        kmAtual: 653800.0,
        capacidadeTanque: 60.0,
        tipoCombustivel: 'ETANOL',
        combustivelPreferencial: 'GASOLINA',
      );
      expect(validacao, isNull);
    });

    test('deve aprovar Gasolina em veículo cujo combustível preferencial é Etanol (motor flex)', () {
      final validacao = DespesaViewModel.validarLancamento(
        valorTotal: 250.0,
        tipo: 'ABASTECIMENTO',
        viagem: viagemMock,
        litros: 45.0,
        kmAtual: 653800.0,
        capacidadeTanque: 60.0,
        tipoCombustivel: 'GASOLINA',
        combustivelPreferencial: 'ETANOL',
      );
      expect(validacao, isNull);
    });

    test('deve aprovar OUTRO em veículo cujo combustível preferencial é Gasolina (não-diesel)', () {
      final validacao = DespesaViewModel.validarLancamento(
        valorTotal: 180.0,
        tipo: 'ABASTECIMENTO',
        viagem: viagemMock,
        litros: 35.0,
        kmAtual: 653800.0,
        capacidadeTanque: 60.0,
        tipoCombustivel: 'OUTRO',
        combustivelPreferencial: 'GASOLINA',
      );
      expect(validacao, isNull);
    });
  });

  group('LitersTextInputFormatter - Formatação Centesimal e Limites de Entrada', () {
    final formatter = LitersTextInputFormatter();

    test('deve formatar centésimos primeiro ao digitar 12939 resultando em 129,39', () {
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '12939'),
      );
      expect(result.text, equals('129,39'));
    });

    test('deve formatar valores pequenos como centavos/centésimos (1 vira 0,01; 12 vira 0,12)', () {
      final res1 = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '1'),
      );
      expect(res1.text, equals('0,01'));

      final res12 = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '12'),
      );
      expect(res12.text, equals('0,12'));
    });

    test('deve formatar milhares com ponto separador ao digitar 120000 resultando em 1.200,00', () {
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '120000'),
      );
      expect(result.text, equals('1.200,00'));
    });

    test('deve limitar dígitos impedindo estouro de buffer', () {
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '6500000000000'),
      );
      expect(result.text, equals('650.000,00'));
    });

    test('deve permitir apagar via backspace reduzindo centésimos', () {
      final result = formatter.formatEditUpdate(
        const TextEditingValue(text: '129,39'),
        const TextEditingValue(text: '129,3'),
      );
      expect(result.text, equals('12,93'));
    });

    test('deve retornar vazio quando campo for limpo', () {
      final result = formatter.formatEditUpdate(
        const TextEditingValue(text: '0,01'),
        TextEditingValue.empty,
      );
      expect(result.text, equals(''));
    });
  });
}
