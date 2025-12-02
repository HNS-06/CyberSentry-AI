import 'package:flutter/material.dart';
import 'package:cybersentry_ai/app_shell.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CyberSentry AI',
      theme: ThemeData.dark(),
      home: const AppShell(),
    );
  }
}