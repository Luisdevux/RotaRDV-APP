// lib/models/despesa_collection.dart

import 'package:isar/isar.dart';

part 'despesa_collection.g.dart';

@collection
class DespesaCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uuid;

  @Index()
  late String viagemId;

  late String tipo; // ABASTECIMENTO, ALIMENTACAO...
  late double valorTotal;
  late DateTime data;
  
  String? local;
  String? descricao;
  String? fotoAnexoLocalPath;

  // Para controle Offline-First
  @Index()
  late String statusSincronizacao; // 'criado', 'editado', 'sincronizado'
}
