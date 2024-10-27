import 'dart:convert';

import 'package:mobx/mobx.dart';

import 'package:sportsman/domain/model/checkpoint.dart';
import 'package:sportsman/domain/model/split.dart';
import 'package:sportsman/domain/repository/checkpoint_repository.dart';
import 'package:sportsman/domain/repository/split_repository.dart';

part 'scanner_state.g.dart';

class ScannerState = ScannerStateBase with _$ScannerState;

abstract class ScannerStateBase with Store {
  ScannerStateBase(this._checkpointRepository, this._splitRepository);

  final CheckpointRepository _checkpointRepository;
  final SplitRepository _splitRepository;

  String lastPoint = '';
  @observable
  bool isDownload = false;
  @observable
  bool isGet = false;
  @observable
  bool isLoad = false;
  @observable
  bool isSet = false;

  @action
  Future<void> getLastPoint() async {
    isDownload = true;
    isGet = false;
    final data = await _checkpointRepository.getLastCheckpoint();
    final split = await _splitRepository.getSplit() as Split;

    if (split.finishTime != null) {
      lastPoint = 'финиш';
      isGet = true;
    } else if (data != null) {
      lastPoint = data.info;
      isGet = true;
    } else if (split.startTime != null) {
      lastPoint = 'старт';
      isGet = true;
    } else {
      isGet = false;
    }

    isDownload = false;
  }

  @action
  Future<void> setPoint(String message, DateTime time) async {
    isLoad = true;
    isSet = false;
    try {
      final data = jsonDecode(message);
      if (data['point'] == 'start') {
        await _splitRepository.setSplit(Split(startTime: time));
        await _checkpointRepository.deleteCheckpoints();
        isSet = true;
      }
      if (data['point'] == 'finish') {
        final split = await _splitRepository.getSplit();
        if (split != null) {
          split.finishTime = time;
          await _splitRepository.setSplit(split);
        } else {
          await _splitRepository.setSplit(Split(finishTime: time));
        }
        isSet = true;
      }
      if (data['point'] == 'cleaning') {
        await _splitRepository.setSplit(Split(
          startTime: null,
          finishTime: null,
        ));
        await _checkpointRepository.deleteCheckpoints();
        isSet = true;
      }
      if (data['point'] is Map) {
        await _checkpointRepository.setCheckpoint(Checkpoint(
            info: data['point']['checkpoint'].toString(), time: time));
        isSet = true;
      }
    } catch (e) {
      isSet = false;
    }
    isLoad = false;
  }
}
