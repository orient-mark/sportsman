import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sportsman/domain/state/settings/settings_state.dart';
import 'package:sportsman/internal/dependencies/view/settings_module.dart';
import 'package:sportsman/presentation/widgets/center_circular_progress_indicator.dart';
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

    settingsState.getParticipant();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Observer(
              builder: (_) {
                String resultText;

                if (settingsState.isDownloading) {
                  return const CenterCircularProgressIndicator();
                }
                if (settingsState.isGet == false) {
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
                      onPressed: () {
                        settingsState.isSet = false;
                        showScanner();
                      },
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
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Header(context: context, title: 'Активный сканер'),
                    const SizedBox(height: 24.0),
                    Observer(builder: (_) {
                      if (settingsState.isLoading) {
                        return const CenterCircularProgressIndicator();
                      }

                      var message = '';
                      if (settingsState.isSet == false) {
                        message = 'Данные не получены\n'
                            'Отсканируй QR предоставленный организатором';
                      } else {
                        message = 'Данные получены';
                      }

                      return Text(
                        message,
                        style: const TextStyle(color: Colors.black),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.fade,
                      );
                    }),
                    const SizedBox(height: 8.0),
                    Observer(builder: (_) {
                      if (settingsState.isDownloading) {
                        return const CenterCircularProgressIndicator();
                      }

                      var message = '';
                      if (settingsState.isGet == false) {
                        message += '\nНет данных о пользователе';
                      } else {
                        message = 'Текущие данные:\n'
                            '${settingsState.participant.name} ${settingsState.participant.surname}\n'
                            'Чип: ${settingsState.participant.chip}';
                      }
                      return Text(
                        message,
                        style: const TextStyle(color: Colors.black),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.fade,
                      );
                    }),
                    const SizedBox(height: 12.0),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Scanner(
                            processTheDisplayValue: (String displayValue) {
                              if (mounted) {
                                setState(() {
                                  setParticipant(displayValue);
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

  void setParticipant(String message) async {
    await settingsState.setParticipant(message);
    settingsState.getParticipant();
  }
}
