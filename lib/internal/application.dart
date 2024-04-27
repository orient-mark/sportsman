import 'package:flutter/material.dart';
import 'package:sportsman/presentation/result/result.dart';
import 'package:sportsman/presentation/settings/settings.dart';
import 'package:sportsman/presentation/home/home.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) => const Home(),
        '/settings': (context) => const Settings(),
        '/result': (context) => const Result(),
      },
    );
  }
}
