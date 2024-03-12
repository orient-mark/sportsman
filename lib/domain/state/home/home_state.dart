import 'package:mobx/mobx.dart';
import 'package:sportsman/domain/model/participant.dart';

import 'package:sportsman/domain/repository/participant_repository.dart';

part 'home_state.g.dart';

class HomeState = HomeStateBase with _$HomeState;

abstract class HomeStateBase with Store {
  HomeStateBase(this._participantRepository);

  final ParticipantRepository _participantRepository;

  @observable
  late Participant participant;

  @observable
  bool isLoading = false;

  @observable
  bool isGeted = false;

  @action
  Future<void> getParticipant() async {
    isLoading = true;
    final data = await _participantRepository.getParticipant();
    participant = data;
    isLoading = false;
  }

  @action
  Future<void> setParticipant(String name, String surname, int chip) async {
    isLoading = true;
    participant = Participant(name: name, surname: surname, chip: chip);
    await _participantRepository.setParticipant(participant);
    isGeted = true;
    isLoading = false;
  }
}
