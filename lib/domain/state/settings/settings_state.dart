import 'dart:convert';

import 'package:participant_identity/participant_identity.dart';

import 'package:mobx/mobx.dart';

import 'package:sportsman/domain/model/participant.dart';
import 'package:sportsman/domain/repository/participant_repository.dart';

part 'settings_state.g.dart';

class SettingsState = SettingsStateBase with _$SettingsState;

abstract class SettingsStateBase with Store {
  SettingsStateBase(this._participantRepository);

  final ParticipantRepository _participantRepository;

  @observable
  late Participant participant;

  @observable
  bool isDownloading = false;

  @observable
  bool isSet = false;

  @observable
  bool isLoading = false;

  @observable
  bool isGet = false;

  String? participantLoadError;

  @action
  Future<void> getParticipant() async {
    if (isDownloading) return;
    isGet = false;
    isDownloading = true;
    participantLoadError = null;
    try {
      final data = await _participantRepository.getParticipant();
      if (data != null) {
        participant = data;
        isGet = true;
      }
    } catch (_) {
      isGet = false;
      participantLoadError = 'Не удалось загрузить данные пользователя. Повторите попытку или отсканируйте QR организатора.';
    } finally {
      isDownloading = false;
    }
  }

  @action
  Future<void> setParticipant(String message) async {
    isSet = false;
    isLoading = true;

    try {
      final data = jsonDecode(message);
      final p = data['participant'];
      if (p['id'] != null &&
          p['id'] !=
              ParticipantIdentity.id(
                surname: p['surname'],
                firstName: p['name'],
                patronymic: p['patronymic'] ?? '',
                birthDate: p['birth_date'],
              )) {
        throw const FormatException('Неверный UUID регистрации');
      }
      await _participantRepository.setParticipant(
        Participant(
          name: data['participant']['name'],
          surname: data['participant']['surname'],
          chip: int.tryParse(data['participant']['chip'].toString()) ?? 0,
          participantId: data['participant']['id'],
          patronymic: data['participant']['patronymic'] ?? '',
          birthDate: data['participant']['birth_date'] ?? '',
        ),
      );
      isSet = true;
    } catch (e) {
      isSet = false;
    }
    isLoading = false;
  }
}
