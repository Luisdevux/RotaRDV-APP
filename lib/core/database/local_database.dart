// lib/core/database/local_database.dart

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/viagem_collection.dart';
import '../../models/despesa_collection.dart';

class LocalDatabase {
  static late Isar isar;

  static Future<void> init() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      isar = await Isar.open(
        [ViagemCollectionSchema, DespesaCollectionSchema],
        directory: dir.path,
        inspector: true,
      );
    } else {
      isar = Isar.getInstance()!;
    }
  }
}
