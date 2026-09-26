import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:sportsman/presentation/widgets/scanner/scanner_button_widgets.dart';

class Scanner extends StatefulWidget {
  final Function(String) processTheDisplayValue;

  const Scanner({
    super.key,
    required this.processTheDisplayValue,
  });

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    autoStart: true,
    detectionTimeoutMs: 1000,
    // TODO в отличи от запущеной системы "facing: CameraFacing.front,"
  );
  Barcode? barcode;

  StreamSubscription<Object?>? subscription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    subscription = controller.barcodes.listen(onData);

    unawaited(controller.start());
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
        subscription = controller.barcodes.listen(onData);

        unawaited(controller.start());
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
          padding: const EdgeInsets.only(bottom: 48.0),
          child: MobileScanner(
            controller: controller,
            fit: BoxFit.fitWidth,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ToggleFlashlightButton(controller: controller),
            StartStopMobileScannerButton(controller: controller),
          ],
        )
      ],
    );
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(subscription?.cancel());
    subscription = null;
    super.dispose();
    await controller.dispose();
  }

  void Function(BarcodeCapture)? onData(BarcodeCapture barcodes) {
    {
      barcode = barcodes.barcodes.firstOrNull;

      if (barcode!.displayValue!.isNotEmpty) {
        widget.processTheDisplayValue(barcode!.displayValue!);
      }

      return null;
    }
  }
}
