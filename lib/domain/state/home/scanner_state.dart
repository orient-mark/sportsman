import 'dart:convert';

import 'package:mobx/mobx.dart';

import 'package:sportsman/domain/model/checkpoint.dart';
import 'package:sportsman/domain/model/scan_outcome.dart';
import 'package:sportsman/domain/model/split.dart';
import 'package:sportsman/domain/repository/checkpoint_repository.dart';
import 'package:sportsman/domain/repository/split_repository.dart';
import 'package:sportsman/domain/usecase/record_checkpoint_use_case.dart';

part 'scanner_state.g.dart';

class ScannerState = ScannerStateBase with _$ScannerState;

abstract class ScannerStateBase with Store {
  ScannerStateBase(
    this._checkpointRepository,
    this._splitRepository,
    this._recordCheckpoint,
  );

  final CheckpointRepository _checkpointRepository;
  final SplitRepository _splitRepository;
  final RecordCheckpointUseCase _recordCheckpoint;

  // Reads and writes share a queue: opening the scanner cannot race a scan.
  Future<void> _operations = Future.value();
  final _lastOutcome = Observable<ScanOutcome?>(null);
  ScanOutcome? get lastOutcome => _lastOutcome.value;

  String lastPoint = '';
  @observable
  bool isDownload = false;
  @observable
  bool isGet = false;
  @observable
  bool isLoad = false;

  /// Whether this scan wrote data. A repeat is confirmed separately.
  @observable
  bool isSet = false;

  Future<T> _serialize<T>(Future<T> Function() operation) {
    final result = _operations.then((_) => operation());
    _operations = result.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    return result;
  }

  @action
  Future<void> getLastPoint() => _serialize(_readLastPoint);

  Future<void> _readLastPoint() async {
    runInAction(() {
      isDownload = true;
      isGet = false;
      lastPoint = '';
    });
    try {
      final data = await _checkpointRepository.getLastCheckpoint();
      final split = await _splitRepository.getSplit();
      final finish = split?.finishTime;
      final point =
          finish != null && (data == null || !data.time.isAfter(finish))
          ? 'финиш'
          : data?.info ?? (split?.startTime != null ? 'старт' : '');
      runInAction(() {
        lastPoint = point;
        isGet = point.isNotEmpty;
      });
    } catch (_) {
      runInAction(() => isGet = false);
    } finally {
      runInAction(() => isDownload = false);
    }
  }

  // Preserve the MobX-generated public action and existing callers.
  @action
  Future<void> setPoint(String message, DateTime time) async {
    await processPoint(message, time);
  }

  Future<ScanOutcome> processPoint(String message, DateTime time) =>
      _serialize(() => _processPoint(message, time));

  Future<ScanOutcome> _processPoint(String message, DateTime time) async {
    runInAction(() {
      isLoad = true;
      isSet = false;
      _lastOutcome.value = null;
    });
    var outcome = ScanOutcome.invalid;
    try {
      Object? data;
      try {
        data = jsonDecode(message);
      } on FormatException {
        return outcome;
      }
      if (data is! Map<String, dynamic>) return outcome;
      final point = data['point'];
      if (point == 'start') {
        await _splitRepository.setSplit(Split(startTime: time));
        await _checkpointRepository.deleteCheckpoints();
        return outcome = ScanOutcome.recorded;
      }
      if (point == 'finish') {
        final split = await _splitRepository.getSplit() ?? Split();
        final oldFinish = split.finishTime;
        if (oldFinish != null) {
          final last = await _checkpointRepository.getLastCheckpoint();
          if (last == null || !last.time.isAfter(oldFinish)) {
            return outcome = ScanOutcome.repeated;
          }
        }
        split.finishTime = time;
        await _splitRepository.setSplit(split);
        return outcome = ScanOutcome.recorded;
      }
      if (point == 'cleaning') {
        await _splitRepository.setSplit(Split());
        await _checkpointRepository.deleteCheckpoints();
        return outcome = ScanOutcome.recorded;
      }
      if (point is Map<String, dynamic>) {
        final checkpoint = point['checkpoint'];
        if (checkpoint is! String && checkpoint is! int) return outcome;
        final info = checkpoint.toString().trim();
        if (!RegExp(r'^[3-9][0-9]$').hasMatch(info) || info == '30') {
          return outcome;
        }
        final written = await _recordCheckpoint.execute(
          Checkpoint(info: info, time: time),
        );
        return outcome = written ? ScanOutcome.recorded : ScanOutcome.repeated;
      }
      return outcome;
    } catch (_) {
      return outcome = ScanOutcome.failed;
    } finally {
      runInAction(() {
        isSet = outcome == ScanOutcome.recorded;
        _lastOutcome.value = outcome;
        isLoad = false;
      });
    }
  }
}
