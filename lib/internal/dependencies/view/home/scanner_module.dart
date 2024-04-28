import '../../../../domain/state/home/scanner_state.dart';
import '../../repository_module.dart';

class ScannerModule {
  static ScannerState scannerState() {
    return ScannerState(
      RepositoryModule.checkpointRepository(),
    );
  }
}
