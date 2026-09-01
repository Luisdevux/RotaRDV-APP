import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class EstadoCidadeService {
  static final EstadoCidadeService _instance = EstadoCidadeService._internal();
  factory EstadoCidadeService() => _instance;
  EstadoCidadeService._internal();

  List<Map<String, dynamic>> _estados = [];
  List<Map<String, dynamic>> _cidades = [];
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  /// Carrega os estados e cidades do arquivo JSON em memória (apenas uma vez)
  Future<void> loadEstadosECidades() async {
    if (_isLoaded) return;

    try {
      final String response =
          await rootBundle.loadString('assets/json/ibge.json');
      final data = json.decode(response);

      final Map<int, String> stateSiglaMap = {};
      final Map<int, String> stateNameMap = {};

      _estados = (data['states'] as Map<String, dynamic>).entries.map((entry) {
        final stateId = int.tryParse(entry.key.toString()) ?? 0;
        final name = entry.value['name'].toString();
        final sigla = entry.value['sigla'].toString().toUpperCase();
        stateSiglaMap[stateId] = sigla;
        stateNameMap[stateId] = name;
        return {
          'id': entry.key.toString(),
          'name': name,
          'sigla': sigla,
        };
      }).toList();

      // Ordena estados por Nome (A-Z)
      _estados.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));

      _cidades = (data['cities'] as List<dynamic>).map((city) {
        final stateId = int.tryParse(city['state_id'].toString()) ?? 0;
        return {
          'id': city['id'],
          'state_id': stateId,
          'name': city['name'].toString(),
          'sigla': stateSiglaMap[stateId] ?? '',
          'estado_nome': stateNameMap[stateId] ?? '',
        };
      }).toList();

      // Pré-ordena cidades por Nome (A-Z)
      _cidades.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));

      _isLoaded = true;
    } catch (e) {
      debugPrint('Erro ao carregar estados e cidades: $e');
    }
  }

  /// Retorna a lista de todos os 27 estados do Brasil (ordenados de A a Z)
  List<Map<String, dynamic>> getEstados() {
    return _estados;
  }

  /// Busca um estado específico pela sigla (ex: "MT", "SP", "PA")
  Map<String, dynamic>? getEstadoPorSigla(String sigla) {
    try {
      final siglaUpper = sigla.toUpperCase().trim();
      return _estados.firstWhere((e) => e['sigla'] == siglaUpper);
    } catch (_) {
      return null;
    }
  }

  /// Filtra as cidades pelo estado selecionado (sigla: "MT", "RO", etc.)
  List<Map<String, dynamic>> getCidadesPorEstado(String estadoSigla) {
    try {
      final estadoSelecionado = getEstadoPorSigla(estadoSigla);
      if (estadoSelecionado == null) return [];

      final int stateId = int.parse(estadoSelecionado['id'].toString());
      return _cidades.where((cidade) => cidade['state_id'] == stateId).toList();
    } catch (e) {
      return [];
    }
  }

  /// Busca cidades por texto (insensível a maiúsculas/minúsculas e acentos)
  List<Map<String, dynamic>> buscarCidades(String query, {String? estadoSigla}) {
    final queryNormalizada = _removerAcentos(query.toLowerCase().trim());
    if (queryNormalizada.isEmpty) {
      return estadoSigla != null ? getCidadesPorEstado(estadoSigla) : [];
    }

    final listaBase = estadoSigla != null ? getCidadesPorEstado(estadoSigla) : _cidades;

    return listaBase.where((cidade) {
      final nomeNormalizado = _removerAcentos(cidade['name'].toString().toLowerCase());
      return nomeNormalizado.contains(queryNormalizada);
    }).toList();
  }

  /// Utilitário para remover acentos e facilitar a digitação do motorista
  static String _removerAcentos(String str) {
    const comAcento = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÖØòóôõöøÈÉÊËèéêëðÇçÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    const semAcento = 'AAAAAAaaaaaaOOOOOOooooooEEEEeeeeeCcIIIIiiiiUUUUuuuuNnSsYyyZz';

    String resultado = str;
    for (int i = 0; i < comAcento.length; i++) {
      resultado = resultado.replaceAll(comAcento[i], semAcento[i]);
    }
    return resultado;
  }
}
