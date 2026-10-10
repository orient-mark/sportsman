import 'package:flutter/material.dart';

import '../presentation/home/home.dart';
import '../presentation/result/result.dart';
import '../presentation/settings/settings.dart';
import '../presentation/startup/startup_screen.dart';
import '../presentation/theme/app_theme.dart';

class Application extends StatelessWidget {
  const Application({super.key, this.releaseFirstFrame = false});

  final bool releaseFirstFrame;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      initialRoute: '/',
      routes: {
        '/': (context) => StartupScreen(releaseFirstFrame: releaseFirstFrame),
        '/settings': (context) => const Settings(),
        '/result': (context) => const Result(),
      },
      onGenerateRoute: (settings) {
        if (settings.name != '/home') return null;
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) => const Home(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                ),
                child: child,
              ),
        );
      },
    );
  }
}
