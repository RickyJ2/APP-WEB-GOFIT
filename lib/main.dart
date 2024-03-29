import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../const.dart';

import 'Bloc/AppBloc/app_bloc.dart';
import 'Bloc/AppBloc/app_event.dart';
import 'Repository/informasi_umum_repository.dart';
import 'Repository/login_repository.dart';
import 'routes.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('id', null);
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
      create: (context) => AppBloc(
          loginRepository: LoginRepository(),
          informasiUmumRepository: InformasiUmumRepository()),
      child: const RouteApp(),
    );
  }
}

class RouteApp extends StatefulWidget {
  const RouteApp({super.key});

  @override
  State<RouteApp> createState() => _RouteAppState();
}

class _RouteAppState extends State<RouteApp> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AppBloc>(context).add(const AppOpened());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GoFit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
      ),
      routerConfig: router,
    );
  }
}
