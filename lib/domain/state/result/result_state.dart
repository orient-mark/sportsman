import 'package:mobx/mobx.dart';
import 'package:sportsman/domain/model/participant.dart';

import '../../repository/participant_repository.dart';

part 'result_state.g.dart';

class ResultState = ResultStateBase with _$ResultState;

abstract class ResultStateBase with Store {
  ResultStateBase(this._participantRepository);

  final ParticipantRepository _participantRepository;

  @observable
  late Participant participant;

  @observable
  bool isLoading = false;
  @observable
  bool isGeted = false;

  @action
  Future<void> getResult() async {
    isGeted = false;
    isLoading = true;
    final data = await _participantRepository.getResultParticipant();
    if (data != null) {
      participant = data;
      isGeted = true;
    }
    isLoading = false;
  }
}
