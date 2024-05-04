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

  Widget _getBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Header(context: context, title: "QR Сплита"),
            _getQRsplit(),
          ],
        ),
      ),
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
          return const Text('Нет данных');
        } else {
          return Column(
            children: [
              QrWidget(data: _resultState.result),
              Text(_resultState.result),
            ],
          );
        }
      },
    );
  }

  void _getResult() {
    _resultState.getResult();
  }
}
