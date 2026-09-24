// lib/features/despesas/widgets/despesa_card.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../models/despesa_collection.dart';
import '../despesa_viewmodel.dart';

// Card representativo de uma despesa cadastrada, exibindo
// metadados de categoria, valor, data, posto e status de sincronização.
class DespesaCard extends StatelessWidget {
  final DespesaCollection despesa;
  final VoidCallback? onTap;

  const DespesaCard({
    super.key,
    required this.despesa,
    this.onTap,
  });

  String _formatCurrency(double val) {
    try {
      return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(val);
    } catch (_) {
      return 'R\$ ${val.toStringAsFixed(2)}';
    }
  }

  IconData _getIconForTipo(String tipo) {
    switch (tipo) {
      case 'ABASTECIMENTO':
        return LucideIcons.fuel;
      case 'ALIMENTACAO':
        return LucideIcons.utensils;
      case 'PEDAGIO':
        return LucideIcons.receipt;
      case 'MANUTENCAO':
        return LucideIcons.wrench;
      default:
        return LucideIcons.receipt;
    }
  }

  String _formatDate(DateTime dt) {
    try {
      return DateFormat('dd/MM/yyyy • HH:mm', 'pt_BR').format(dt.toLocal());
    } catch (_) {
      final localDt = dt.toLocal();
      final dia = localDt.day.toString().padLeft(2, '0');
      final mes = localDt.month.toString().padLeft(2, '0');
      final ano = localDt.year;
      final hora = localDt.hour.toString().padLeft(2, '0');
      final minuto = localDt.minute.toString().padLeft(2, '0');
      return '$dia/$mes/$ano • $hora:$minuto';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasLocalFoto = despesa.fotoAnexoLocalPath != null &&
        despesa.fotoAnexoLocalPath!.isNotEmpty &&
        File(despesa.fotoAnexoLocalPath!).existsSync();
    final hasRemoteFoto = despesa.fotoAnexoUrl != null && despesa.fotoAnexoUrl!.isNotEmpty;
    final hasFoto = hasLocalFoto || hasRemoteFoto;
    final temFotoPendente = hasLocalFoto && !hasRemoteFoto;
    final isTotalmenteSincronizado = despesa.statusSincronizacao == 'sincronizado' && !temFotoPendente;
    final isErroValidacao = despesa.statusSincronizacao == 'erro_validacao';

    final categoriaEnum = CategoriaDespesa.fromCodigo(despesa.tipo);
    final icon = _getIconForTipo(despesa.tipo);

    return AppCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      backgroundColor: colors.cardBackground,
      borderColor: colors.borderSubtle,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colors.primaryLight,
              borderRadius: AppRadius.mdRadius,
              border: Border.all(color: colors.primaryBorder),
            ),
            child: Icon(icon, color: colors.primary, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      categoriaEnum.label,
                      style: GoogleFonts.lexend(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      _formatCurrency(despesa.valorTotal),
                      style: GoogleFonts.lexend(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (despesa.local != null && despesa.local!.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(LucideIcons.mapPin, size: 13, color: colors.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          despesa.local!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lexend(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                ],
                if (despesa.descricao != null && despesa.descricao!.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(LucideIcons.fileText, size: 13, color: colors.textMuted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          despesa.descricao!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lexend(
                            fontSize: 12,
                            color: colors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                ],
                if (despesa.litros != null && despesa.litros! > 0 || despesa.kmAtual != null) ...[
                  const SizedBox(height: 2),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if (despesa.litros != null && despesa.litros! > 0)
                        Text(
                          '${despesa.litros!.toStringAsFixed(1)}L ${despesa.tipoCombustivel != null ? "• ${despesa.tipoCombustivel}" : ""}',
                          style: GoogleFonts.lexend(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: colors.textMuted,
                          ),
                        ),
                      if (despesa.valorLitro != null && despesa.valorLitro! > 0)
                        Text(
                          '(${_formatCurrency(despesa.valorLitro!)}/L)',
                          style: GoogleFonts.lexend(
                            fontSize: 12,
                            color: colors.textHint,
                          ),
                        ),
                      if (despesa.kmAtual != null && despesa.kmAtual! > 0)
                        Text(
                          'KM ${despesa.kmAtual!.toStringAsFixed(0)}',
                          style: GoogleFonts.lexend(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDate(despesa.data),
                      style: GoogleFonts.lexend(
                        fontSize: 11,
                        color: colors.textHint,
                      ),
                    ),
                    Row(
                      children: [
                        if (hasFoto) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colors.surfaceOverlay,
                              borderRadius: AppRadius.xsRadius,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  LucideIcons.paperclip,
                                  size: 11,
                                  color: colors.primary,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  'Foto',
                                  style: GoogleFonts.lexend(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: colors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        if (isErroValidacao) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colors.error.withValues(alpha: 0.12),
                              borderRadius: AppRadius.xsRadius,
                            ),
                            child: Text(
                              'Inconsistente',
                              style: GoogleFonts.lexend(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: colors.error,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        Icon(
                          isErroValidacao
                              ? LucideIcons.cloudAlert
                              : (isTotalmenteSincronizado ? LucideIcons.cloudCheck : LucideIcons.cloudUpload),
                          size: 14,
                          color: isErroValidacao
                              ? colors.error
                              : (isTotalmenteSincronizado ? colors.success : colors.warning),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
