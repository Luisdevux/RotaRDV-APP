// lib/features/despesas/despesa_viewmodel.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/database/local_database.dart';
import '../../models/despesa_collection.dart';
import '../../models/viagem_collection.dart';
import '../../services/sync_service.dart';

// Encapsula os cálculos estatísticos e de eficiência energética do veículo para um trecho específico ou para a totalidade da jornada.
class MetricasConsumoViagem {
  final double totalLitros;
  final double kmPercorridoTotal;
  final double? mediaConsumoGeral;
  final int totalAbastecimentos;
  final double? ultimoKmInformado;
  final double? mediaUltimoAbastecimento;
  final double? kmTrechoUltimo;
  final double? litrosUltimoAbastecimento;

  const MetricasConsumoViagem({
    required this.totalLitros,
    required this.kmPercorridoTotal,
    this.mediaConsumoGeral,
    required this.totalAbastecimentos,
    this.ultimoKmInformado,
    this.mediaUltimoAbastecimento,
    this.kmTrechoUltimo,
    this.litrosUltimoAbastecimento,
  });

  bool get temDadosAbastecimento => totalAbastecimentos > 0;
}

// ENUM: CATEGORIAS DE DESPESA OPERACIONAL
enum CategoriaDespesa {
  abastecimento('ABASTECIMENTO', 'Abastecimento'),
  alimentacao('ALIMENTACAO', 'Alimentação'),
  manutencao('MANUTENCAO', 'Manutenção'),
  pedagio('PEDAGIO', 'Pedágio'),
  outros('OUTROS', 'Outros');

  final String codigo;
  final String label;
  const CategoriaDespesa(this.codigo, this.label);

  static CategoriaDespesa fromCodigo(String codigo) {
    return CategoriaDespesa.values.firstWhere(
      (c) => c.codigo == codigo.toUpperCase(),
      orElse: () => CategoriaDespesa.outros,
    );
  }
}

// ViewModel responsável pelo ciclo de vida das despesas operacionais, validação estrita de consistência de odômetro e cálculos de eficiência de consumo
class DespesaViewModel extends ChangeNotifier {
  final Isar _isar = LocalDatabase.isar;
  final SyncService _syncService = SyncService();

  List<DespesaCollection> _despesas = [];
  bool _isLoading = false;
  String? _currentViagemId;
  String? errorMessage;

  List<DespesaCollection> get despesas => _despesas;
  bool get isLoading => _isLoading;
  String? get currentViagemId => _currentViagemId;

  double get totalGasto => _despesas.fold(0.0, (acc, d) => acc + d.valorTotal);

  Map<String, double> get gastosPorCategoria {
    final Map<String, double> mapa = {
      'ABASTECIMENTO': 0.0,
      'ALIMENTACAO': 0.0,
      'MANUTENCAO': 0.0,
      'PEDAGIO': 0.0,
      'OUTROS': 0.0,
    };
    for (final d in _despesas) {
      mapa[d.tipo] = (mapa[d.tipo] ?? 0.0) + d.valorTotal;
    }
    return mapa;
  }

  // ──────────────────────── VALIDAÇÃO DE DOMÍNIO ──────────────────────── //

  // Valida as regras de negócio para lançamento de despesa, impedindo inconsistências de odômetro e campos numéricos ausentes antes da persistência.
  static String? validarLancamento({
    required double valorTotal,
    required String tipo,
    required ViagemCollection? viagem,
    double? litros,
    double? kmAtual,
  }) {
    if (valorTotal <= 0) {
      return 'O valor total da despesa deve ser maior que zero.';
    }

    if (tipo.toUpperCase() == 'ABASTECIMENTO') {
      if (litros == null || litros <= 0) {
        return 'Informe a quantidade de litros abastecidos.';
      }
      if (kmAtual == null || kmAtual <= 0) {
        return 'Informe o odômetro (KM) atual do veículo para o abastecimento.';
      }
      if (viagem != null && kmAtual < viagem.kmInicial) {
        final kmIni = viagem.kmInicial.toInt();
        final kmInf = kmAtual.toInt();
        return 'O KM informado ($kmInf) não pode ser menor que o odômetro inicial da rota ($kmIni).';
      }
    }

    return null;
  }

  // ──────────────────────── CARREGAMENTO DE DADOS ─────────────────────── //

