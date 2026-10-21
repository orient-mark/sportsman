import 'package:flutter/material.dart';
import 'package:sportsman/presentation/theme/app_theme.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sportsman/domain/state/result/result_state.dart';
import 'package:sportsman/internal/dependencies/view/result_module.dart';
import 'package:sportsman/presentation/result/widgets/animated_result_qr.dart';
import 'package:sportsman/presentation/result/widgets/split_view.dart';

class Result extends StatefulWidget {
  const Result({super.key});
  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  late final ResultState _resultState;
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    _resultState = ResultModule.resultState();
    _resultState.getResult();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(_tab == 0 ? 'Сплит' : 'Передать результат')),
    body: SafeArea(
      child: Observer(
        builder: (_) {
          if (_resultState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final document = _resultState.document;
          if (document != null && _tab == 0) {
            return SplitView(
              document: document,
              hasParticipantData: _resultState.isGeted,
            );
          }
          if (_resultState.isGeted &&
              document != null &&
              _resultState.qrFrames.isNotEmpty) {
            return AnimatedResultQr(frames: _resultState.qrFrames);
          }
          final message =
              _resultState.error ??
              (_resultState.isGeted
                  ? 'Пока нет отметок для передачи.'
                  : 'Для передачи результата нужна регистрация. Отсканируйте QR участника у организатора.');
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spaceSection),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(message, textAlign: TextAlign.center),
                  const SizedBox(height: AppTheme.spaceLarge),
                  OutlinedButton(
                    onPressed: _resultState.getResult,
                    child: const Text('Обновить'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _tab,
      onDestinationSelected: (value) => setState(() => _tab = value),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.receipt_long), label: 'Сплит'),
        NavigationDestination(icon: Icon(Icons.qr_code), label: 'Передать'),
      ],
    ),
  );
}
