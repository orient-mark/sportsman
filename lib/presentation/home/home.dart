import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:sportsman/domain/state/home/scanner_state.dart';
import 'package:sportsman/internal/dependencies/view/home/scanner_module.dart';

import 'package:sportsman/presentation/widgets/center_circular_progress_indicator.dart';
import 'package:sportsman/presentation/widgets/header.dart';
import 'package:sportsman/presentation/widgets/scanner/scanner.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ScannerState scannerState;

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
                          backgroundColor: const Color.fromRGBO(
                            255,
                            132,
                            0,
                            1.0,
                          ),
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
                      onPressed: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 132, 0, 1.0),
                  ),
                  onPressed: () {
                    showScanner();
                  },
                  child: const Text(
                    'Включить сканер',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showScanner() async {
    scannerState.getLastPoint();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog.fullscreen(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Header(context: context, title: 'Активный сканер'),
                    const SizedBox(height: 24.0),
                    Observer(
                      builder: (_) {
                        if (scannerState.isLoad) {
                          return const CenterCircularProgressIndicator();
                        }

                        var message = '';
                        if (scannerState.isSet == false) {
                          message =
                              'Данные не получены\n'
                              'Отсканируй QR трассы';
                        } else {
                          message = 'Данные получены';
                        }

                        return Text(
                          message,
                          style: const TextStyle(color: Colors.black),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.fade,
                        );
                      },
                    ),
                    const SizedBox(height: 8.0),
                    Observer(
                      builder: (_) {
                        if (scannerState.isDownload) {
                          return const CenterCircularProgressIndicator();
                        }

                        var message = '';
                        if (scannerState.isGet == false) {
                          message = 'Сплит чистый';
                        } else {
                          message =
                              'Последнее сканирование: ${scannerState.lastPoint}';
                        }

                        return Text(
                          message,
                          style: const TextStyle(color: Colors.black),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.fade,
                        );
                      },
                    ),
                    const SizedBox(height: 12.0),
                    Expanded(
                      child: Stack(
                        children: [
                          Scanner(
                            processTheDisplayValue: (String displayValue) {
                              if (mounted) {
                                setState(() {
                                  setPoint(displayValue);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void setPoint(String message) async {
    await scannerState.setPoint(message, DateTime.timestamp());
    scannerState.getLastPoint();
  }
}
