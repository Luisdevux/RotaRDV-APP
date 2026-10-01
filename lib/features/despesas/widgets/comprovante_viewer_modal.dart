import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:isar/isar.dart';
import '../../../core/database/local_database.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../models/despesa_collection.dart';
import '../../../services/sync_service.dart';
import '../despesa_viewmodel.dart';

// Bottom Sheet modal que exibe a auditoria completa de um lançamento financeiro, foto do comprovante com zoom, dados fiscais e opção de exclusão offline-first
class ComprovanteViewerModal extends StatefulWidget {
  final DespesaCollection despesa;

  const ComprovanteViewerModal({
    super.key,
    required this.despesa,
  });

  static void show(
    BuildContext context, {
    required DespesaCollection despesa,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ComprovanteViewerModal(
        despesa: despesa,
      ),
    );
  }

  @override
  State<ComprovanteViewerModal> createState() => _ComprovanteViewerModalState();
}

class _ComprovanteViewerModalState extends State<ComprovanteViewerModal> {
  String? _fotoLocalPath;

  @override
  void initState() {
    super.initState();
    _fotoLocalPath = widget.despesa.fotoAnexoLocalPath;
    _verificarOuRecuperarFoto();
  }

  Future<void> _verificarOuRecuperarFoto() async {
    final pathValido = _fotoLocalPath != null &&
        _fotoLocalPath!.isNotEmpty &&
        await File(_fotoLocalPath!).exists();

    if (!pathValido && (widget.despesa.fotoAnexoUrl == null || widget.despesa.fotoAnexoUrl!.isEmpty)) {
      final recuperado = await resolverOuRecuperarFotoLocal(
        widget.despesa.uuid,
        _fotoLocalPath,
      );
      if (recuperado != null && mounted) {
        setState(() {
          _fotoLocalPath = recuperado;
        });
        try {
          final isar = LocalDatabase.isar;
          final d = await isar.despesaCollections.filter().uuidEqualTo(widget.despesa.uuid).findFirst();
          if (d != null) {
            d.fotoAnexoLocalPath = recuperado;
            await isar.writeTxn(() async {
              await isar.despesaCollections.put(d);
            });
          }
        } catch (e) {
          debugPrint('[ComprovanteViewerModal] Erro ao persistir path recuperado: $e');
        }
      }
    }
  }

  String _formatCurrency(double val) {
    try {
      return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(val);
    } catch (_) {
      return 'R\$ ${val.toStringAsFixed(2)}';
    }
  }

  String _formatKm(num val) {
    try {
      return NumberFormat('#,###', 'pt_BR').format(val);
    } catch (_) {
      return val.toStringAsFixed(0);
    }
  }

  String _formatLitros(double val) {
    try {
      return NumberFormat('#,##0.00', 'pt_BR').format(val);
    } catch (_) {
      return val.toStringAsFixed(2);
    }
  }

  String _formatDate(DateTime dt) {
    final localDt = dt.toLocal();
    try {
      return DateFormat("dd/MM/yyyy 'às' HH:mm", 'pt_BR').format(localDt);
    } catch (_) {
      final dia = localDt.day.toString().padLeft(2, '0');
      final mes = localDt.month.toString().padLeft(2, '0');
      final ano = localDt.year;
      final hora = localDt.hour.toString().padLeft(2, '0');
      final minuto = localDt.minute.toString().padLeft(2, '0');
      return '$dia/$mes/$ano às $hora:$minuto';
    }
  }


  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cat = CategoriaDespesa.fromCodigo(widget.despesa.tipo);

