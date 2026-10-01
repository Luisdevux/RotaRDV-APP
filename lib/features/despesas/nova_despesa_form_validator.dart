// lib/features/despesas/nova_despesa_form_validator.dart

import '../../models/viagem_collection.dart';
import 'despesa_viewmodel.dart';
import 'widgets/nova_despesa_seletor_combustivel.dart';

// Validações em tempo real e regras de liberação do formulário de nova despesa
abstract class NovaDespesaFormValidator {
  // Converte texto com formatação brasileira (vírgula e ponto) em número de ponto flutuante
  static double? parseNumero(String texto) {
    final limpo = texto.replaceAll('.', '').replaceAll(',', '.').trim();
    return double.tryParse(limpo);
  }

  // Valida o valor monetário total digitado
  static String? validarValorEmTempoReal({
    required double valorTotal,
    required String textoValor,
  }) {
    if (textoValor.isNotEmpty && valorTotal <= 0) {
      return 'O valor total deve ser maior que R\$ 0,00';
    }
    return null;
  }

  // Valida a quantidade de litros com base na capacidade do reservatório e limites de segurança
  static String? validarLitrosEmTempoReal({
    required CategoriaDespesa? categoria,
    required String textoLitros,
    required String tipoCombustivel,
    double? capacidadeTanque,
    double? capacidadeArla,
  }) {
    if (categoria != CategoriaDespesa.abastecimento) return null;
    if (textoLitros.isEmpty) return null;

    final litros = parseNumero(textoLitros);
    if (litros == null || litros <= 0) {
      return 'Litros devem ser maiores que zero';
    }

    if (tipoCombustivel == 'ARLA_32') {
      final limiteArla = (capacidadeArla != null && capacidadeArla > 0) ? capacidadeArla : 150.0;
      if (litros > limiteArla) {
        final capStr = limiteArla == limiteArla.toInt()
            ? limiteArla.toInt().toString()
            : limiteArla.toStringAsFixed(1).replaceAll('.', ',');
        return 'Excede a capacidade do Arla 32 ($capStr L)';
      }
    } else {
      if (capacidadeTanque != null && capacidadeTanque > 0 && litros > capacidadeTanque) {
        final capStr = capacidadeTanque == capacidadeTanque.toInt()
            ? capacidadeTanque.toInt().toString()
            : capacidadeTanque.toStringAsFixed(1).replaceAll('.', ',');
        return 'Excede a capacidade do tanque ($capStr L)';
      }
    }

    if (litros > 50000) {
      return 'Quantidade excede o limite (máx. 50.000 L)';
    }
    return null;
  }

  // Valida a quilometragem atual comparando com o odômetro de início da viagem
  static String? validarOdometroEmTempoReal({
    required CategoriaDespesa? categoria,
    required String textoKm,
    ViagemCollection? viagem,
  }) {
    if (categoria != CategoriaDespesa.abastecimento) return null;
    if (textoKm.isEmpty) return null;

    final km = parseNumero(textoKm);
    if (km == null || km <= 0) {
      return 'Informe uma quilometragem válida';
    }
    if (km > 10000000) {
      return 'Quilometragem inválida (limite excedido)';
    }
    if (viagem != null && km < viagem.kmInicial) {
      return 'KM (${km.toInt()}) não pode ser menor que o início (${viagem.kmInicial.toInt()} KM)';
    }
    return null;
  }

