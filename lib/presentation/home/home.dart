import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sportsman/domain/state/home/scanner_state.dart';
import 'package:sportsman/internal/dependencies/view/home/scanner_module.dart';
import 'package:sportsman/presentation/widgets/scanner/scanner.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ScannerState scannerState;

  Barcode? barcode;
  late String info;
  late DateTime time;
  static const String start = 'start';
  static const String finish = 'finish';
  static const String clear = 'clear';

  final MobileScannerController scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    useNewCameraSelector: true,
    detectionTimeoutMs: 1000,
  );

  @override
  void initState() {
    super.initState();

    scannerState = ScannerModule.scannerState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(255, 132, 0, 1.0),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/result');
                        },
                        child: const Text(
                          'Показать сплит',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    IconButton(
                      color: Colors.black,
                      iconSize: 32.0,
                      icon: const Icon(Icons.settings),
                      onPressed: () async {
                        scannerController.stop();
                        await Navigator.pushNamed(context, '/settings');
                        if (!context.mounted) return;
                        unawaited(scannerController.start());
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Scanner(
                        controller: scannerController,
                        handleBarcode: handleBarcode,
                      ),
                      buildBarcode(barcode),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBarcode(Barcode? value) {
    if (value == null) {
      return const Align(
        child: Text(
          'Scan something!',
          overflow: TextOverflow.fade,
          style: TextStyle(color: Colors.black),
        ),
      );
    }

    return Observer(builder: (_) {
      if (scannerState.isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (scannerState.isGeted == false) {
        switch (barcode!.displayValue) {
          case start:
            return Align(
              alignment: Alignment.bottomCenter,
              child: dialog("Старт"),
            );
          case finish:
            return Align(
              alignment: Alignment.bottomCenter,
              child: dialog("Финиш"),
            );
          case clear:
            return Align(
              alignment: Alignment.bottomCenter,
              child: dialog("Очистка"),
            );
          default:
            return Align(
              alignment: Alignment.bottomCenter,
              child: dialog("Не системный QR"),
            );
        }
      }

      return Align(
        alignment: Alignment.bottomCenter,
        child: dialog(
            '${scannerState.checkpoint.info} time: ${scannerState.checkpoint.time.toString()}'),
      );
    });
  }

  Widget dialog(String? message) {
    return Text(
      message ?? 'No display value.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.black),
    );
  }

  void handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        time = DateTime.timestamp();
        barcode = barcodes.barcodes.firstOrNull;

        if (barcode!.displayValue != null) {
          switch (barcode!.displayValue) {
            case start:
              checkpointStart(time);
              break;
            case finish:
              checkpointFinish(time);
              break;
            case clear:
              clearCheckpoints();
              break;
            default:
              setCheckpoint();
          }
        }
      });
    }
  }

  void setCheckpoint() async {
    info = barcode!.displayValue!;
    await scannerState.setCheckpoint(info, time);
    scannerState.getCheckpoint();
  }

  void checkpointStart(DateTime time) async {
    await scannerState.setSplitStart(time);
  }

  void checkpointFinish(DateTime time) async {
    await scannerState.setSplitFinish(time);
  }

  void clearCheckpoints() async {
    await scannerState.clearSlplit();
  }
}
