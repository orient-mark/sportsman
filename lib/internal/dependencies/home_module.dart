import 'package:sportsman/domain/state/home/home_state.dart';
import 'package:sportsman/internal/dependencies/repository_module.dart';

class HomeModule {
  static HomeState homeState() {
    return HomeState(
      RepositoryModule.participantRepository(),
    );
  }
}
