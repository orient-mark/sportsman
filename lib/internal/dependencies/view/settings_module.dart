import 'package:sportsman/domain/state/settings/settings_state.dart';
import 'package:sportsman/internal/dependencies/repository_module.dart';

class SettingsModule {
  static SettingsState settingsState() {
    return SettingsState(
      RepositoryModule.participantRepository(),
    );
  }
}
