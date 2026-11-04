import 'package:flutter_test/flutter_test.dart';
import 'package:app_despesas/core/utils/string_utils.dart';

void main() {
  group('StringUtils - Remoção de Acentos e Normalização de Texto', () {
    test('deve remover acentos de vogais e consoantes mantendo o texto legível', () {
      expect(StringUtils.removerAcentos('São Paulo'), equals('Sao Paulo'));
      expect(StringUtils.removerAcentos('são paulo'), equals('sao paulo'));
      expect(StringUtils.removerAcentos('Cuiabá'), equals('Cuiaba'));
      expect(StringUtils.removerAcentos('Goiânia'), equals('Goiania'));
      expect(StringUtils.removerAcentos('Belém'), equals('Belem'));
      expect(StringUtils.removerAcentos('Maranhão'), equals('Maranhao'));
      expect(StringUtils.removerAcentos('Piauí'), equals('Piaui'));
      expect(StringUtils.removerAcentos('Ceará'), equals('Ceara'));
      expect(StringUtils.removerAcentos('Paraná'), equals('Parana'));
      expect(StringUtils.removerAcentos('Amapá'), equals('Amapa'));
      expect(StringUtils.removerAcentos('Rondônia'), equals('Rondonia'));
      expect(StringUtils.removerAcentos('Brasília'), equals('Brasilia'));
      expect(StringUtils.removerAcentos('Poços de Caldas'), equals('Pocos de Caldas'));
      expect(StringUtils.removerAcentos('Ribeirão Preto'), equals('Ribeirao Preto'));
    });

    test('deve normalizar texto para busca (minúsculas, sem acentos e sem espaços laterais)', () {
      expect(StringUtils.normalizarParaBusca('  São Paulo  '), equals('sao paulo'));
      expect(StringUtils.normalizarParaBusca('SÃO PAULO'), equals('sao paulo'));
      expect(StringUtils.normalizarParaBusca('sao paulo'), equals('sao paulo'));
      expect(StringUtils.normalizarParaBusca(null), equals(''));
      expect(StringUtils.normalizarParaBusca(''), equals(''));
    });

    test('deve encontrar termos ignorando acentuação e maiúsculas/minúsculas (Ex: "sao paulo" acha "São Paulo")', () {
      const rota = 'São Paulo SP Curitiba PR';

      // Busca sem acento encontrando alvo com acento (o bug relatado pelo usuário)
      expect(StringUtils.contemTermos(rota, 'sao paulo'), isTrue);
      expect(StringUtils.contemTermos(rota, 'sao'), isTrue);
      expect(StringUtils.contemTermos(rota, 'paulo'), isTrue);

      // Busca com acento encontrando alvo com acento
      expect(StringUtils.contemTermos(rota, 'são paulo'), isTrue);
      expect(StringUtils.contemTermos(rota, 'SÃO PAULO'), isTrue);
      expect(StringUtils.contemTermos(rota, 'São Paulo'), isTrue);

      // Destino e UFs
      expect(StringUtils.contemTermos(rota, 'curitiba'), isTrue);
      expect(StringUtils.contemTermos(rota, 'sp'), isTrue);
      expect(StringUtils.contemTermos(rota, 'pr'), isTrue);
      expect(StringUtils.contemTermos(rota, 'sao paulo curitiba'), isTrue);

      // Termos inexistentes
      expect(StringUtils.contemTermos(rota, 'rio de janeiro'), isFalse);
      expect(StringUtils.contemTermos(rota, 'cuiaba'), isFalse);
    });

    test('deve encontrar cidades e estados com acentuação diversa mesmo digitando sem acento', () {
      expect(StringUtils.contemTermos('Cuiabá MT', 'cuiaba'), isTrue);
      expect(StringUtils.contemTermos('Cuiabá MT', 'cuiabá'), isTrue);
      expect(StringUtils.contemTermos('Goiânia GO', 'goiania'), isTrue);
      expect(StringUtils.contemTermos('Goiânia GO', 'goiânia'), isTrue);
      expect(StringUtils.contemTermos('Porto Velho RO (Rondônia)', 'rondonia'), isTrue);
      expect(StringUtils.contemTermos('Porto Velho RO (Rondônia)', 'rondônia'), isTrue);
      expect(StringUtils.contemTermos('Curitiba PR (Paraná)', 'parana'), isTrue);
      expect(StringUtils.contemTermos('Belém PA (Pará)', 'belem'), isTrue);
      expect(StringUtils.contemTermos('Belém PA (Pará)', 'para'), isTrue);
    });
  });
}
