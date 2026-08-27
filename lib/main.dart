import 'package:app_despesas/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'package:app_despesas/features/auth/auth_viewmodel.dart';
import 'package:app_despesas/features/home/home_viewmodel.dart';
import 'package:app_despesas/core/database/local_database.dart';
import 'package:app_despesas/services/deep_link_service.dart';
import 'package:app_despesas/routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDatabase.init();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Inicializa o serviço de Deep Links
  await DeepLinkService.init(navigatorKey);

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
        ChangeNotifierProvider.value(value: authViewModel),
        ChangeNotifierProxyProvider<AuthViewModel, HomeViewModel>(
          create: (context) => HomeViewModel(Provider.of<AuthViewModel>(context, listen: false)),
          update: (context, auth, previous) {
            previous ??= HomeViewModel(auth);
            previous.authViewModel = auth;
            return previous;
          },
        ),
      ],
      child: MaterialApp(
        title: 'RotaRDV',
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: initialRoute,
        routes: Routes.getRoutes(),
      ),
    );
  }
}