    final hasLocalFoto = _fotoLocalPath != null &&
        _fotoLocalPath!.isNotEmpty &&
        File(_fotoLocalPath!).existsSync();
    final hasRemoteFoto = widget.despesa.fotoAnexoUrl != null &&
        widget.despesa.fotoAnexoUrl!.isNotEmpty;
    final temFotoPendente = hasLocalFoto && !hasRemoteFoto;
    final isSincronizado = widget.despesa.statusSincronizacao == 'sincronizado' && !temFotoPendente;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
          border: Border(top: BorderSide(color: colors.border, width: 1)),
        ),
        child: Column(
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: AppRadius.xsRadius,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(LucideIcons.receipt, color: colors.primary, size: 22),
                      const SizedBox(width: AppSpacing.md),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cat.label,
                            style: GoogleFonts.lexend(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                            ),
                          ),
                          Text(
                            _formatDate(widget.despesa.data),
                            style: GoogleFonts.lexend(
                              fontSize: 12,
                              color: colors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(LucideIcons.x, color: colors.textMuted),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(AppSpacing.xl),
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Valor total',
                          style: GoogleFonts.lexend(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: colors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatCurrency(widget.despesa.valorTotal),
                          style: GoogleFonts.lexend(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppCard(
                    backgroundColor: colors.surfaceOverlay,
                    borderColor: colors.borderSubtle,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          colors: colors,
                          icon: LucideIcons.tag,
                          label: 'Categoria',
                          value: cat.label,
                        ),
                        if (widget.despesa.local != null && widget.despesa.local!.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.md),
                          _buildInfoRow(
                            colors: colors,
                            icon: LucideIcons.mapPin,
                            label: 'Local / Estabelecimento',
                            value: widget.despesa.local!,
                          ),
                        ],
                        if (widget.despesa.tipoCombustivel != null) ...[
                          const SizedBox(height: AppSpacing.md),
                          _buildInfoRow(
                            colors: colors,
                            icon: LucideIcons.fuel,
                            label: 'Combustível',
                            value: widget.despesa.tipoCombustivel!,
                          ),
                        ],
                        if (widget.despesa.litros != null && widget.despesa.litros! > 0) ...[
                          const SizedBox(height: AppSpacing.md),
                          _buildInfoRow(
                            colors: colors,
                            icon: LucideIcons.droplet,
                            label: 'Litros',
                            value: '${_formatLitros(widget.despesa.litros!)} L',
                          ),
                        ],
                        if (widget.despesa.valorLitro != null && widget.despesa.valorLitro! > 0) ...[
                          const SizedBox(height: AppSpacing.md),
                          _buildInfoRow(
                            colors: colors,
                            icon: LucideIcons.circleDollarSign,
                            label: 'Preço por Litro',
                            value: _formatCurrency(widget.despesa.valorLitro!),
                          ),
                        ],
                        if (widget.despesa.kmAtual != null) ...[
                          const SizedBox(height: AppSpacing.md),
                          _buildInfoRow(
                            colors: colors,
                            icon: LucideIcons.gauge,
                            label: 'Odômetro Registrado',
                            value: '${_formatKm(widget.despesa.kmAtual!)} KM',
                          ),
                        ],
                        if (widget.despesa.descricao != null && widget.despesa.descricao!.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.md),
                          _buildInfoRow(
                            colors: colors,
                            icon: LucideIcons.fileText,
                            label: 'Observações',
                            value: widget.despesa.descricao!,
                          ),
                        ],
                        const SizedBox(height: AppSpacing.md),
                        _buildInfoRow(
                          colors: colors,
                          icon: isSincronizado ? LucideIcons.cloudCheck : LucideIcons.cloudUpload,
                          iconColor: isSincronizado ? colors.success : colors.warning,
                          label: 'Sincronização',
                          value: isSincronizado ? 'Sincronizado na Nuvem' : 'Pendente de Envio',
                          valueColor: isSincronizado ? colors.success : colors.warning,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Comprovante Fiscal',
                    style: GoogleFonts.lexend(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (hasLocalFoto)
                    ClipRRect(
                      borderRadius: AppRadius.lgRadius,
                      child: InteractiveViewer(
                        maxScale: 4.0,
                        child: Image.file(
                          File(_fotoLocalPath!),
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  else if (hasRemoteFoto)
                    ClipRRect(
                      borderRadius: AppRadius.lgRadius,
                      child: InteractiveViewer(
                        maxScale: 4.0,
                        child: Image.network(
                          widget.despesa.fotoAnexoUrl!,
                          fit: BoxFit.contain,
                          loadingBuilder: (_, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              height: 200,
                              color: colors.surfaceOverlay,
                              child: const Center(child: CircularProgressIndicator()),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 120,
                            color: colors.surfaceOverlay,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(LucideIcons.imageOff, color: colors.textHint, size: 28),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Erro ao carregar imagem remota',
                                    style: GoogleFonts.lexend(fontSize: 12, color: colors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: colors.surfaceOverlay,
                        borderRadius: AppRadius.lgRadius,
                        border: Border.all(color: colors.borderSubtle),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(LucideIcons.fileX, size: 36, color: colors.textHint),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Nenhum comprovante anexado',
                              style: GoogleFonts.lexend(
                                fontSize: 13,
                                color: colors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required AppColorsExtension colors,
    required IconData icon,
    required String label,
    required String value,
    Color? iconColor,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 15, color: iconColor ?? colors.textMuted),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.lexend(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: colors.textMuted,
              ),
            ),
          ],
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GoogleFonts.lexend(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: valueColor ?? colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
