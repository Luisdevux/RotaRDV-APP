import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import '../core/database/local_database.dart';
import '../models/despesa_collection.dart';
import '../models/viagem_collection.dart';

class StorageCleanerService {
  static final StorageCleanerService _instance = StorageCleanerService._internal();
  factory StorageCleanerService() => _instance;
  StorageCleanerService._internal();

  /// Executa o expurgo de fotos de comprovantes locais no celular:
  /// - Apenas de viagens concluídas há mais de 15 dias.
  /// - Apenas de despesas já 100% sincronizadas com backup na nuvem (fotoAnexoUrl preenchida).
  /// - Apenas de fotos tiradas de DENTRO do app pela câmera (fotoTiradaNoApp == true).
  /// - NUNCA apaga fotos selecionadas da galeria pessoal do motorista.
  Future<int> purgeOldSyncedPhotos() async {
    try {
      final isar = LocalDatabase.isar;
      final limite15Dias = DateTime.now().subtract(const Duration(days: 15));

      // Busca viagens concluídas finalizadas há mais de 15 dias
      final viagensAntigas = await isar.viagemCollections
          .filter()
          .group((q) => q.statusEqualTo('concluida').or().statusEqualTo('concluída'))
          .and()
          .dataFimLessThan(limite15Dias)
          .findAll();

      if (viagensAntigas.isEmpty) {
        return 0;
      }

      int totalExpurgado = 0;

      for (var viagem in viagensAntigas) {
        final despesas = await isar.despesaCollections
            .filter()
            .viagemIdEqualTo(viagem.uuid)
            .and()
            .statusSincronizacaoEqualTo('sincronizado')
            .and()
            .fotoTiradaNoAppEqualTo(true)
            .findAll();

        for (var despesa in despesas) {
          // Garante que só apaga localmente se já tiver a URL definitiva na nuvem
          if (despesa.fotoAnexoUrl != null &&
              despesa.fotoAnexoUrl!.isNotEmpty &&
              despesa.fotoAnexoLocalPath != null) {
            final file = File(despesa.fotoAnexoLocalPath!);
            if (await file.exists()) {
              await file.delete();
              debugPrint('[StorageCleaner] Foto interna expurgada com sucesso: ${file.path} (Viagem finalizada em ${viagem.dataFim})');
            }

            await isar.writeTxn(() async {
              despesa.fotoAnexoLocalPath = null;
              await isar.despesaCollections.put(despesa);
            });

            totalExpurgado++;
          }
        }
      }

      if (totalExpurgado > 0) {
        debugPrint('[StorageCleaner] Limpeza concluída: $totalExpurgado fotos antigas expurgadas do celular.');
      }

      return totalExpurgado;
    } catch (e) {
      debugPrint('[StorageCleaner] Erro durante o expurgo de fotos antigas: $e');
      return 0;
    }
  }
}
