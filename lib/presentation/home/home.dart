import 'package:flutter/material.dart';
import 'package:sportsman/presentation/theme/app_theme.dart';
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
            padding: AppTheme.pagePadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/result');
                        },
                        child: const Text('Показать сплит'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    showScanner();
                  },
                  child: const Text('Включить сканер'),
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
                padding: AppTheme.pagePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Header(context: context, title: 'Активный сканер'),
                    const SizedBox(height: AppTheme.spaceSection),
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
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.fade,
                        );
                      },
                    ),
                    const SizedBox(height: AppTheme.spaceSmall),
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
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.fade,
                        );
                      },
                    ),
                    const SizedBox(height: AppTheme.spaceMedium),
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
