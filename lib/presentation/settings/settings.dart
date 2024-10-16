import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sportsman/domain/state/settings/settings_state.dart';
import 'package:sportsman/internal/dependencies/view/settings_module.dart';
import 'package:sportsman/presentation/widgets/header.dart';
import 'package:sportsman/presentation/widgets/scanner/scanner.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _chipController = TextEditingController();
  bool enabled = false;

  late SettingsState _settingsState;

  @override
  void initState() {
    super.initState();
    _settingsState = SettingsModule.settingsState();
  }

  @override
  Widget build(BuildContext context) {
    _getParticipant();

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Observer(
              builder: (_) {
                String resultText;

                if (_settingsState.isLoading) {
                  return Center(
                    child: Container(
                      color: Colors.white,
                      child: const CircularProgressIndicator(),
                    ),
                  );
                }
                if (_settingsState.isGeted == false) {
                  enabled = false;
                  resultText = 'Нет данных о пользователе';
                } else {
                  enabled = true;

                  resultText = 'Данные загружены';
                  _nameController.text = _settingsState.participant.name;
                  _surnameController.text = _settingsState.participant.surname;
                  _chipController.text =
                      _settingsState.participant.chip.toString();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Header(
                      context: context,
                      title: 'Настройки',
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        labelText: 'Имя',
                      ),
                      readOnly: true,
                      enabled: enabled,
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      controller: _surnameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        labelText: 'Фамилия',
                      ),
                      readOnly: true,
                      enabled: enabled,
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      controller: _chipController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true, signed: true),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        labelText: 'Номер чипа',
                        enabled: enabled,
                      ),
                      readOnly: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _showScanner,
                      child: const Text('Ввести данные пользователя'),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          resultText,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
        ),
      ),
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
