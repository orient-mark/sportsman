import 'package:flutter/material.dart';
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
