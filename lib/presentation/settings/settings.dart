import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
  late SettingsState settingsState;

  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final chipController = TextEditingController();
  bool enabledTextFields = false;

  @override
  void initState() {
    super.initState();
    settingsState = SettingsModule.settingsState();
  }

  @override
  Widget build(BuildContext context) {
    settingsState.getParticipant();

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Observer(
              builder: (_) {
                String resultText;

                if (settingsState.isLoading) {
                  return Center(
                    child: Container(
                      color: Colors.white,
                      child: const CircularProgressIndicator(),
                    ),
                  );
                }
                if (settingsState.isGeted == false) {
                  enabledTextFields = false;
                  resultText = 'Нет данных о пользователе';
                } else {
                  enabledTextFields = true;

                  resultText = 'Данные загружены';
                  nameController.text = settingsState.participant.name;
                  surnameController.text = settingsState.participant.surname;
                  chipController.text =
                      settingsState.participant.chip.toString();
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
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        labelText: 'Имя',
                      ),
                      readOnly: true,
                      enabled: enabledTextFields,
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      controller: surnameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        labelText: 'Фамилия',
                      ),
                      readOnly: true,
                      enabled: enabledTextFields,
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      controller: chipController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        labelText: 'Номер чипа',
                        enabled: enabledTextFields,
                      ),
                      readOnly: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: showScanner,
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

  Future<void> showScanner() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog.fullscreen(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Header(context: context, title: 'Отсканируй QR'),
                Expanded(
                  child: Scanner(
                    processTheDisplayValue: (String displayValue) {
                      if (mounted) {
                        setState(() {
                          final data = jsonDecode(displayValue);

                          final name = data['name'];
                          final surname = data['surname'];
                          final chip = int.parse(data['chip'].toString());

                          settingsState.setParticipant(name, surname, chip);
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
