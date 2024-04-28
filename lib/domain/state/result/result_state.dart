import 'package:mobx/mobx.dart';

import '../../model/participant.dart';
import '../../repository/checkpoint_repository.dart';
import '../../repository/participant_repository.dart';

part 'result_state.g.dart';

class ResultState = ResultStateBase with _$ResultState;

abstract class ResultStateBase with Store {
  ResultStateBase(this._participantRepository, this._checkpointRepository);

  final ParticipantRepository _participantRepository;
  final CheckpointRepository _checkpointRepository;

  @observable
  late Participant participant;

  @observable
  bool isLoading = false;
  @observable
  bool isGeted = false;

  @action
  Future<void> getResult() async {
    isLoading = true;
    final data = await _participantRepository.getParticipant();

    if (data != null) {
      participant = data;
      final split = await _checkpointRepository.getCheckpoints();
      if (split != null) {
        participant.split = split;
        isGeted = true;
      }
    }
    isLoading = false;
  }
}
