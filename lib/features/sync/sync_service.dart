// lib/features/sync/sync_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../../core/database/local_database.dart';
import '../../models/viagem_collection.dart';
import '../../models/despesa_collection.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SyncService {
  Future<bool> hasPendingSync() async {
    final isar = LocalDatabase.isar;

    final viagensParaSincronizar = await isar.viagemCollections
        .filter()
        .statusSincronizacaoEqualTo('criado')
        .or()
        .statusSincronizacaoEqualTo('editado')
        .or()
        .statusSincronizacaoEqualTo('deletado')
        .count();

    final despesasParaSincronizar = await isar.despesaCollections
        .filter()
        .statusSincronizacaoEqualTo('criado')
        .or()
        .statusSincronizacaoEqualTo('editado')
        .or()
        .statusSincronizacaoEqualTo('deletado')
        .count();

    return viagensParaSincronizar > 0 || despesasParaSincronizar > 0;
  }

  Future<void> pushSync(String accessToken) async {
    final isar = LocalDatabase.isar;

    final viagensParaSincronizar = await isar.viagemCollections
        .filter()
        .statusSincronizacaoEqualTo('criado')
        .or()
        .statusSincronizacaoEqualTo('editado')
        .or()
        .statusSincronizacaoEqualTo('deletado')
        .findAll();

    final despesasParaSincronizar = await isar.despesaCollections
        .filter()
        .statusSincronizacaoEqualTo('criado')
        .or()
        .statusSincronizacaoEqualTo('editado')
        .or()
        .statusSincronizacaoEqualTo('deletado')
        .findAll();

    if (viagensParaSincronizar.isEmpty && despesasParaSincronizar.isEmpty) {
      return; 
    }

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

    final url = Uri.parse('${ApiConstants.baseUrl}/sync/push');
    
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
      body: jsonEncode(payload),
    );

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
    } else {
      throw Exception('Falha ao sincronizar dados: ${response.body}');
    }
  }

  Future<void> pullSync(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    final lastSyncStr = prefs.getString('last_pull_sync_date');
    
    String urlStr = '${ApiConstants.baseUrl}/sync/pull';
    if (lastSyncStr != null) {
      urlStr += '?updatedAfter=${Uri.encodeComponent(lastSyncStr)}';
    }

    final url = Uri.parse(urlStr);
    
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );

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

      // Salva o momento do sync (UTC)
      await prefs.setString('last_pull_sync_date', DateTime.now().toUtc().toIso8601String());
    } else {
      throw Exception('Falha ao puxar dados: ${response.body}');
    }
  }
}
