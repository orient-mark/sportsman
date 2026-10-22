import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../../internal/pwa/platform.dart';

import 'package:sportsman/presentation/theme/app_theme.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class StartStopMobileScannerButton extends StatelessWidget {
  const StartStopMobileScannerButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () async {
              await controller.start();
            },
          );
        }

        return IconButton(
          icon: const Icon(Icons.stop),
          onPressed: () async {
            await controller.stop();
          },
        );
      },
    );
  }
}

class ToggleFlashlightButton extends StatelessWidget {
  const ToggleFlashlightButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        if (kIsWeb) return const _WebTorchButton();

        switch (state.torchState) {
          case TorchState.auto:
            return IconButton(
              icon: const Icon(Icons.flash_auto),
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.off:
            return IconButton(
              icon: const Icon(Icons.flash_off),
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.on:
            return IconButton(
              icon: const Icon(Icons.flash_on),
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.unavailable:
            return Padding(
              padding: EdgeInsets.all(AppTheme.spaceSmall),
              child: Icon(
                Icons.no_flash,
                size: AppTheme.iconSize,
                color: Theme.of(context).disabledColor,
              ),
            );
        }
      },
    );
  }
}

class _WebTorchButton extends StatefulWidget {
  const _WebTorchButton();

  @override
  State<_WebTorchButton> createState() => _WebTorchButtonState();
}

class _WebTorchButtonState extends State<_WebTorchButton> {
  late final Future<bool> _available = webTorchAvailable();
  bool _on = false;
  bool _busy = false;

  Future<void> _toggle() async {
    setState(() => _busy = true);
    try {
      final on = await toggleWebTorch();
      if (mounted) setState(() => _on = on);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Браузер не разрешил включить подсветку камеры.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<bool>(
    future: _available,
    builder: (context, snapshot) => IconButton(
      tooltip: snapshot.data == true
          ? 'Подсветка камеры'
          : 'Подсветка недоступна в браузере',
      onPressed: snapshot.data == true && !_busy ? _toggle : null,
      icon: Icon(_on ? Icons.flash_on : Icons.flash_off),
    ),
  );
}
