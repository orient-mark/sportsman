import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:sportsman/domain/state/result/result_state.dart';
import 'package:sportsman/internal/dependencies/view/result_module.dart';

import 'package:sportsman/presentation/result/widgets/qr.dart';
import 'package:sportsman/presentation/widgets/center_circular_progress_indicator.dart';
import 'package:sportsman/presentation/widgets/header.dart';

class Result extends StatefulWidget {
  const Result({super.key});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  late ResultState _resultState;

  @override
  void initState() {
    super.initState();

    _resultState = ResultModule.resultState();
    _getResult();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: _getBody(),
      ),
    );
  }

  String titleTab = "QR Участника";
  int currentTab = 0;
  final PageStorageBucket _bucket = PageStorageBucket();

  Widget _getBody() {
    final List<Widget> pages = <Widget>[
      _getQRSporsman(),
      Expanded(
        child: _getQRsplit(),
      ),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Header(context: context, title: titleTab),
            Expanded(
              child: PageStorage(
                bucket: _bucket,
                child: pages[currentTab],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    IconButton(
                      color: currentTab == 0 ? Colors.orange : Colors.black,
                      isSelected: currentTab == 0,
                      icon: const Icon(Icons.accessibility_rounded),
                      selectedIcon: const Icon(Icons.accessibility_new_rounded),
                      onPressed: () {
                        titleTab = "QR Участника";
                        navigation(0);
                      },
                    ),
                    const Text("Участник")
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      color: currentTab == 1 ? Colors.orange : Colors.black,
                      isSelected: currentTab == 1,
                      icon: const Icon(Icons.receipt_long_outlined),
                      selectedIcon: const Icon(Icons.receipt_long),
                      onPressed: () {
                        titleTab = "QR Сплита";
                        navigation(1);
                      },
                    ),
                    const Text("Сплит")
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void navigation(int number) {
    setState(() {
      currentTab = number;
    });
  }

  Widget _getQRSporsman() {
    return Observer(
      builder: (_) {
        if (_resultState.isLoading) {
          return const CenterCircularProgressIndicator();
        }
        if (_resultState.isGeted == false) {
          return const Center(child: Text('Нет данных'));
        } else {
          if (_resultState.isFinished == false) {
            return const Center(child: Text('Нет ФИНИША'));
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Участник: ${_resultState.participantName}"),
                        Text("Чип: ${_resultState.participantChip}"),
                      ],
                    ),
                  ),
                  QrWidget(data: _resultState.participantJSON),
                ],
              ),
            );
          }
        }
      },
    );
  }

  Widget _getQRsplit() {
    return Observer(
      builder: (_) {
        if (_resultState.isLoading) {
          return const CenterCircularProgressIndicator();
        }
        if (_resultState.isGeted == false) {
          return const Center(child: Text('Нет данных'));
        } else {
          if (_resultState.isFinished == false) {
            return const Center(child: Text('Нет ФИНИША'));
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _resultState.participantResult.length,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text("${index + 1}-я часть сплита"),
                          ),
                          QrWidget(
                            data:
                                "$index${_resultState.participantResult[index]}",
                          ),
                        ],
                      ),
                    );
                  }),
            );
          }
        }
      },
    );
  }

  void _getResult() {
    _resultState.getResult();
  }
}
