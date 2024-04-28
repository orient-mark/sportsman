import '../../../domain/state/settings/settings_state.dart';
import '../repository_module.dart';

class SettingsModule {
  static SettingsState settingsState() {
    return SettingsState(
      RepositoryModule.participantRepository(),
    );
  }
}
