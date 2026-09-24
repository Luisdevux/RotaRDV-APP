// lib/core/constants/app_constants.dart

// Constantes padronizadas do sistema
// Elimina strings mágicas espalhadas pelo código.
abstract class ViagemStatus {
  static const String emAndamento = 'em_andamento';
  static const String concluida = 'concluida';
  static const String cancelada = 'cancelada';
}

abstract class DespesaCategoria {
  static const String abastecimento = 'ABASTECIMENTO';
  static const String alimentacao = 'ALIMENTACAO';
  static const String manutencao = 'MANUTENCAO';
  static const String pedagio = 'PEDAGIO';
  static const String outros = 'OUTROS';

  static const List<String> todas = [
    abastecimento,
    alimentacao,
    manutencao,
    pedagio,
    outros,
  ];
}

abstract class SyncStatus {
  static const String criado = 'criado';
  static const String editado = 'editado';
  static const String sincronizado = 'sincronizado';
  static const String deletado = 'deletado';
}
