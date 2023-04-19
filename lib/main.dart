import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:web_gofit/AppBloc/app_bloc.dart';
import 'package:web_gofit/LoginBloc/login_repository.dart';
import '../const.dart';
import 'routes.dart';

void main() {
  usePathUrlStrategy();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(loginRepository: LoginRepository()),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: colorScheme,
        ),
        routerConfig: router,
      ),
    );
  }
}
