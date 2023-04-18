import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
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
  void initState() {
    super.initState();
    //FluoroRouter.defineRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
      ),
      routerConfig: router,
    );
  }
}
