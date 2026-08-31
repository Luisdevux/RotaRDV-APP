import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/database/local_database.dart';
import '../../core/network/api_client.dart';
import '../../models/despesa_collection.dart';
import '../../models/viagem_collection.dart';

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

  /// Verifica se há registros locais pendentes de envio para a API
  Future<bool> hasPendingSync() async {
    final isar = LocalDatabase.isar;

    final viagensParaSincronizar = await isar.viagemCollections
        .filter()
        .not()
        .statusSincronizacaoEqualTo('sincronizado')
        .count();

    final despesasParaSincronizar = await isar.despesaCollections
        .filter()
        .not()
        .statusSincronizacaoEqualTo('sincronizado')
        .count();

    return viagensParaSincronizar > 0 || despesasParaSincronizar > 0;
  }

  /// Envia alterações locais para a nuvem
  Future<void> pushSync() async {
    final isar = LocalDatabase.isar;

    final viagensParaSincronizar = await isar.viagemCollections
        .filter()
        .not()
        .statusSincronizacaoEqualTo('sincronizado')
        .findAll();

    final despesasParaSincronizar = await isar.despesaCollections
        .filter()
        .not()
        .statusSincronizacaoEqualTo('sincronizado')
        .findAll();

    if (viagensParaSincronizar.isEmpty && despesasParaSincronizar.isEmpty) {
      debugPrint('[SyncService] Nenhuma alteração local pendente de envio para o push.');
      return; 
    }

    debugPrint('[SyncService] Enviando ${viagensParaSincronizar.length} viagem(ns) e ${despesasParaSincronizar.length} despesa(s) para o servidor...');

    final payload = {
      'viagens': viagensParaSincronizar.map((v) => {
        '_id': v.uuid,
        'origem': { 'cidade': v.origemCidade, 'estado': v.origemEstado },
        'destino': { 'cidade': v.destinoCidade, 'estado': v.destinoEstado },
        'km_inicial': v.kmInicial,
        'km_final': v.kmFinal,
        'data_inicio': v.dataInicio.toIso8601String(),
        'data_fim': v.dataFim?.toIso8601String(),
        'status': v.status,
        'is_deleted': v.statusSincronizacao == 'deletado'
      }).toList(),
      'despesas': despesasParaSincronizar.map((d) => {
        '_id': d.uuid,
        'viagem_id': d.viagemId,
        'tipo': d.tipo,
        'valor_total': d.valorTotal,
        'data': d.data.toIso8601String(),
        'local': d.local,
        'descricao': d.descricao,
        'is_deleted': d.statusSincronizacao == 'deletado'
      }).toList()
    };

    final response = await ApiClient.post('/sync/push', body: payload);

    if (response.statusCode == 200 || response.statusCode == 201) {
      await isar.writeTxn(() async {
        // Viagens
        for (var v in viagensParaSincronizar) {
          if (v.statusSincronizacao == 'deletado') {
            await isar.viagemCollections.delete(v.id);
          } else {
            v.statusSincronizacao = 'sincronizado';
            await isar.viagemCollections.put(v);
          }
        }
        // Despesas
        for (var d in despesasParaSincronizar) {
          if (d.statusSincronizacao == 'deletado') {
            await isar.despesaCollections.delete(d.id);
          } else {
            d.statusSincronizacao = 'sincronizado';
            await isar.despesaCollections.put(d);
          }
        }
      });
      debugPrint('[SyncService] PushSync concluído e registros marcados como sincronizados.');
    } else {
      throw Exception('Falha no PushSync (Status ${response.statusCode}): ${response.body}');
    }
  }

  /// Baixa alterações recentes da nuvem para o banco local Isar
  Future<void> pullSync() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSyncStr = prefs.getString('last_pull_sync_date');
    
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
            
            // Helper para lidar com ambos os formatos de data: ISO e DD/MM/YYYY
            DateTime parseDate(String d) {
              if (d.contains('/')) {
                final parts = d.split(' ')[0].split('/');
                return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
              }
              return DateTime.parse(d).toLocal();
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

          if (despesa.id == Isar.autoIncrement || despesa.statusSincronizacao == 'sincronizado') {
            despesa.viagemId = dRaw['viagem_id'];
            despesa.tipo = dRaw['tipo'];
            despesa.valorTotal = (dRaw['valor_total'] as num).toDouble();
            
            // Helper para lidar com ambos os formatos de data: ISO e DD/MM/YYYY
            DateTime parseDate(String d) {
              if (d.contains('/')) {
                final parts = d.split(' ')[0].split('/');
                return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
              }
              return DateTime.parse(d).toLocal();
            }

            despesa.data = parseDate(dRaw['data']);
            despesa.local = dRaw['local'];
            despesa.descricao = dRaw['descricao'];
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