  // Verifica se todos os campos obrigatórios estão íntegros para liberar o botão de salvar
  static bool isFormularioValido({
    required CategoriaDespesa? categoria,
    required double valorTotal,
    required String textoLitros,
    required String textoKm,
    required String tipoCombustivel,
    ViagemCollection? viagem,
    double? capacidadeTanque,
    double? capacidadeArla,
    String? combustivelPreferencial,
  }) {
    if (valorTotal <= 0) return false;

    if (categoria == CategoriaDespesa.abastecimento) {
      final litros = parseNumero(textoLitros);
      if (litros == null || litros <= 0 || litros > 50000) return false;

      if (tipoCombustivel == 'ARLA_32') {
        final limiteArla = (capacidadeArla != null && capacidadeArla > 0) ? capacidadeArla : 150.0;
        if (litros > limiteArla) return false;
      } else {
        if (capacidadeTanque != null && capacidadeTanque > 0 && litros > capacidadeTanque) return false;
      }

      if (combustivelPreferencial != null) {
        final pref = combustivelPreferencial.toUpperCase();
        final isDiesel = pref == 'DIESEL_S10' || pref == 'DIESEL_S500';

        if (isDiesel) {
          if (tipoCombustivel != 'ARLA_32' && tipoCombustivel != pref) {
            return false;
          }
        } else {
          if (tipoCombustivel == 'DIESEL_S10' ||
              tipoCombustivel == 'DIESEL_S500' ||
              tipoCombustivel == 'ARLA_32') {
            return false;
          }
        }
      }

      final km = parseNumero(textoKm);
      if (km == null || km <= 0 || km > 10000000) return false;
      if (viagem != null && km < viagem.kmInicial) return false;
    }

    return true;
  }

  // Gera a mensagem descritiva de bloqueio quando os dados ainda não atendem aos critérios
  static String? obterMensagemBloqueio({
    required CategoriaDespesa? categoria,
    required double valorTotal,
    required String textoLitros,
    required String textoKm,
    required String tipoCombustivel,
    ViagemCollection? viagem,
    double? capacidadeTanque,
    double? capacidadeArla,
    String? combustivelPreferencial,
  }) {
    if (valorTotal <= 0) {
      return 'Informe o valor total da despesa para habilitar o salvamento.';
    }

    if (categoria == CategoriaDespesa.abastecimento) {
      final litros = parseNumero(textoLitros);
      if (litros == null || litros <= 0) {
        return 'Informe a quantidade de litros abastecidos.';
      }

      if (tipoCombustivel == 'ARLA_32') {
        final limiteArla = (capacidadeArla != null && capacidadeArla > 0) ? capacidadeArla : 150.0;
        if (litros > limiteArla) {
          final capStr = limiteArla == limiteArla.toInt()
              ? limiteArla.toInt().toString()
              : limiteArla.toStringAsFixed(1).replaceAll('.', ',');
          return 'A quantidade de Arla 32 excede a capacidade do reservatório ($capStr L).';
        }
      } else {
        if (capacidadeTanque != null && capacidadeTanque > 0 && litros > capacidadeTanque) {
          final capStr = capacidadeTanque == capacidadeTanque.toInt()
              ? capacidadeTanque.toInt().toString()
              : capacidadeTanque.toStringAsFixed(1).replaceAll('.', ',');
          return 'A quantidade de litros excede a capacidade máxima do tanque ($capStr L).';
        }
      }

      if (combustivelPreferencial != null) {
        final pref = combustivelPreferencial.toUpperCase();
        final isDiesel = pref == 'DIESEL_S10' || pref == 'DIESEL_S500';

        if (isDiesel) {
          if (tipoCombustivel != 'ARLA_32' && tipoCombustivel != pref) {
            final nomePref = NovaDespesaSeletorCombustivel.nomesCombustiveis[pref] ?? pref;
            return 'O veículo opera exclusivamente com $nomePref (+ Arla 32).';
          }
        } else {
          if (tipoCombustivel == 'DIESEL_S10' ||
              tipoCombustivel == 'DIESEL_S500' ||
              tipoCombustivel == 'ARLA_32') {
            return 'O combustível informado não é compatível com veículos não-diesel.';
          }
        }
      }

      if (litros > 50000) {
        return 'A quantidade de litros não pode ultrapassar 50.000 L.';
      }

      final km = parseNumero(textoKm);
      if (km == null || km <= 0) {
        return 'Informe a quilometragem atual do veículo.';
      }
      if (km > 10000000) {
        return 'A quilometragem informada ultrapassa o limite permitido.';
      }
      if (viagem != null && km < viagem.kmInicial) {
        return 'O odômetro (${km.toInt()} KM) é menor que o início da viagem (${viagem.kmInicial.toInt()} KM).';
      }
    }

    return null;
  }
}
