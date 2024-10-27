import 'dart:convert';

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

  @action
  Future<void> getParticipant() async {
    isGet = false;
    isDownloading = true;
    final data = await _participantRepository.getParticipant();
    if (data != null) {
      participant = data;
      isGet = true;
    } else {
      isGet = false;
    }
    isDownloading = false;
  }

  @action
  Future<void> setParticipant(String message) async {
    isSet = false;
    isLoading = true;

    try {
      final data = jsonDecode(message);
      await _participantRepository.setParticipant(
        Participant(
          name: data['participant']['name'],
          surname: data['participant']['surname'],
          chip: int.parse(data['participant']['chip'].toString()),
        ),
      );
      isSet = true;
    } catch (e) {
      isSet = false;
    }
    isLoading = false;
  }
}
