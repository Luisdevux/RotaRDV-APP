import '../../core/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/custom_refresh_indicator.dart';
import 'package:provider/provider.dart';
import 'home_viewmodel.dart';
import '../auth/auth_viewmodel.dart';
import '../sync/sync_service.dart';
import '../../routes.dart';
import '../../core/widgets/network_status_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Quando a tela carregar, pede para o ViewModel buscar os dados novos (ou vazios, se acabou de logar)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lê os dados do usuário logado
    final authVM = context.watch<AuthViewModel>();
    final user = authVM.currentUser;

    // Extrai o nome e se vier nulo tem o placeholder "Motorista"
    final userName = user?['nome'] ?? 'MOTORISTA';

    // Extrai a URL da foto do perfil
    final userPhotoUrl = user?['foto_perfil'];

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          children: [ 
            // Barra que verifica a conexão com a internet
            const NetworkStatusBar(),

            // Inicio do contudo da tela
            const SizedBox(height: 24),

            // Bloco de boas vindas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0), // Aqui define as margens laterais
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child:                      IconButton(                                                           
                        icon: const Icon(Icons.logout, color: AppColors.textHint),          
                        onPressed: () async {
                          // Confirmação prévia de saída
                          final bool? confirmarSaida = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Sair da conta'),
                              content: const Text('Deseja realmente encerrar sua sessão no aplicativo?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: const Text('Cancelar'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: const Text('Sair', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          );

                          if (confirmarSaida != true || !context.mounted) return;

                          // Inicializa o serviço de sincronização
                          final syncService = SyncService();

                          // Verifica se há dados locais pendentes de envio
                          final hasPending = await syncService.hasPendingSync();

                          if (hasPending) {
                            // Exibe feedback de sincronização em andamento
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                      ),
                                      SizedBox(width: 12),
                                      Text('Sincronizando dados antes de sair...'),
                                    ],
                                  ),
                                  duration: Duration(seconds: 4),
                                ),
                              );
                            }

                            // Tenta enviar as pendências para o servidor antes de deslogar
                            try {
                              await syncService.pushSync();
                            } catch (e) {
                              // Se falhar (offline, erro de rede ou API fora), BLOQUEIA O LOGOUT para proteger os dados locais
                              if (context.mounted) {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Não é possível sair agora'),
                                    content: const Text(
                                      'Você possui viagens ou despesas salvas apenas no celular que ainda não foram sincronizadas com o servidor.\n\nConecte-se à internet para sincronizá-las antes de sair para garantir que nada seja perdido!',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(ctx).pop(),
                                        child: const Text('Entendi'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return; // Trava estrita de segurança: NÃO desloga
                            }
                          }

                          // Se não tem pendências ou se o push subiu com 100% de sucesso, desloga:
                          await authVM.logout();
                          if (context.mounted) {
                            Navigator.of(context).pushReplacementNamed(Routes.login);
                          }
                        },                                                                  
                      ),
                  ),
                    
                  userPhotoUrl != null
                      ? ClipOval(
                          child: Image.network(
                            userPhotoUrl,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const CircleAvatar(
                                backgroundColor: AppColors.primary,
                                radius: 32,
                                child: Icon(Icons.person, color: Colors.white, size: 36),
                              );
                            },
                          ),
                        )
                      : const CircleAvatar(
                          backgroundColor: AppColors.primary,
                          radius: 32,
                          child: Icon(Icons.person, color: Colors.white, size: 36),
                        ),

                  const SizedBox(height: 16),

                  Text(
                      'OLÁ, ${userName.toUpperCase()}',
                      style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 4),

                  Builder(
                    builder: (context) {
                      final homeVM = context.watch<HomeViewModel>();
                      final temViagemAtiva = homeVM.ultimasViagens.any((v) => v.status == 'em_andamento');
                      if (temViagemAtiva) {
                        final ativa = homeVM.ultimasViagens.firstWhere((v) => v.status == 'em_andamento');
                        return Text(
                          'Em viagem: ${ativa.origemCidade} -> ${ativa.destinoCidade}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      return Text(
                        'Nenhuma viagem em andamento',
                        style: Theme.of(context).textTheme.bodyMedium,
                      );
                    }
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
              // Botão para iniciar uma nova viagem
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.novaViagem);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_shipping, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'INICIAR NOVA VIAGEM',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )
                    )
                  ]
                )
              )
            ),
            
            const SizedBox(height: 32),

            // Bloco de histórico de viagens
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.history, color: AppColors.primary, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'ÚLTIMAS VIAGENS',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Ver todas',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Expanded(
                      child: Builder(
                        builder: (context) {
                          // Lê a variável do HomeViewModel para verificar se está carregando ou se não tem viagens
                          final homeVM = context.watch<HomeViewModel>();

                          if (homeVM.isLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (homeVM.ultimasViagens.isEmpty) {
                            return const Center(
                              child: Text(
                                'Nenhuma viagem encontrada',
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          }

                          // Se tem viagem, desenha em uma lista
                          return CustomRefreshIndicator(
                            onRefresh: homeVM.refresh,
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: homeVM.ultimasViagens.length,
                              itemBuilder: (context, index) {
                                final viagem = homeVM.ultimasViagens[index];
  
                                // Formatar a data de forma mais amigável
                                final data = viagem.dataInicio;
                                final dataStr = '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
                                final isConcluida = viagem.status == 'concluída';
                                final isCancelada = viagem.status == 'cancelada';

                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.primary.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            dataStr,
                                            style: const TextStyle(
                                              color: AppColors.textHint,
                                              fontSize: 12,
                                            ),
                                          ),
                                          
                                          const SizedBox(height: 6),
                                          Wrap(
                                            crossAxisAlignment: WrapCrossAlignment.center,
                                            children: [
                                              Text(
                                                '${viagem.origemCidade} (${viagem.origemEstado})',
                                                style: const TextStyle(
                                                  color: AppColors.textPrimary,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 4.0),
                                                child: Icon(Icons.arrow_right_alt, color: AppColors.primary, size: 16),
                                              ),
                                              Text(
                                                '${viagem.destinoCidade} (${viagem.destinoEstado})',
                                                style: const TextStyle(
                                                  color: AppColors.textPrimary,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          isConcluida 
                                              ? Icons.check_circle 
                                              : (isCancelada ? Icons.cancel : Icons.local_shipping),
                                          color: isConcluida 
                                              ? AppColors.success 
                                              : (isCancelada ? AppColors.error : AppColors.warning),
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          (isConcluida 
                                              ? 'CONCLUÍDA' 
                                              : (isCancelada ? 'CANCELADA' : 'EM ANDAMENTO')).toUpperCase(),
                                          style: TextStyle(
                                            color: isConcluida 
                                                ? AppColors.success 
                                                : (isCancelada ? AppColors.error : AppColors.warning),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ]
                                    )
                                  ]
                                )
                              );
                            },
                          ));
                        }
                      )
                    )
                  ],
                )
              )
            )
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // A será adicionada a lógica de navegação
          debugPrint("Navegando para a aba: $index");
        },
      ),
    );
  }
}