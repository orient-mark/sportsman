import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../domain/state/result/result_state.dart';
import '../../internal/dependencies/view/result_module.dart';
import '../widgets/header.dart';
import 'widgets/qr.dart';

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
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (_resultState.isGeted == false) {
          return const Center(child: Text('Нет данных'));
        } else {
          return Column(
            children: [
              QrWidget(data: _resultState.result),
              Text(_resultState.result),
            ],
            );
        }
    );
  }
  Widget _getQRsplit() {
    return Observer(
      builder: (_) {
        if (_resultState.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (_resultState.isGeted == false) {
          return const Center(child: Text('Нет данных'));
        } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
            );
      },
    );
  }

  void _getResult() {
    _resultState.getResult();
  }
}
