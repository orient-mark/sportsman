import 'package:sportsman/domain/state/home/scanner_state.dart';
import 'package:sportsman/internal/dependencies/repository_module.dart';

class ScannerModule {
  static ScannerState scannerState() {
    return ScannerState(
      RepositoryModule.checkpointRepository(),
    );
  }
}
