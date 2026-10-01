// lib/features/perfil/widgets/perfil_veiculo_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';

// Componente modular que apresenta a ficha técnica do veículo atribuído pela transportadora ao motorista, incluindo conjunto tracionador, capacidade do tanque e reboque
class PerfilVeiculoCard extends StatefulWidget {
  final Map<String, dynamic>? veiculo;

  const PerfilVeiculoCard({
    super.key,
    required this.veiculo,
  });

  @override
  State<PerfilVeiculoCard> createState() => _PerfilVeiculoCardState();
}

class _PerfilVeiculoCardState extends State<PerfilVeiculoCard> {
  bool _isExpanded = false;

  String? _formatarCapacidadeTanque(dynamic capacidade) {
    if (capacidade == null) return null;
    final numVal = double.tryParse(capacidade.toString());
    if (numVal == null || numVal <= 0) return null;
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: '',
      decimalDigits: numVal == numVal.toInt() ? 0 : 1,
    );
    return '${formatter.format(numVal).trim()} L';
  }

  String? _formatarCombustivel(dynamic combustivel) {
    if (combustivel == null) return null;
    switch (combustivel.toString().toUpperCase()) {
      case 'DIESEL_S10':
        return 'Diesel S10';
      case 'DIESEL_S500':
        return 'Diesel S500';
      case 'ARLA_32':
        return 'Arla 32';
      case 'GASOLINA':
        return 'Gasolina';
      case 'ETANOL':
        return 'Etanol';
      default:
        return combustivel.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final veiculo = widget.veiculo;
    final capStr = _formatarCapacidadeTanque(veiculo?['capacidade_tanque']);
    final capArlaStr = _formatarCapacidadeTanque(veiculo?['capacidade_arla']);
    final summaryText = veiculo != null
        ? '${veiculo['modelo'] ?? 'Caminhão'} • ${veiculo['placa'] ?? 'Placa N/D'}${capStr != null ? ' • Tanque $capStr' : ''}${capArlaStr != null ? ' • Arla $capArlaStr' : ''}'
        : 'Nenhum veículo vinculado';

    return AppCard(
      backgroundColor: colors.cardBackground,
      borderColor: colors.borderSubtle,
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: AppRadius.mdRadius,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Icon(LucideIcons.truck, size: 20, color: colors.primary),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Veículo vínculado',
                            style: GoogleFonts.lexend(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            summaryText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.lexend(
                              fontSize: 12,
                              color: colors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: Icon(
                        LucideIcons.chevronDown,
                        size: 20,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity),
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(height: 1, color: colors.borderSubtle),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (veiculo != null) ...[
                          Text(
                            veiculo['modelo'] ?? 'Caminhão',
                            style: GoogleFonts.lexend(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Placa: ${veiculo['placa'] ?? 'N/A'}${veiculo['tipo'] != null ? ' • ${veiculo['tipo']}' : ''}',
                            style: GoogleFonts.lexend(
                              fontSize: 13,
                              color: colors.textSecondary,
                            ),
                          ),
                          if (capStr != null || capArlaStr != null || veiculo['combustivel_preferencial'] != null) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: AppSpacing.sm,
                              runSpacing: AppSpacing.xs,
                              children: [
                                if (capStr != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: colors.primary.withValues(alpha: 0.1),
                                      borderRadius: AppRadius.smRadius,
                                      border: Border.all(color: colors.primary.withValues(alpha: 0.25)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(LucideIcons.fuel, size: 14, color: colors.primary),
                                        const SizedBox(width: 5),
                                        Text(
                                          'Tanque: $capStr',
                                          style: GoogleFonts.lexend(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: colors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (capArlaStr != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: colors.primaryFaint,
                                      borderRadius: AppRadius.smRadius,
                                      border: Border.all(color: colors.primaryBorder),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(LucideIcons.droplet, size: 14, color: colors.primary),
                                        const SizedBox(width: 5),
                                        Text(
                                          'Arla 32: $capArlaStr',
                                          style: GoogleFonts.lexend(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: colors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (veiculo['combustivel_preferencial'] != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: colors.inputBackground,
                                      borderRadius: AppRadius.smRadius,
                                      border: Border.all(color: colors.borderSubtle),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(LucideIcons.droplet, size: 14, color: colors.textSecondary),
                                        const SizedBox(width: 5),
                                        Text(
                                          _formatarCombustivel(veiculo['combustivel_preferencial'])!,
                                          style: GoogleFonts.lexend(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: colors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                          if (veiculo['reboque'] is Map &&
                              veiculo['reboque']['modelo'] != null &&
                              veiculo['reboque']['modelo'].toString().isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(AppSpacing.sm),
                              decoration: BoxDecoration(
                                color: colors.inputBackground,
                                borderRadius: AppRadius.smRadius,
                                border: Border.all(color: colors.borderSubtle),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reboque: ${veiculo['reboque']['modelo']}',
                                    style: GoogleFonts.lexend(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                  if (veiculo['reboque']['placas'] is List &&
                                      (veiculo['reboque']['placas'] as List).isNotEmpty)
                                    Text(
                                      'Placas: ${(veiculo['reboque']['placas'] as List).join(' • ')}',
                                      style: GoogleFonts.lexend(
                                        fontSize: 11,
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ] else ...[
                          Text(
                            'Nenhum veículo vinculado',
                            style: GoogleFonts.lexend(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'O veículo vínculado pela transportadora aparecerá aqui.',
                            style: GoogleFonts.lexend(
                              fontSize: 12,
                              color: colors.textMuted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),
          ],
        ),
      ),
    );
  }
}
