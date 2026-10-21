import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sportsman/presentation/theme/app_theme.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:sportsman/presentation/widgets/scanner/scanner_button_widgets.dart';

class Scanner extends StatefulWidget {
  final Function(String) processTheDisplayValue;

  const Scanner({super.key, required this.processTheDisplayValue});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    autoStart: false,
    formats: [BarcodeFormat.qrCode],
  );
  StreamSubscription<Object?>? subscription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    subscription = controller.barcodes.listen(onData);

    // Attach MobileScanner before starting the camera; controller.start()
    // otherwise waits only 500 ms for the first widget frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_startCamera());
    });
  }

  Future<void> _startCamera() async {
    try {
      await controller.start();
    } on MobileScannerException catch (error) {
      // The scanner widget displays camera/permission errors from its controller.
      if (kDebugMode) debugPrint('Cannot start scanner: $error');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!controller.value.hasCameraPermission) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        subscription ??= controller.barcodes.listen(onData);

        unawaited(_startCamera());
      case AppLifecycleState.inactive:
        unawaited(subscription?.cancel());
        subscription = null;
        unawaited(controller.stop());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: AppTheme.scannerControlsHeight,
          ),
          child: MobileScanner(controller: controller, fit: BoxFit.fitWidth),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ToggleFlashlightButton(controller: controller),
            StartStopMobileScannerButton(controller: controller),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(subscription?.cancel());
    subscription = null;
    super.dispose();
    unawaited(controller.dispose());
  }

  void onData(BarcodeCapture capture) {
    if (!mounted) return;
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue ?? barcode.displayValue;
      if (value == null || value.trim().isEmpty) continue;
      if (kDebugMode) {
        debugPrint(
          'QR timing: detected at ${DateTime.now().toIso8601String()}',
        );
      }
      widget.processTheDisplayValue(value);
      return;
    }
  }
}
