import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../domain/state/home/scanner_state.dart';
import '../../../internal/dependencies/view/home/scanner_module.dart';
import 'scanner_button_widgets.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> with WidgetsBindingObserver {
  late ScannerState _scannerState;

  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.front,
    useNewCameraSelector: true,
    detectionTimeoutMs: 1000,
  );

  Barcode? _barcode;
  late DateTime _time;
  StreamSubscription<Object?>? _subscription;
  final String _start = "0";

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Stack(children: [
              _scanner(),
              _buildBarcode(_barcode),
            ]),
          ),
        ),
        _scannerConsole(),
      ]),
    );
  }

  Widget _scanner() {
    return MobileScanner(
      controller: controller,
      fit: BoxFit.contain,
    );
  }

  Widget _scannerConsole() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ToggleFlashlightButton(controller: controller),
        StartStopMobileScannerButton(controller: controller),
        SwitchCameraButton(controller: controller),
      ],
    );
  }

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Align(
        child: Text(
          'Scan something!',
          overflow: TextOverflow.fade,
          style: TextStyle(color: Colors.black),
        ),
      );
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: Observer(
        builder: (_) {
          if (_scannerState.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (_scannerState.isGeted == false) return Container();

          return _dialog(
              '${_scannerState.checkpoint.info} time: ${_scannerState.checkpoint.time.toString()}');
        },
      ),
    );
  }

  Widget _dialog(String? message) {
    return Text(
      message ?? 'No display value.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.black),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _time = DateTime.timestamp();
        _barcode = barcodes.barcodes.firstOrNull;

        if (_barcode!.displayValue != null) {
          if (_barcode!.displayValue != _start) {
            _setCheckpoint();
          } else {
            _deleteCheckpoints();
            _barcode = null;
          }
        }
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

  void _setCheckpoint() async {
    var info = _barcode!.displayValue!;
    var time = _time;
    await _scannerState.setCheckpoint(info, time);
    _scannerState.getCheckpoint();
  }

  void _deleteCheckpoints() {
    _scannerState.deleteCheckpoints();
  }
}
