import 'package:sportsman/data/repository/participant_data_repository.dart';
import 'package:sportsman/domain/repository/participant_repository.dart';

import 'api_module.dart';

class RepositoryModule {
  static ParticipantRepository? _participantRepository;

  static ParticipantRepository participantRepository() {
    _participantRepository ??= ParticipantDataRepository(ApiModule.apiUtil());
    return _participantRepository!;
  }
}
