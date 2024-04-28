import '../../../domain/state/result/result_state.dart';
import '../repository_module.dart';

class ResultModule {
  static ResultState resultState() {
    return ResultState(
      RepositoryModule.participantRepository(),
    );
  }
}
