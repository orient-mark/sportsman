import 'package:mobx/mobx.dart';

import '../../model/checkpoint.dart';
import '../../model/split.dart';
import '../../repository/checkpoint_repository.dart';
import '../../repository/split_repository.dart';

part 'scanner_state.g.dart';

class ScannerState = ScannerStateBase with _$ScannerState;

abstract class ScannerStateBase with Store {
  ScannerStateBase(this._checkpointRepository, this._splitRepository);

  final CheckpointRepository _checkpointRepository;
  final SplitRepository _splitRepository;

  late Checkpoint checkpoint;
  late Split split;

  @observable
  bool isLoading = false;
  @observable
  bool isGeted = false;

  @action
  Future<void> getCheckpoint() async {
    isLoading = true;
    isGeted = false;
    final data = await _checkpointRepository.getLastCheckpoint();
    if (data != null) {
      checkpoint = data;
      isGeted = true;
    }
    isLoading = false;
  }

  @action
  Future<void> setCheckpoint(String info, DateTime time) async {
    await _checkpointRepository
        .setCheckpoint(Checkpoint(info: info, time: time));
  }

  @action
  Future<void> setSplitStart(DateTime startTime) async {
    isGeted = false;
    await _checkpointRepository.deleteCheckpoints();
    await _splitRepository.setSplit(Split(startTime: startTime));
  }

  @action
  Future<void> setSplitFinish(DateTime finishTime) async {
    isGeted = false;
    var split = await _splitRepository.getSplit();
    if (split != null) {
      split.finishTime = finishTime;
      await _splitRepository.setSplit(split);
    } else {
      await _splitRepository.setSplit(Split(finishTime: finishTime));
    }
  }

  @action
  Future<void> clearSlplit() async {
    isGeted = false;
    await _splitRepository.setSplit(Split(startTime: null, finishTime: null));
    await _checkpointRepository.deleteCheckpoints();
  }
}
