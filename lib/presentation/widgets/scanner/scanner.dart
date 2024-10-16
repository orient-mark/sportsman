import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sportsman/presentation/widgets/scanner/scanner_button_widgets.dart';

class Scanner extends StatefulWidget {
  final MobileScannerController controller;
  final Function(BarcodeCapture event)? handleBarcode;

  const Scanner({super.key, required this.controller, this.handleBarcode});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> with WidgetsBindingObserver {
  late MobileScannerController controller;

  StreamSubscription<Object?>? subscription;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;

    WidgetsBinding.instance.addObserver(this);

    subscription = controller.barcodes.listen(widget.handleBarcode);

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
        subscription = controller.barcodes.listen(widget.handleBarcode);

        unawaited(controller.start());
      case AppLifecycleState.inactive:
        unawaited(subscription?.cancel());
        subscription = null;
        unawaited(controller.stop());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: MobileScanner(
            controller: controller,
            fit: BoxFit.contain,
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
}
