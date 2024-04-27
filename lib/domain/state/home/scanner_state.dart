import 'package:mobx/mobx.dart';

import 'package:sportsman/domain/model/checkpoint.dart';
import 'package:sportsman/domain/repository/checkpoint_repository.dart';

part 'scanner_state.g.dart';

class ScannerState = ScannerStateBase with _$ScannerState;

abstract class ScannerStateBase with Store {
  ScannerStateBase(this._checkpointRepository);

  final CheckpointRepository _checkpointRepository;

  @observable
  late Checkpoint checkpoint;

  @observable
  bool isLoading = false;
  @observable
  bool isGeted = false;

  @action
  Future<void> getCheckpoint() async {
    isLoading = true;
    isGeted = false;
    final data = await _checkpointRepository.getCheckpoint();
    if (data != null) {
      checkpoint = data;
      isGeted = true;
    }
    isLoading = false;
  }

  @action
  Future<void> setCheckpoint(String info, int time) async {
    await _checkpointRepository
        .setCheckpoint(Checkpoint(info: info, time: time));
  }

  @action
  Future<void> deleteCheckpoints() async {
    await _checkpointRepository.deleteCheckpoints();
  }
}
