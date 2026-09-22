import 'package:app_despesas/core/theme/app_theme.dart';
import 'package:app_despesas/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'package:app_despesas/features/auth/auth_viewmodel.dart';
import 'package:app_despesas/features/home/home_viewmodel.dart';
import 'package:app_despesas/features/despesas/despesa_viewmodel.dart';
import 'package:app_despesas/core/database/local_database.dart';
import 'package:app_despesas/services/sync_service.dart';
import 'package:app_despesas/services/deep_link_service.dart';
import 'package:app_despesas/services/estado_cidade_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:app_despesas/routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDatabase.init();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Inicializa a formatação de datas em português (pt_BR)
  await initializeDateFormatting('pt_BR', null);

  // Pré-carrega o catálogo de cidades e estados offline do IBGE em memória
  EstadoCidadeService().loadEstadosECidades();

  // Inicializa o serviço de Deep Links
  await DeepLinkService.init(navigatorKey);

  // Inicializa o listener global de conectividade (auto-sync ao voltar a rede)
  SyncService().initConnectivityListener();

  final authViewModel = AuthViewModel();
  final isAuth = await authViewModel.checkAuth();

  runApp(MyApp(
    authViewModel: authViewModel,
    initialRoute: isAuth ? Routes.home : Routes.login,
  ));
}

class MyApp extends StatelessWidget {
  final AuthViewModel authViewModel;
  final String initialRoute;

  const MyApp({
    super.key, 
    required this.authViewModel,
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider.value(value: authViewModel),
        ChangeNotifierProvider(create: (_) => DespesaViewModel()),
        ChangeNotifierProxyProvider<AuthViewModel, HomeViewModel>(
          create: (context) => HomeViewModel(Provider.of<AuthViewModel>(context, listen: false)),
          update: (context, auth, previous) {
            previous ??= HomeViewModel(auth);
            previous.authViewModel = auth;
            return previous;
          },
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'RotaRDV',
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: initialRoute,
            routes: Routes.getRoutes(),
          );
        },
      ),
    );
  }
}
