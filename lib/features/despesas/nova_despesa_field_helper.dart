// lib/features/despesas/nova_despesa_field_helper.dart

import 'despesa_viewmodel.dart';

// Fornece títulos, rótulos e textos de ajuda dinâmicos conforme a categoria da despesa
abstract class NovaDespesaFieldHelper {
  // Retorna o título da página baseado na categoria selecionada
  static String obterTitulo(CategoriaDespesa? categoria) {
    if (categoria == null) return 'Lançar despesa';
    return 'Lançar ${categoria.label.toLowerCase()}';
  }

  // Retorna o rótulo descritivo do campo de local
  static String obterLabelLocal(CategoriaDespesa? categoria) {
    switch (categoria) {
      case CategoriaDespesa.abastecimento:
        return 'Posto de combustível';
      case CategoriaDespesa.alimentacao:
        return 'Restaurante ou lanchonete';
      case CategoriaDespesa.manutencao:
        return 'Oficina ou autopeças';
      case CategoriaDespesa.pedagio:
        return 'Praça de pedágio ou rodovia';
      case CategoriaDespesa.outros:
      default:
        return 'Local ou estabelecimento';
    }
  }

  // Retorna o texto de exemplo (hint) para o campo de local
  static String obterHintLocal(CategoriaDespesa? categoria) {
    switch (categoria) {
      case CategoriaDespesa.abastecimento:
        return 'Ex: Posto Ipiranga Rodo, Shell, Graal...';
      case CategoriaDespesa.alimentacao:
        return 'Ex: Restaurante do Gaúcho, Churrascaria...';
      case CategoriaDespesa.manutencao:
        return 'Ex: Oficina São Cristóvão, Mecânica Silva...';
      case CategoriaDespesa.pedagio:
        return 'Ex: Praça km 120 (CCR AutoBAn), ViaOeste...';
      case CategoriaDespesa.outros:
      default:
        return 'Ex: Estacionamento, Borracharia, Lava-jato...';
    }
  }

  // Retorna o texto de exemplo (hint) para as observações
  static String obterHintDescricao(CategoriaDespesa? categoria) {
    switch (categoria) {
      case CategoriaDespesa.abastecimento:
        return 'Ex: Tanque cheio, bico 3, aditivo Arla...';
      case CategoriaDespesa.alimentacao:
        return 'Ex: Almoço executivo, marmita, café...';
      case CategoriaDespesa.manutencao:
        return 'Ex: Troca de óleo, pastilhas, correia dentada...';
      case CategoriaDespesa.pedagio:
        return 'Ex: Tarifa de pedágio, eixo suspenso...';
      case CategoriaDespesa.outros:
      default:
        return 'Ex: Pernoite de estacionamento, taxa de descarga...';
    }
  }

  // Retorna a instrução de ajuda exibida abaixo do campo de valor
  static String obterHelperValor(CategoriaDespesa? categoria) {
    switch (categoria) {
      case CategoriaDespesa.abastecimento:
        return 'Digite o valor total pago no cupom fiscal do posto';
      case CategoriaDespesa.alimentacao:
        return 'Digite o valor total da refeição na nota fiscal';
      case CategoriaDespesa.manutencao:
        return 'Digite o valor total das peças e serviços';
      case CategoriaDespesa.pedagio:
        return 'Digite o valor da tarifa do comprovante de pedágio';
      case CategoriaDespesa.outros:
      default:
        return 'Digite o valor total pago no comprovante ou recibo';
    }
  }

  // Retorna a instrução do cabeçalho da seção de foto do comprovante
  static String obterLabelComprovante(CategoriaDespesa? categoria) {
    switch (categoria) {
      case CategoriaDespesa.abastecimento:
        return 'Foto do cupom fiscal do posto';
      case CategoriaDespesa.alimentacao:
        return 'Foto da comanda ou cupom fiscal';
      case CategoriaDespesa.manutencao:
        return 'Foto da ordem de serviço ou nota fiscal';
      case CategoriaDespesa.pedagio:
        return 'Foto do comprovante de pedágio';
      case CategoriaDespesa.outros:
      default:
        return 'Foto do comprovante ou recibo';
    }
  }
}
