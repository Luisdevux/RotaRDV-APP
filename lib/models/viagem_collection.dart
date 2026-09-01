// lib/models/viagem_collection.dart

import 'package:isar/isar.dart';

part 'viagem_collection.g.dart';

@collection
class ViagemCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uuid;

  late String origemCidade;
  late String origemEstado;
  late String destinoCidade;
  late String destinoEstado;
  
  late double kmInicial;
  double? kmFinal;

  late DateTime dataInicio;
  DateTime? dataFim;

  late String status; // 'em_andamento', 'concluída'

  // Para controle Offline-First
  @Index()
  late String statusSincronizacao; // 'criado', 'editado', 'sincronizado'
}
