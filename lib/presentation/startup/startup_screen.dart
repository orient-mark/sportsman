import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Waits for the native splash, holds the cover, then crossfades to home.
class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key, this.releaseFirstFrame = false});

  final bool releaseFirstFrame;

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  static const _channel = MethodChannel('com.orientmark/startup');
  Timer? _timer;
  bool _coverReady = false;
  bool _frameReleased = false;

  void _onCoverReady() {
    if (_coverReady) return;
    _coverReady = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _releaseFirstFrame();
      if (!mounted) return;
      try {
        // The cover's one second starts after Android finishes its fade.
        await _channel
            .invokeMethod<void>('waitForSplashExit')
            .timeout(const Duration(seconds: 3));
      } on MissingPluginException {
        // iOS and widget tests have no Android splash channel.
      } on PlatformException {
        // Continue to home if the native activity was recreated.
      } on TimeoutException {
        // A missing platform callback must never block startup.
      }
      if (!mounted) return;
      _timer = Timer(const Duration(seconds: 1), () {
        if (mounted) Navigator.of(context).pushReplacementNamed('/home');
      });
    });
  }

  void _releaseFirstFrame() {
    if (widget.releaseFirstFrame && !_frameReleased) {
      _frameReleased = true;
      WidgetsBinding.instance.allowFirstFrame();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _releaseFirstFrame();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF9ECBC3),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF9BD9ED),
        body: SizedBox.expand(
          child: Image.asset(
            'assets/branding/cover.png',
            fit: BoxFit.cover,
            excludeFromSemantics: true,
            frameBuilder: (context, child, frame, synchronouslyLoaded) {
              if (frame != null || synchronouslyLoaded) _onCoverReady();
              return child;
            },
            errorBuilder: (context, error, stackTrace) {
              _onCoverReady();
              return const SizedBox.expand();
            },
          ),
        ),
      ),
    );
  }
}
