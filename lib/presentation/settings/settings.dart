import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sportsman/presentation/widgets/scanner/scanner.dart';

import '../../domain/state/settings/settings_state.dart';
import '../../internal/dependencies/view/settings_module.dart';
import '../widgets/header.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _chipController = TextEditingController();

  late SettingsState _settingsState;

  @override
  void initState() {
    super.initState();
    _settingsState = SettingsModule.settingsState();
    _getParticipant();
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
            Header(
              context: context,
              title: 'Настройки',
            ),
            _getRowInput(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showScanner,
              child: const Text('Ввести данные пользователя'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getParticipant,
              child: const Text('Получить'),
            ),
            const SizedBox(height: 20),
            _getParticipantInfo(),
          ],
        ),
      ),
    );
  }

  Widget _getRowInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'Имя'),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: TextField(
            controller: _surnameController,
            decoration: const InputDecoration(hintText: 'Фамилия'),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: TextField(
            controller: _chipController,
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true, signed: true),
            decoration: const InputDecoration(hintText: 'Номер чипа'),
          ),
        ),
      ],
    );
  }

  Widget _getParticipantInfo() {
    return Observer(
      builder: (_) {
        if (_settingsState.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (_settingsState.isGeted == false) return const Text('Нет данных');

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Имя: ${_settingsState.participant.name}'),
            Text('Фамилия: ${_settingsState.participant.surname}'),
            Text('Чип: ${_settingsState.participant.chip}'),
          ],
        );
      },
    );
  }

  Future<void> _showScanner() async {
    final MobileScannerController scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      useNewCameraSelector: true,
      detectionTimeoutMs: 1000,
    );

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog.fullscreen(
          child: Column(
            children: [
              Header(context: context, title: 'Отсканируй QR'),
              Expanded(
                child: Scanner(controller: scannerController),
              ),
            ],
          ),
        );
      },
    );
  }

  void _getParticipant() {
    // здесь получаем данные
    _settingsState.getParticipant();
  }

  void _setParticipant() {
    // здесь отправляем данные
    final name = _nameController.text;
    final surname = _surnameController.text;
    final chip = int.parse(_chipController.text);
    _settingsState.setParticipant(name, surname, chip);
  }
}
