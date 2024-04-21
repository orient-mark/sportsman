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
    final data = await _checkpointRepository.getCheckpoint();
    checkpoint = data;
    isGeted = true;
    isLoading = false;
  }

  @action
  Future<void> setCheckpoint(String info, int time) async {
    isLoading = true;
    checkpoint = Checkpoint(info: info, time: time);
    await _checkpointRepository.setCheckpoint(checkpoint);
    isGeted = false;
    isLoading = false;
  }
}
