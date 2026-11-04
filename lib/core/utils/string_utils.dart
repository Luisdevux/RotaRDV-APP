// lib/core/utils/string_utils.dart

/// Utilitários para manipulação e normalização de texto.
abstract class StringUtils {
  static const _comAcento = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÖØòóôõöøÈÉÊËèéêëÇçÌÍÎÏìíîïÙÚÛÜùúûüÑñÝýÿ';
  static const _semAcento = 'AAAAAAaaaaaaOOOOOOooooooEEEEeeeeCcIIIIiiiiUUUUuuuuNnYyy';

  static final Map<int, String> _mapaAcentos = () {
    final map = <int, String>{};
    for (int i = 0; i < _comAcento.length; i++) {
      map[_comAcento.codeUnitAt(i)] = _semAcento[i];
    }
    return map;
  }();

  /// Remove acentos e caracteres diacríticos em O(N) com baixa alocação de memória.
  /// Ex: "São Paulo" -> "Sao Paulo", "Cuiabá" -> "Cuiaba", "Goiânia" -> "Goiania"
  static String removerAcentos(String str) {
    if (str.isEmpty) return str;
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      final code = str.codeUnitAt(i);
      final charSemAcento = _mapaAcentos[code];
      if (charSemAcento != null) {
        buffer.write(charSemAcento);
      } else {
        buffer.writeCharCode(code);
      }
    }
    return buffer.toString();
  }

  /// Normaliza texto para busca: converte para minúsculas, remove espaços extras e acentos.
  /// Ex: "  São Paulo  " -> "sao paulo", "CURITIBA" -> "curitiba"
  static String normalizarParaBusca(String? str) {
    if (str == null || str.isEmpty) return '';
    return removerAcentos(str.toLowerCase().trim());
  }

  /// Verifica se o texto alvo contém todos os termos da consulta informada.
  /// Insensível a maiúsculas/minúsculas e acentuação.
  /// Ex: busca "sao paulo" ou "são paulo" encontra "São Paulo / SP".
  static bool contemTermos(String? textoAlvo, String? termoBusca) {
    final query = normalizarParaBusca(termoBusca);
    if (query.isEmpty) return true;
    if (textoAlvo == null || textoAlvo.isEmpty) return false;

    final alvo = normalizarParaBusca(textoAlvo);
    final termos = query.split(RegExp(r'\s+')).where((t) => t.isNotEmpty);
    return termos.every((termo) => alvo.contains(termo));
  }
}