  // Carrega as despesas registradas para a rota especificada
  Future<void> carregarDespesas(String viagemId) async {
    _currentViagemId = viagemId;
    _isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _despesas = await _buscarDespesasAtivas(viagemId);
      await _verificarRecuperacaoFotosLocais(viagemId);
    } catch (e) {
      debugPrint('[DespesaViewModel] Erro ao carregar despesas: $e');
      errorMessage = 'Não foi possível carregar as despesas da rota.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<DespesaCollection>> _buscarDespesasAtivas(String viagemId) {
    return _isar.despesaCollections
        .filter()
        .viagemIdEqualTo(viagemId)
        .and()
        .not()
        .statusSincronizacaoEqualTo('deletado')
        .sortByDataDesc()
        .findAll();
  }

  Future<void> _verificarRecuperacaoFotosLocais(String viagemId) async {
    bool houveRecuperacao = false;

    for (final d in _despesas) {
      final semFotoRemota = d.fotoAnexoUrl == null || d.fotoAnexoUrl!.isEmpty;
      if (!semFotoRemota) continue;

      final recuperado = await resolverOuRecuperarFotoLocal(d.uuid, d.fotoAnexoLocalPath);
      if (recuperado != null && recuperado != d.fotoAnexoLocalPath) {
        d.fotoAnexoLocalPath = recuperado;
        await _isar.writeTxn(() => _isar.despesaCollections.put(d));
        houveRecuperacao = true;
      }
    }

    if (houveRecuperacao) {
      _despesas = await _buscarDespesasAtivas(viagemId);
    }
  }

  // ──────────────────────── CÁLCULOS DE CONSUMO ───────────────────────── //

  // Calcula as métricas consolidadas de consumo e eficiência (km/l)
  MetricasConsumoViagem calcularMetricasConsumo(
    ViagemCollection viagem, {
    double? kmFinalTemporario,
  }) {
    final abastecimentos = _extrairAbastecimentosOrdenados();
    final double totalLitros = _somarLitros(abastecimentos);
    final double? maxKmRegistrado = _obterMaiorKm(abastecimentos);

    final double kmPercorridoTotal = _calcularDistanciaPercorrida(
      kmInicial: viagem.kmInicial,
      kmFinalViagem: viagem.kmFinal,
      kmFinalTemporario: kmFinalTemporario,
      maxKmRegistrado: maxKmRegistrado,
    );

    final double? mediaGeral = (totalLitros > 0 && kmPercorridoTotal > 0)
        ? (kmPercorridoTotal / totalLitros)
        : null;

    final trecho = _calcularUltimoTrecho(
      abastecimentos: abastecimentos,
      kmInicial: viagem.kmInicial,
    );

    return MetricasConsumoViagem(
      totalLitros: totalLitros,
      kmPercorridoTotal: kmPercorridoTotal,
      mediaConsumoGeral: mediaGeral,
      totalAbastecimentos: abastecimentos.length,
      ultimoKmInformado: maxKmRegistrado,
      mediaUltimoAbastecimento: trecho.media,
      kmTrechoUltimo: trecho.distancia,
      litrosUltimoAbastecimento: trecho.litros,
    );
  }

  List<DespesaCollection> _extrairAbastecimentosOrdenados() {
    final lista = _despesas
        .where((d) => d.tipo == 'ABASTECIMENTO' && d.statusSincronizacao != 'deletado')
        .toList();

    lista.sort((a, b) {
      if (a.kmAtual != null && b.kmAtual != null) {
        return a.kmAtual!.compareTo(b.kmAtual!);
      }
      return a.data.compareTo(b.data);
    });

    return lista;
  }

  double _somarLitros(List<DespesaCollection> abastecimentos) {
    return abastecimentos.fold(0.0, (acc, d) => acc + (d.litros ?? 0.0));
  }

  double? _obterMaiorKm(List<DespesaCollection> abastecimentos) {
    double? maxKm;
    for (final d in abastecimentos) {
      if (d.kmAtual != null && (maxKm == null || d.kmAtual! > maxKm)) {
        maxKm = d.kmAtual;
      }
    }
    return maxKm;
  }

  double _calcularDistanciaPercorrida({
    required double kmInicial,
    double? kmFinalViagem,
    double? kmFinalTemporario,
    double? maxKmRegistrado,
  }) {
    if (kmFinalTemporario != null && kmFinalTemporario > kmInicial) {
      return kmFinalTemporario - kmInicial;
    }
    if (kmFinalViagem != null && kmFinalViagem > kmInicial) {
      return kmFinalViagem - kmInicial;
    }
    if (maxKmRegistrado != null && maxKmRegistrado > kmInicial) {
      return maxKmRegistrado - kmInicial;
    }
    return 0.0;
  }

