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
    lastPoint = '';
    try {
      final data = await _checkpointRepository.getLastCheckpoint();
      final split = await _splitRepository.getSplit();

      if (split?.finishTime != null) {
        lastPoint = 'финиш';
        isGet = true;
      } else if (data != null) {
        lastPoint = data.info;
        isGet = true;
      } else if (split?.startTime != null) {
        lastPoint = 'старт';
        isGet = true;
      } else {
        isGet = false;
      }
    } catch (_) {
      isGet = false;
    } finally {
      isDownload = false;
    }
  }

  @action
  Future<void> setPoint(String message, DateTime time) async {
    if (isLoad) return;
    isLoad = true;
    isSet = false;
    try {
      final data = jsonDecode(message);
      if (data is! Map<String, dynamic>) return;
      if (data['point'] == 'start') {
        await _splitRepository.setSplit(Split(startTime: time));
        await _checkpointRepository.deleteCheckpoints();
        isSet = true;
      }
      if (data['point'] == 'finish') {
        final split = await _splitRepository.getSplit();
        if (split != null) {
          split.finishTime ??= time;
          await _splitRepository.setSplit(split);
        } else {
          await _splitRepository.setSplit(Split(finishTime: time));
        }
        isSet = true;
      }
      if (data['point'] == 'cleaning') {
        await _splitRepository.setSplit(
          Split(startTime: null, finishTime: null),
        );
        await _checkpointRepository.deleteCheckpoints();
        isSet = true;
      }
      if (data['point'] is Map) {
        final checkpoint = data['point']['checkpoint'];
        if (checkpoint is! String && checkpoint is! int) return;
        final info = checkpoint.toString().trim();
        if (info.isEmpty) return;
        await _checkpointRepository.setCheckpoint(
          Checkpoint(info: info, time: time),
        );
        isSet = true;
      }
    } catch (e) {
      isSet = false;
    } finally {
      isLoad = false;
    }
  }
}
