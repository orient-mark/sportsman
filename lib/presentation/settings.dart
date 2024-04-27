import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../domain/state/settings/settings_state.dart';
import '../internal/dependencies/view/settings_module.dart';
import 'widgets/header.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  _SettingsState createState() => _SettingsState();
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
              onPressed: _setParticipant,
              child: Text('Ввести'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getParticipant,
              child: Text('Получить'),
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
            decoration: InputDecoration(hintText: 'Имя'),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: TextField(
            controller: _surnameController,
            decoration: InputDecoration(hintText: 'Фамилия'),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: TextField(
            controller: _chipController,
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true, signed: true),
            decoration: InputDecoration(hintText: 'Номер чипа'),
          ),
        ),
      ],
    );
  }

  Widget _getParticipantInfo() {
    return Observer(
      builder: (_) {
        if (_settingsState.isLoading)
          return Center(
            child: CircularProgressIndicator(),
          );
        if (_settingsState.isGeted == false) return Container();

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
