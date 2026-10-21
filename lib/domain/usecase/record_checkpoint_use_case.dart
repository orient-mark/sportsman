import '../model/checkpoint.dart';
import '../repository/checkpoint_repository.dart';

class RecordCheckpointUseCase {
  RecordCheckpointUseCase(this._checkpointRepository);

  final CheckpointRepository _checkpointRepository;

  /// Returns false when the checkpoint repeats the last saved checkpoint.
  Future<bool> execute(Checkpoint checkpoint) async {
    final lastCheckpoint = await _checkpointRepository.getLastCheckpoint();
    if (lastCheckpoint?.info == checkpoint.info) return false;

    await _checkpointRepository.setCheckpoint(checkpoint);
    return true;
  }
}
