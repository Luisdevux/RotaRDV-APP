import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/database/local_database.dart';
import '../core/network/api_client.dart';
import '../models/despesa_collection.dart';
import '../models/viagem_collection.dart';
import 'package:path_provider/path_provider.dart';
import 'storage_cleaner_service.dart';

class PendingSyncSummary {
  final int viagensPendentes;
  final int despesasPendentes;
  final int fotosPendentes;

  const PendingSyncSummary({
    required this.viagensPendentes,
    required this.despesasPendentes,
    required this.fotosPendentes,
  });

  int get totalPendencias => viagensPendentes + despesasPendentes + fotosPendentes;
  bool get hasPending => totalPendencias > 0;
}

/// Localiza ou recupera o arquivo físico de comprovante para uma despesa,
/// garantindo resiliência contra caminhos perdidos, arquivos órfãos e cache temporário.
Future<String?> resolverOuRecuperarFotoLocal(String despesaUuid, String? caminhoAtual) async {
  try {
    // 1. Se já tem caminho e o arquivo existe fisicamente no aparelho, mantém ele
    if (caminhoAtual != null && caminhoAtual.isNotEmpty) {
      final f = File(caminhoAtual);
      if (await f.exists()) return caminhoAtual;
    }

    final appDir = await getApplicationDocumentsDirectory();
    final comprovantesDir = Directory('${appDir.path}/comprovantes');
    if (!await comprovantesDir.exists()) {
      await comprovantesDir.create(recursive: true);
    }

    // 2. Procura pelo nome padronizado vinculado ao UUID da despesa na pasta permanente
    final arquivoPorUuid = File('${comprovantesDir.path}/comprovante_$despesaUuid.jpg');
    if (await arquivoPorUuid.exists()) {
      debugPrint('[AutoRecovery] Foto encontrada pelo UUID da despesa: ${arquivoPorUuid.path}');
      return arquivoPorUuid.path;
    }

    // 3. Procura por qualquer arquivo na pasta comprovantes contendo o UUID
    final entries = await comprovantesDir.list().toList();
    final files = entries.whereType<File>().toList();
    for (var f in files) {
      if (f.path.contains(despesaUuid)) {
        debugPrint('[AutoRecovery] Foto encontrada por correspondência parcial de UUID: ${f.path}');
        return f.path;
      }
    }

    // 4. Procura no diretório temporário/cache do app (onde o ImagePicker grava originalmente)
    final tempDir = await getTemporaryDirectory();
    if (await tempDir.exists()) {
      final tempEntries = await tempDir.list().toList();
      final tempImages = tempEntries.whereType<File>().where((f) {
        final p = f.path.toLowerCase();
        return p.endsWith('.jpg') || p.endsWith('.jpeg') || p.endsWith('.png');
      }).toList();

      if (tempImages.isNotEmpty) {
        // Ordena por data de modificação decrescente (o mais recente primeiro)
        tempImages.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
        final maisRecente = tempImages.first;
        final arquivoPermanente = await maisRecente.copy(arquivoPorUuid.path);
        debugPrint('[AutoRecovery] Arquivo recuperado do cache temporário e salvo permanentemente: ${arquivoPermanente.path}');
        return arquivoPermanente.path;
      }
    }

    // 5. Procura no diretório comprovantes por arquivos .jpg órfãos existentes
    final jpgs = files.where((f) {
      final p = f.path.toLowerCase();
      return p.endsWith('.jpg') || p.endsWith('.jpeg') || p.endsWith('.png');
    }).toList();

    if (jpgs.isNotEmpty) {
      jpgs.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      final recuperado = jpgs.first;
      debugPrint('[AutoRecovery] Arquivo órfão mais recente recuperado: ${recuperado.path}');
      return recuperado.path;
    }
  } catch (e) {
    debugPrint('[AutoRecovery] Erro ao tentar recuperar foto local: $e');
  }
  return null;
}

class SyncService {
  // Singleton
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  
  /// Notificador reativo de eventos de sincronização para atualizar as telas da UI
  final ValueNotifier<int> syncEventNotifier = ValueNotifier<int>(0);

