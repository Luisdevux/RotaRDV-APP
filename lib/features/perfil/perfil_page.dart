// lib/features/perfil/perfil_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_dialog.dart';
import '../../core/widgets/network_status_bar.dart';
import '../../routes.dart';
import '../../services/sync_service.dart';
import '../auth/auth_viewmodel.dart';
import '../home/home_viewmodel.dart';
import 'widgets/perfil_motorista_card.dart';
import 'widgets/perfil_pendencias_modal.dart';
import 'widgets/perfil_preferencias_card.dart';
import 'widgets/perfil_sincronizacao_card.dart';
import 'widgets/perfil_veiculo_card.dart';

// Página responsável por gerenciar a identidade do motorista autenticado, os dados do veículo designado, preferências de interface e sincronização de dados
class PerfilPage extends StatefulWidget {
  final bool isTab;
  final ValueChanged<int>? onNavigateToTab;

  const PerfilPage({
    super.key,
    this.isTab = false,
    this.onNavigateToTab,
  });

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final authVM = context.read<AuthViewModel>();
        authVM.reloadUserFromStorage();
        authVM.fetchProfile();
      }
    });
  }

  /*──────────────────────────────────────────────────────────────*/
  /* MÉTODOS DE CONTROLE E SINCRONIZAÇÃO                          */
  /*──────────────────────────────────────────────────────────────*/

  Future<void> _forcarSincronizacao() async {
    setState(() {
      _isSyncing = true;
    });

    final syncService = SyncService();
    await syncService.syncAll();
    final summary = await syncService.getPendingSyncSummary();

    if (mounted) {
      context.read<HomeViewModel>().init();
      setState(() {
        _isSyncing = false;
      });

      if (!summary.hasPending) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(LucideIcons.checkCircle2, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text('Todos os dados e comprovantes estão sincronizados!'),
                ),
              ],
            ),
            backgroundColor: context.colors.success,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(LucideIcons.alertTriangle, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    summary.fotosPendentes > 0
                        ? 'Dados enviados, mas ${summary.fotosPendentes} foto(s) de comprovante aguardam o servidor de anexos.'
                        : 'Sincronização parcial. ${summary.totalPendencias} item(ns) pendente(s).',
                  ),
                ),
              ],
            ),
            backgroundColor: context.colors.warning,
          ),
        );
      }
    }
  }

  Future<void> _handleLogout(
    BuildContext context,
    AuthViewModel authVM,
    AppColorsExtension colors,
  ) async {
    final syncService = SyncService();
    final pending = await syncService.getPendingSyncSummary();

    if (!context.mounted) return;

    if (pending.hasPending) {
      await PerfilPendenciasModal.show(
        context,
        authVM: authVM,
        colors: colors,
        pending: pending,
        onLogout: (clearDb) => _efetuarLogout(context, authVM, clearDatabase: clearDb),
      );
    } else {
      final bool? confirmar = await AppDialog.show(
        context: context,
        title: 'Sair da conta',
        message: 'Todos os seus dados e comprovantes estão salvos na nuvem. Deseja realmente encerrar a sessão?',
        confirmText: 'Sair',
        cancelText: 'Cancelar',
        isDestructive: true,
        icon: LucideIcons.logOut,
      );

      if (confirmar == true && context.mounted) {
        await _efetuarLogout(context, authVM, clearDatabase: true);
      }
    }
  }

  Future<void> _efetuarLogout(BuildContext context, AuthViewModel authVM, {bool clearDatabase = false}) async {
    await authVM.logout(clearDatabase: clearDatabase);
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        Routes.login,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final authVM = context.watch<AuthViewModel>();
    final homeVM = context.watch<HomeViewModel>();

    final user = authVM.currentUser;
    final veiculo = homeVM.veiculo;

    final userName = user?['nome'] ?? 'Motorista';
    final userEmail = user?['email'] ?? 'motorista@empresa.com';
    final userCpf = user?['cpf'] as String?;
    final userCnh = user?['cnh'] as String?;
    final userTelefone = user?['telefone'] as String?;
    final empresaNome = user?['empresa']?['nome'] as String?;
    final empresaCargo = user?['empresa']?['cargo'] as String?;
    final userPhotoUrl = user?['foto_perfil'] as String?;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.headerBackground,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: colors.primary),
          onPressed: () {
            if (widget.isTab && widget.onNavigateToTab != null) {
              widget.onNavigateToTab!(0);
            } else if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          'Meu perfil',
          style: GoogleFonts.lexend(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const NetworkStatusBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PerfilMotoristaCard(
                      userName: userName,
                      userEmail: userEmail,
                      userPhotoUrl: userPhotoUrl,
                      userCpf: userCpf,
                      userCnh: userCnh,
                      userTelefone: userTelefone,
                      empresaNome: empresaNome,
                      empresaCargo: empresaCargo,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    PerfilVeiculoCard(veiculo: veiculo),
                    const SizedBox(height: AppSpacing.md),

                    const PerfilPreferenciasCard(),
                    const SizedBox(height: AppSpacing.md),

                    PerfilSincronizacaoCard(
                      isSyncing: _isSyncing,
                      onSincronizar: _forcarSincronizacao,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Botão de Encerramento de Sessão
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () => _handleLogout(context, authVM, colors),
                        icon: Icon(LucideIcons.logOut, size: 18, color: colors.error),
                        label: Text(
                          'Encerrar sessão',
                          style: GoogleFonts.lexend(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: colors.error,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colors.error,
                          side: BorderSide(color: colors.error.withValues(alpha: 0.4)),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.mdRadius,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