  ({double? media, double? distancia, double? litros}) _calcularUltimoTrecho({
    required List<DespesaCollection> abastecimentos,
    required double kmInicial,
  }) {
    final validos = abastecimentos
        .where((a) => (a.litros ?? 0) > 0 && (a.kmAtual ?? 0) > kmInicial)
        .toList();

    if (validos.isEmpty) {
      return (media: null, distancia: null, litros: null);
    }

    final ultimo = validos.last;
    final int index = validos.indexOf(ultimo);
    final double kmAnterior = (index > 0) ? (validos[index - 1].kmAtual ?? kmInicial) : kmInicial;

    if (ultimo.kmAtual! <= kmAnterior) {
      return (media: null, distancia: null, litros: ultimo.litros);
    }

    final distancia = ultimo.kmAtual! - kmAnterior;
    final litros = ultimo.litros;
    final media = (litros != null && litros > 0) ? (distancia / litros) : null;

    return (media: media, distancia: distancia, litros: litros);
  }

  // ──────────────────────── PERSISTÊNCIA DE DESPESA ───────────────────── //

  // Persiste a nova despesa no banco local após validação de consistência
  Future<bool> salvarDespesa({
    required String viagemId,
    required String tipo,
    required double valorTotal,
    required DateTime data,
    String? local,
    String? descricao,
    File? comprovanteFile,
    bool fotoTiradaNoApp = true,
    double? litros,
    double? valorLitro,
    String? tipoCombustivel,
    double? kmAtual,
  }) async {
    _isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Validação de consistência contra a viagem no banco
      final viagem = await _isar.viagemCollections.filter().uuidEqualTo(viagemId).findFirst();
      final erro = validarLancamento(
        valorTotal: valorTotal,
        tipo: tipo,
        viagem: viagem,
        litros: litros,
        kmAtual: kmAtual,
      );

      if (erro != null) {
        errorMessage = erro;
        return false;
      }

      final localFotoPath = await _salvarArquivoComprovante(comprovanteFile);
      final novaDespesaUuid = const Uuid().v4();

      final novaDespesa = DespesaCollection()
        ..uuid = novaDespesaUuid
        ..viagemId = viagemId
        ..tipo = tipo.toUpperCase()
        ..valorTotal = valorTotal
        ..data = data
        ..local = local?.trim()
        ..descricao = descricao?.trim()
        ..fotoAnexoLocalPath = localFotoPath
        ..fotoTiradaNoApp = fotoTiradaNoApp
        ..litros = litros
        ..valorLitro = valorLitro
        ..tipoCombustivel = tipoCombustivel
        ..kmAtual = kmAtual
        ..statusSincronizacao = 'criado';

      await _isar.writeTxn(() => _isar.despesaCollections.put(novaDespesa));
      await carregarDespesas(viagemId);

      _syncService.syncAll();
      return true;
    } catch (e) {
      debugPrint('[DespesaViewModel] Falha ao persistir despesa: $e');
      errorMessage = 'Falha ao salvar a despesa no armazenamento local.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> _salvarArquivoComprovante(File? file) async {
    if (file == null || !await file.exists()) return null;

    final appDir = await getApplicationDocumentsDirectory();
    final comprovantesDir = Directory('${appDir.path}/comprovantes');
    if (!await comprovantesDir.exists()) {
      await comprovantesDir.create(recursive: true);
    }

    final id = const Uuid().v4();
    final destino = '${comprovantesDir.path}/comprovante_$id.jpg';
    final arquivoSalvo = await file.copy(destino);
    return arquivoSalvo.path;
  }

  // ──────────────────────── EXCLUSÃO DE DESPESA ───────────────────────── //

  // Realiza a exclusão da despesa (com soft delete para sincronização quando já sincronizado)
  Future<bool> excluirDespesa(DespesaCollection despesa) async {
    try {
      await _limparArquivoLocalSeApp(despesa);

      await _isar.writeTxn(() async {
        if (despesa.statusSincronizacao == 'criado') {
          await _isar.despesaCollections.delete(despesa.id);
        } else {
          despesa.statusSincronizacao = 'deletado';
          despesa.fotoAnexoLocalPath = null;
          await _isar.despesaCollections.put(despesa);
        }
      });

      if (_currentViagemId != null) {
        await carregarDespesas(_currentViagemId!);
      }

      _syncService.syncAll();
      return true;
    } catch (e) {
      debugPrint('[DespesaViewModel] Erro ao excluir despesa: $e');
      errorMessage = 'Não foi possível excluir a despesa selecionada.';
      return false;
    }
  }

  // Limpa o arquivo local da despesa se ela foi tirada no app
  Future<void> _limparArquivoLocalSeApp(DespesaCollection despesa) async {
    if (despesa.fotoTiradaNoApp != true || despesa.fotoAnexoLocalPath == null) return;
    final file = File(despesa.fotoAnexoLocalPath!);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
