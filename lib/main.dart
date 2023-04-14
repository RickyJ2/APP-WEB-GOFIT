import 'package:flutter/material.dart';
import 'Page/login_page.dart';
import '../const.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: colorScheme,
      ),
      home: const LoginPage(),
    );
  }
}
