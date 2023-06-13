import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/router/app_router.dart';
import 'package:flutter_application_1/services/app_service.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_translator/google_translator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatefulWidget {
  final SharedPreferences sharedPreferences;
  const MyApp({
    Key? key,
    required this.sharedPreferences,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppService appService;
  late AuthService authService;
  late StreamSubscription<bool> authSubscription;

  @override
  void initState() {
    appService = AppService(widget.sharedPreferences);
    authService = AuthService();
    authSubscription = authService.onAuthStateChange.listen(onAuthStateChange);
    super.initState();
  }

  void onAuthStateChange(bool login) {
    appService.loginState = login;
  }

  @override
  void dispose() {
    authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppService>(create: (_) => appService),
        Provider<AppRouter>(create: (_) => AppRouter(appService)),
        Provider<AuthService>(create: (_) => authService),
      ],
      child: Builder(
        builder: (context) {
          final GoRouter goRouter =
              Provider.of<AppRouter>(context, listen: false).router;
          return MaterialApp.router(
            title: "Router App",
            routeInformationParser: goRouter.routeInformationParser,
            routerDelegate: goRouter.routerDelegate,
          );
        },
      ),
    );
  }
}

class MyAppWithTranslator extends StatelessWidget {
  final String apiKey = "AIzaSyBVL91ezpUevF525yPS9xXmCVSxnz8VizA";

  @override
  Widget build(BuildContext context) {
    return Google_TranslatorInit(
      apiKey,
      translateFrom: Locale('pt-br'),
      translateTo: Locale('en'),
      builder: () => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Home_page(
          title: 'Página inicial de demonstração do Flutter',
        ),
      ),
    );
  }
}

class Home_page extends StatelessWidget {
  final String title;

  const Home_page({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title).translate(),
      ),
      body: Column(
        children: [
          Text("Meu texto traduzido").translate(),
          Text("Este texto mostra um placeholder diferente")
              .translate("Place to Holder"),
        ],
      ),
    );
  }
}
