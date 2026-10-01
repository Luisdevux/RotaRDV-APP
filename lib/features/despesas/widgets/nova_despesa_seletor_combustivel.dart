// lib/features/despesas/widgets/nova_despesa_seletor_combustivel.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';

// Seletor de combustível com identificação do veículo (diesel ou flex) e restrições de segurança
class NovaDespesaSeletorCombustivel extends StatelessWidget {
  final String tipoCombustivel;
  final String? combustivelPreferencial;
  final ValueChanged<String> onChanged;

  const NovaDespesaSeletorCombustivel({
    super.key,
    required this.tipoCombustivel,
    required this.combustivelPreferencial,
    required this.onChanged,
  });

  // Mapeamento de rótulos amigáveis para exibição
  static const Map<String, String> nomesCombustiveis = {
    'DIESEL_S10': 'Diesel S10',
    'DIESEL_S500': 'Diesel S500',
    'ARLA_32': 'Arla 32',
    'GASOLINA': 'Gasolina',
    'ETANOL': 'Etanol',
    'OUTRO': 'Outro',
  };

  // Retorna as opções permitidas conforme a motorização do veículo
  static List<String> obterOpcoesCombustivel(String? combustivelPreferencial) {
    if (combustivelPreferencial != null) {
      final pref = combustivelPreferencial.toUpperCase();
      if (pref == 'DIESEL_S10') {
        return const ['DIESEL_S10', 'ARLA_32'];
      }
      if (pref == 'DIESEL_S500') {
        return const ['DIESEL_S500', 'ARLA_32'];
      }
    }
    // Veículos não-diesel (carros de apoio, utilitários flex, etc.)
    return const ['GASOLINA', 'ETANOL', 'OUTRO'];
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final opcoes = obterOpcoesCombustivel(combustivelPreferencial);
    final valorAtual = opcoes.contains(tipoCombustivel) ? tipoCombustivel : opcoes.first;

    final String nomePreferencial = nomesCombustiveis[combustivelPreferencial] ?? combustivelPreferencial ?? '';
    final bool isDiesel = combustivelPreferencial == 'DIESEL_S10' || combustivelPreferencial == 'DIESEL_S500';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(LucideIcons.fuel, color: colors.primary, size: 18),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Tipo de combustível',
              style: GoogleFonts.lexend(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colors.textSecondary,
              ),
            ),
            if (combustivelPreferencial != null) ...[
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.12),
                  borderRadius: AppRadius.smRadius,
                ),
                child: Text(
                  isDiesel ? 'Cadastrado: $nomePreferencial' : 'Carro / Leve (Flex)',
                  style: GoogleFonts.lexend(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colors.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 2),
          decoration: BoxDecoration(
            color: colors.inputBackground,
            borderRadius: AppRadius.lgRadius,
            border: Border.all(color: colors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: valorAtual,
              isExpanded: true,
              dropdownColor: colors.cardBackground,
              style: GoogleFonts.lexend(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
              icon: Icon(LucideIcons.chevronDown, color: colors.textMuted),
              items: opcoes.map((opc) {
                final label = nomesCombustiveis[opc] ?? opc;
                return DropdownMenuItem<String>(
                  value: opc,
                  child: Text(label),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  onChanged(val);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
