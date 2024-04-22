import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sportsman/domain/state/home/scanner_state.dart';
import 'package:sportsman/internal/dependencies/view/home/scanner_module.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> with WidgetsBindingObserver {
  late ScannerState _scannerState;

  final MobileScannerController controller = MobileScannerController(
    useNewCameraSelector: true,
    detectionTimeoutMs: 1000,
  );

  Barcode? _barcode;
  StreamSubscription<Object?>? _subscription;

  @override
  void initState() {
    super.initState();
    _scannerState = ScannerModule.scannerState();

    WidgetsBinding.instance.addObserver(this);

    _subscription = controller.barcodes.listen(_handleBarcode);

    unawaited(controller.start());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        _subscription = controller.barcodes.listen(_handleBarcode);

        unawaited(controller.start());
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: //Container(color: Colors.green)
                _mobileScanner(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: //Container(height: 40, color: Colors.blue)
              _buildBarcode(_barcode),
        ),
      ],
    );
  }

  Widget _mobileScanner() {
    return MobileScanner(
      controller: controller,
      fit: BoxFit.contain,
    );
  }

  //TODO Уведомление о получение QR
  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        'Scan something!',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.black),
      );
    }

    //value.displayValue
    return _dialog(value.displayValue);
  }

  Widget _dialog(String? message) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              message ?? 'No display value.',
              overflow: TextOverflow.fade,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        //TODO метрика считывания

        _barcode = barcodes.barcodes.firstOrNull;
      });
    }
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    controller.dispose();
  }

  void _getCheckpoint() {
    // TODO здесь получаем данные
    _scannerState.getCheckpoint();
  }

  void _setCheckpoint() {
    // TODO здесь отправляем данные
    const info = ""; //_barcode.displayValue;
    const time = 0;
    //_time;
    _scannerState.setCheckpoint(info, time);
  }
}
