import 'package:flutter/material.dart';
import 'package:sportsman/domain/state/home/scanner_state.dart';
import 'package:sportsman/internal/dependencies/view/home/scanner_module.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  late ScannerState _scannerState;

  @override
  void initState() {
    super.initState();
    _scannerState = ScannerModule.scannerState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Container(color: Colors.black)),
        ),
        Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Container(height: 40, color: Colors.blue)),
      ],
    );
  }

  void _getCheckpoint() {
    // TODO здесь получаем данные
    _scannerState.getCheckpoint();
  }

  void _setCheckpoint() {
    // TODO здесь отправляем данные
    const info = "";
    const time = 0;
    //_time;
    _scannerState.setCheckpoint(info, time);
  }
}
