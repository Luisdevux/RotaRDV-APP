// lib/core/utils/odometer_validator.dart

import 'package:intl/intl.dart';

// Validações e formatação unificadas de odômetro para abertura de viagem, encerramento e abastecimentos
abstract class OdometerValidator {
  // Limite físico máximo aceito pelo domínio para odômetros (10 milhões de KM)
  static const double maxOdometroKm = 10000000;

  // Diferença acima da qual o app exige confirmação explícita por possível erro de digitação
  static const double limiteDiscrepanciaKm = 10000;

  // Quantidade máxima de dígitos no campo (permite digitar > 10.000.000 para exibir o aviso de limite sem estourar o layout)
  static const int maxOdometroDigits = 9;

  // Converte texto formatado (ex: "653.218") em double finito, ou null se inválido
  static double? parseNumero(String texto) {
    final limpo = texto.replaceAll('.', '').replaceAll(',', '.').trim();
    if (limpo.isEmpty) return null;
    final parsed = double.tryParse(limpo);
    if (parsed == null || !parsed.isFinite) return null;
    return parsed;
  }

  // Formata valor numérico de quilometragem no padrão pt-BR com separador de milhar
  static String formatKm(num val) {
    if (!val.isFinite) return '0';
    try {
      return NumberFormat('#,###', 'pt_BR').format(val);
    } catch (_) {
      return val.toStringAsFixed(0);
    }
  }

  // Valida o odômetro inicial na abertura de nova viagem
  static String? validarKmInicial({
    required String textoKm,
    double? ultimaKmConhecida,
  }) {
    final trim = textoKm.trim();
    if (trim.isEmpty) return null;

    final km = parseNumero(trim);
    if (km == null || km <= 0) {
      return 'Informe uma quilometragem inicial maior que zero';
    }
    if (km > maxOdometroKm) {
      return 'Quilometragem inválida (limite excedido — máx. ${formatKm(maxOdometroKm)} KM)';
    }
    if (ultimaKmConhecida != null && km < ultimaKmConhecida) {
      return 'KM (${formatKm(km.toInt())}) não pode ser menor que o da última viagem (${formatKm(ultimaKmConhecida.toInt())} KM)';
    }
    return null;
  }

  // Valida o odômetro final na tela de encerramento de viagem
  static ({String? mensagemErro, String? subtituloCurto}) validarKmFinal({
    required String textoKm,
    required double kmInicial,
    double? ultimoKmAbastecimento,
  }) {
    final trim = textoKm.trim();
    if (trim.isEmpty) {
      return (mensagemErro: null, subtituloCurto: null);
    }

    final km = parseNumero(trim);
    if (km == null || km <= 0) {
      return (
        mensagemErro: 'Informe uma quilometragem final maior que zero',
        subtituloCurto: 'Valor inválido',
      );
    }
    if (km > maxOdometroKm) {
      return (
        mensagemErro: 'Quilometragem inválida (limite excedido — máx. ${formatKm(maxOdometroKm)} KM)',
        subtituloCurto: 'Limite excedido',
      );
    }
    if (km <= kmInicial) {
      return (
        mensagemErro: 'O KM final deve ser maior que o KM inicial (${formatKm(kmInicial)} KM)',
        subtituloCurto: km == kmInicial ? 'Igual ao inicial' : 'Menor que o inicial',
      );
    }
    if (ultimoKmAbastecimento != null && km < ultimoKmAbastecimento) {
      return (
        mensagemErro: 'O KM final não pode ser menor que o último abastecimento (${formatKm(ultimoKmAbastecimento)} KM)',
        subtituloCurto: 'Menor que último abastec.',
      );
    }

    return (mensagemErro: null, subtituloCurto: null);
  }

  // Verifica se houve salto incomum (> 10.000 KM) em relação ao odômetro de referência
  static bool isSaltoDiscrepante({
    required double kmInformado,
    required double kmReferencia,
  }) {
    return (kmInformado - kmReferencia) > limiteDiscrepanciaKm;
  }
}
