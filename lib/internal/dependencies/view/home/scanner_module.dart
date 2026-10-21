import '../../../../domain/state/home/scanner_state.dart';
import '../../../../domain/usecase/record_checkpoint_use_case.dart';
import '../../repository_module.dart';

class ScannerModule {
  static ScannerState scannerState() {
    final checkpointRepository = RepositoryModule.checkpointRepository();
    return ScannerState(
      checkpointRepository,
      RepositoryModule.splitRepository(),
      RecordCheckpointUseCase(checkpointRepository),
    );
  }
}