  /// Inicializa o listener de conectividade do aparelho.
  /// Sempre que o aparelho voltar a ter rede (Wi-Fi ou Dados Móveis), dispara automaticamente o syncAll.
  void initConnectivityListener() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) async {
      final isOffline = results.contains(ConnectivityResult.none) || results.isEmpty;
      if (!isOffline) {
        debugPrint('[SyncService] Conexão com a internet restabelecida! Aguardando estabilização para sincronizar...');
        // Aguarda 1 segundo para garantir que a interface de rede do dispositivo estabilizou
        await Future.delayed(const Duration(milliseconds: 1000));
        syncAll();
      }
    });
    debugPrint('[SyncService] Listener de conectividade inicializado com sucesso.');
  }

  /// Cancela o listener de conectividade
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }

  /// Executa o ciclo completo de sincronização (Push -> Pull) com política de até [maxRetries] tentativas.
  /// Se não conseguir conectar após as tentativas, os dados locais são mantidos sem percas e o sync aguarda o próximo ciclo.
  Future<bool> syncAll({int maxRetries = 3}) async {
    if (_isSyncing) {
      debugPrint('[SyncService] Sincronização já está em andamento. Ignorando chamada concorrente.');
      return false;
    }

    _isSyncing = true;
    int attempt = 0;
    bool success = false;

    while (attempt < maxRetries && !success) {
      attempt++;
      try {
        debugPrint('[SyncService] Iniciando ciclo de sincronização (Tentativa $attempt/$maxRetries)...');
        
        // PUSH: Envia tudo que foi criado/editado/deletado localmente para o backend
        await pushSync();
        
        // PULL: Baixa as alterações e novidades da nuvem
        await pullSync();

        // Exclusão de fotos antigas: Limpa fotos locais de viagens concluídas há mais de 15 dias tiradas no app
        await StorageCleanerService().purgeOldSyncedPhotos();

        success = true;
        debugPrint('[SyncService] Sincronização concluída com sucesso na tentativa $attempt!');
        syncEventNotifier.value++;
      } catch (e) {
        debugPrint('[SyncService] Erro na tentativa $attempt/$maxRetries de sincronização: $e');
        if (attempt < maxRetries) {
          // Delay progressivo antes da próxima tentativa: 1.5s, 3.0s...
          final waitDuration = Duration(milliseconds: 1500 * attempt);
          debugPrint('[SyncService] Aguardando ${waitDuration.inMilliseconds}ms antes de tentar novamente...');
          await Future.delayed(waitDuration);
        } else {
          debugPrint('[SyncService] Atingido o limite de $maxRetries tentativas. Dados locais mantidos seguros no Isar. Aguardando novo sinal de rede.');
        }
      }
    }

    _isSyncing = false;
    return success;
  }

  /// Resumo detalhado de todas as pendências de sincronização locais
  Future<PendingSyncSummary> getPendingSyncSummary() async {
    final isar = LocalDatabase.isar;

    final viagensParaSincronizar = await isar.viagemCollections
        .filter()
        .group((q) => q
            .statusSincronizacaoEqualTo('criado')
            .or()
            .statusSincronizacaoEqualTo('editado')
            .or()
            .statusSincronizacaoEqualTo('deletado'))
        .count();

    final despesasParaSincronizar = await isar.despesaCollections
        .filter()
        .group((q) => q
            .statusSincronizacaoEqualTo('criado')
            .or()
            .statusSincronizacaoEqualTo('deletado'))
        .count();

    final fotosPendentes = await isar.despesaCollections
        .filter()
        .fotoAnexoLocalPathIsNotNull()
        .and()
        .group((q) => q.fotoAnexoUrlIsNull().or().fotoAnexoUrlEqualTo(''))
        .and()
        .not()
        .statusSincronizacaoEqualTo('deletado')
        .count();

    return PendingSyncSummary(
      viagensPendentes: viagensParaSincronizar,
      despesasPendentes: despesasParaSincronizar,
      fotosPendentes: fotosPendentes,
    );
  }

  /// Verifica se há registros locais ou fotos pendentes de envio para a API
  Future<bool> hasPendingSync() async {
    final summary = await getPendingSyncSummary();
    return summary.hasPending;
  }

  /// Envia alterações locais e fotos de comprovantes para a nuvem (Garage)
  Future<void> pushSync() async {
    final isar = LocalDatabase.isar;

    final viagensParaSincronizar = await isar.viagemCollections
        .filter()
        .group((q) => q
            .statusSincronizacaoEqualTo('criado')
            .or()
            .statusSincronizacaoEqualTo('editado')
            .or()
            .statusSincronizacaoEqualTo('deletado'))
        .findAll();

    // Despesas são imutáveis após o lançamento (motoristas não possuem permissão de edição).
    // Apenas registros criados ou deletados pendentes de envio são processados no lote.
    final despesasParaSincronizar = await isar.despesaCollections
        .filter()
        .group((q) => q
            .statusSincronizacaoEqualTo('criado')
            .or()
            .statusSincronizacaoEqualTo('deletado'))
        .findAll();

    // 1. Envia registros de texto/metadados para o backend
    if (viagensParaSincronizar.isNotEmpty || despesasParaSincronizar.isNotEmpty) {
      debugPrint('[SyncService] Enviando ${viagensParaSincronizar.length} viagem(ns) e ${despesasParaSincronizar.length} despesa(s) para o servidor...');

      final payload = {
        'viagens': viagensParaSincronizar.map((v) => {
          '_id': v.uuid,
          'origem': { 'cidade': v.origemCidade, 'estado': v.origemEstado },
          'destino': { 'cidade': v.destinoCidade, 'estado': v.destinoEstado },
          'km_inicial': v.kmInicial,
          'km_final': v.kmFinal,
          'data_inicio': v.dataInicio.toUtc().toIso8601String(),
          'data_fim': v.dataFim?.toUtc().toIso8601String(),
          'status': v.status,
          'is_deleted': v.statusSincronizacao == 'deletado'
        }).toList(),
        'despesas': despesasParaSincronizar.map((d) => {
          '_id': d.uuid,
          'viagem_id': d.viagemId,
          'tipo': d.tipo,
          'valor_total': d.valorTotal,
          'data': d.data.toUtc().toIso8601String(),
          'local': d.local,
          'descricao': d.descricao,
          'litros': d.litros,
          'valor_litro': d.valorLitro,
          'tipo_combustivel': d.tipoCombustivel,
          'km_atual': d.kmAtual,
          'is_deleted': d.statusSincronizacao == 'deletado'
        }).toList()
      };

      final response = await ApiClient.post('/sync/push', body: payload);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Extrai eventuais itens rejeitados pelos validadores de domínio do backend
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final dynamic dataField = responseData['data'];
        final List<dynamic> rejeitadosList = (dataField is Map && dataField['rejeitados'] is List)
            ? dataField['rejeitados'] as List
            : [];

        final Set<String> idsRejeitados = rejeitadosList
            .map((r) => r['id']?.toString() ?? '')
            .where((id) => id.isNotEmpty)
            .toSet();

        await isar.writeTxn(() async {
          // Viagens
          for (var v in viagensParaSincronizar) {
            if (idsRejeitados.contains(v.uuid)) {
              v.statusSincronizacao = 'erro_validacao';
              await isar.viagemCollections.put(v);
              debugPrint('[SyncService] Viagem ${v.uuid} rejeitada pelo servidor por inconsistência de domínio.');
            } else if (v.statusSincronizacao == 'deletado') {
              await isar.viagemCollections.delete(v.id);
            } else {
              v.statusSincronizacao = 'sincronizado';
              await isar.viagemCollections.put(v);
            }
          }
          // Despesas
          for (var d in despesasParaSincronizar) {
            if (idsRejeitados.contains(d.uuid)) {
              d.statusSincronizacao = 'erro_validacao';
              await isar.despesaCollections.put(d);
              debugPrint('[SyncService] Despesa ${d.uuid} rejeitada pelo servidor por inconsistência de domínio.');
            } else if (d.statusSincronizacao == 'deletado') {
              await isar.despesaCollections.delete(d.id);
            } else {
              d.statusSincronizacao = 'sincronizado';
              await isar.despesaCollections.put(d);
            }
          }
        });
        debugPrint('[SyncService] PushSync concluído (${viagensParaSincronizar.length} viagens, ${despesasParaSincronizar.length} despesas). Rejeitados: ${idsRejeitados.length}');
      } else {
        throw Exception('Falha no PushSync (Status ${response.statusCode}): ${response.body}');
      }
    }

    // 2. Upload de Fotos/Comprovantes pendentes para o Storage (Garage)
    final despesasSemFotoRemota = await isar.despesaCollections
        .filter()
        .group((q) => q.fotoAnexoUrlIsNull().or().fotoAnexoUrlEqualTo(''))
        .and()
        .not()
        .statusSincronizacaoEqualTo('deletado')
        .findAll();

    if (despesasSemFotoRemota.isNotEmpty) {
      debugPrint('[SyncService] Verificando fotos pendentes para ${despesasSemFotoRemota.length} despesa(s)...');

      for (var d in despesasSemFotoRemota) {
        if (d.fotoAnexoLocalPath == null || d.fotoAnexoLocalPath!.isEmpty || !await File(d.fotoAnexoLocalPath!).exists()) {
          final recuperado = await resolverOuRecuperarFotoLocal(d.uuid, d.fotoAnexoLocalPath);
          if (recuperado != null) {
            d.fotoAnexoLocalPath = recuperado;
            await isar.writeTxn(() async {
              await isar.despesaCollections.put(d);
            });
          } else {
            continue;
          }
        }
        final file = File(d.fotoAnexoLocalPath!);
        if (!await file.exists()) continue;

        try {
          final uploadRes = await ApiClient.uploadFile(
            '/despesas/${d.uuid}/foto',
            file: file,
            fieldName: 'comprovante',
          );

          if (uploadRes.statusCode == 200 || uploadRes.statusCode == 201) {
            final uploadJson = jsonDecode(uploadRes.body);
            final url = uploadJson['data']?['url'] ??
                uploadJson['data']?['foto_anexo'] ??
                uploadJson['data']?['fileUrl'] ??
                uploadJson['data']?['link'];

            if (url != null && url.toString().isNotEmpty) {
              await isar.writeTxn(() async {
                d.fotoAnexoUrl = url.toString();
                d.statusSincronizacao = 'sincronizado';
                await isar.despesaCollections.put(d);
              });
              debugPrint('[SyncService] Comprovante da despesa ${d.uuid} salvo no Garage com sucesso: $url');
            }
          } else {
            debugPrint('[SyncService] Falha ao enviar comprovante da despesa ${d.uuid} (${uploadRes.statusCode}): ${uploadRes.body}');
          }
        } catch (e) {
          debugPrint('[SyncService] Erro durante o upload do comprovante da despesa ${d.uuid}: $e');
        }
      }
    }
  }

  /// Baixa alterações recentes da nuvem para o banco local Isar
  Future<void> pullSync({bool forceFullSync = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final isar = LocalDatabase.isar;

    // Se o banco local estiver vazio de viagens, ou forceFullSync for true:
    // Faz PULL COMPLETO sem updatedAfter para restaurar todo o histórico do motorista da nuvem
    final localCount = await isar.viagemCollections.count();
    final shouldFullSync = forceFullSync || localCount == 0;

    String? lastSyncStr = shouldFullSync ? null : prefs.getString('last_pull_sync_date');
    if (shouldFullSync) {
      await prefs.remove('last_pull_sync_date');
      debugPrint('[SyncService] Banco local vazio ou full sync solicitado ($localCount registros). Puxando histórico completo da nuvem...');
    }
    
    String endpoint = '/sync/pull';
    if (lastSyncStr != null) {
      endpoint += '?updatedAfter=${Uri.encodeComponent(lastSyncStr)}';
    }

    final response = await ApiClient.get(endpoint);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonBody = jsonDecode(response.body);
      final data = jsonBody['data'];
      if (data == null) return;

      final List viagensRaw = data['viagens'] ?? [];
      final List despesasRaw = data['despesas'] ?? [];

      final isar = LocalDatabase.isar;
      
      await isar.writeTxn(() async {
        // Viagens
        for (var vRaw in viagensRaw) {
          final uuid = vRaw['_id'];
          var viagem = await isar.viagemCollections.filter().uuidEqualTo(uuid).findFirst();
          viagem ??= ViagemCollection()..uuid = uuid;
          
          // Se o registro local foi editado e ainda não fez push, preserva o local
          if (viagem.id == Isar.autoIncrement || viagem.statusSincronizacao == 'sincronizado') {
            viagem.origemCidade = vRaw['origem']['cidade'];
            viagem.origemEstado = vRaw['origem']['estado'];
            viagem.destinoCidade = vRaw['destino']['cidade'];
            viagem.destinoEstado = vRaw['destino']['estado'];
            viagem.kmInicial = (vRaw['km_inicial'] as num).toDouble();
            viagem.kmFinal = vRaw['km_final'] != null ? (vRaw['km_final'] as num).toDouble() : null;
            
            DateTime parseDate(String d) {
              if (d.contains('/')) {
                final parts = d.split(' ')[0].split('/');
                return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
              }
              final parsed = DateTime.parse(d);
              return parsed.isUtc ? parsed.toLocal() : parsed;
            }

            viagem.dataInicio = parseDate(vRaw['data_inicio']);
            if (vRaw['data_fim'] != null) {
              viagem.dataFim = parseDate(vRaw['data_fim']);
            }
            viagem.status = vRaw['status'] ?? 'em_andamento';
            viagem.statusSincronizacao = 'sincronizado';

            await isar.viagemCollections.put(viagem);
          }
        }

        // Despesas
        for (var dRaw in despesasRaw) {
          final uuid = dRaw['_id'];
          var despesa = await isar.despesaCollections.filter().uuidEqualTo(uuid).findFirst();
          despesa ??= DespesaCollection()..uuid = uuid;

          // Localiza ou recupera foto física localmente caso ela já exista no aparelho
          final fotoLocal = await resolverOuRecuperarFotoLocal(uuid, despesa.fotoAnexoLocalPath);
          if (fotoLocal != null) {
            despesa.fotoAnexoLocalPath = fotoLocal;
          }

          if (despesa.id == Isar.autoIncrement || despesa.statusSincronizacao == 'sincronizado') {
            despesa.viagemId = dRaw['viagem_id'];
            despesa.tipo = dRaw['tipo'];
            despesa.valorTotal = (dRaw['valor_total'] as num).toDouble();
            
            DateTime parseDate(String d) {
              if (d.contains('/')) {
                final parts = d.split(' ')[0].split('/');
                return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
              }
              final parsed = DateTime.parse(d);
              return parsed.isUtc ? parsed.toLocal() : parsed;
            }

            despesa.data = parseDate(dRaw['data']);
            despesa.local = dRaw['local'];
            despesa.descricao = dRaw['descricao'];
            if (dRaw['litros'] != null) {
              despesa.litros = (dRaw['litros'] as num).toDouble();
            }
            if (dRaw['valor_litro'] != null) {
              despesa.valorLitro = (dRaw['valor_litro'] as num).toDouble();
            }
            if (dRaw['tipo_combustivel'] != null) {
              despesa.tipoCombustivel = dRaw['tipo_combustivel'];
            }
            if (dRaw['km_atual'] != null) {
              despesa.kmAtual = (dRaw['km_atual'] as num).toDouble();
            }

            final remoteUrl = dRaw['foto_anexo'];
            if (remoteUrl != null && remoteUrl.toString().isNotEmpty) {
              despesa.fotoAnexoUrl = remoteUrl.toString();
            }

            despesa.statusSincronizacao = 'sincronizado';

            await isar.despesaCollections.put(despesa);
          }
        }
      });

      // Atualiza os dados do veículo em cache se vier no retorno
      if (data['veiculo'] != null) {
        await prefs.setString('currentVehicle', jsonEncode(data['veiculo']));
        debugPrint('[SyncService] Dados do veículo atualizados no cache: ${data['veiculo']['modelo']} (${data['veiculo']['placa']})');
      } else {
        await prefs.remove('currentVehicle');
      }

      // Salva o momento do sync (UTC)
      await prefs.setString('last_pull_sync_date', DateTime.now().toUtc().toIso8601String());
      debugPrint('[SyncService] PullSync concluído com sucesso.');
    } else {
      throw Exception('Falha no PullSync (Status ${response.statusCode}): ${response.body}');
    }
  }
}
