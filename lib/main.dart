import 'package:app_despesas/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'package:app_despesas/features/auth/auth_viewmodel.dart';
import 'package:app_despesas/features/home/home_viewmodel.dart';
import 'package:app_despesas/core/database/local_database.dart';
import 'package:app_despesas/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDatabase.init();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
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
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: Routes.login,
        routes: Routes.getRoutes(),
      ),
    );
  }
}
