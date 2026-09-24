// lib/features/perfil/widgets/perfil_veiculo_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';

// Componente modular que apresenta a ficha técnica do veículo atribuído pela transportadora ao motorista, incluindo conjunto tracionador e reboque
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

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final veiculo = widget.veiculo;
    final summaryText = veiculo != null
        ? '${veiculo['modelo'] ?? 'Caminhão'} • ${veiculo['placa'] ?? 'Placa N/D'}'
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
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.10),
                        borderRadius: AppRadius.smRadius,
                      ),
                      child: Icon(LucideIcons.truck, size: 18, color: colors.primary),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Veículo designado',
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
                            'O veículo designado pela transportadora aparecerá aqui.',
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
