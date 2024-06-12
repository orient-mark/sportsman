import '../../data/repository/checkpoint_data_repository.dart';
import '../../data/repository/participant_data_repository.dart';
import '../../data/repository/split_data_repository.dart';
import '../../domain/repository/checkpoint_repository.dart';
import '../../domain/repository/participant_repository.dart';
import '../../domain/repository/split_repository.dart';
import 'api_module.dart';

class RepositoryModule {
  static ParticipantRepository? _participantRepository;
  static CheckpointRepository? _checkpointRepository;
  static SplitRepository? _splitRepository;

  static ParticipantRepository participantRepository() {
    _participantRepository ??= ParticipantDataRepository(ApiModule.apiUtil());
    return _participantRepository!;
  }

  static CheckpointRepository checkpointRepository() {
    _checkpointRepository ??= CheckpointDataRepository(ApiModule.apiUtil());
    return _checkpointRepository!;
  }

  static SplitRepository splitRepository() {
    _splitRepository ??= SplitDataRepository(ApiModule.apiUtil());
    return _splitRepository!;
  }
}
