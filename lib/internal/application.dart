import 'package:flutter/material.dart';

import '../presentation/home/home.dart';
import '../presentation/result/result.dart';
import '../presentation/settings/settings.dart';

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
