import 'package:mobx/mobx.dart';

import '../../repository/participant_repository.dart';

part 'result_state.g.dart';

class ResultState = ResultStateBase with _$ResultState;

abstract class ResultStateBase with Store {
  ResultStateBase(this._participantRepository);

  final ParticipantRepository _participantRepository;

  @observable
  late String split;

  @observable
  bool isLoading = false;
  @observable
  bool isGeted = false;

  @action
  Future<void> getResult() async {
    isLoading = true;
    final data = await _participantRepository.getParticipantFullJSON();
    if (data != null) {
      split = data;
      isGeted = true;
    }
    isLoading = false;
  }
}
