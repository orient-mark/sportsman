import 'dart:convert';

import 'persistent_store.dart';

import 'package:sportsman/data/api/model/api_split.dart';

import '../model/api_checkpoint.dart';
import '../model/api_participant.dart';

/// Работает файлами устройства пользователя
class LocalService {
  //#region Файлы

  /// Путь к файлу спорсмена
  final String _pathParticipant = 'data/participant.json';

  /// Путь к файлу сплита
  final String _pathSplit = 'data/split.json';

  /// Путь к файлу отметок
  final String _pathCheckpoints = 'data/checkpoints.json';

  final PersistentStore _store = PersistentStore();

  Future<void> _writeFile(String path, String contents) =>
      _store.write(path, contents);
  Future<String> _readFile(String path) => _store.read(path);
  Future<void> _deleteFile(String path) => _store.remove(path);
  //#endregion

  //#region Пользователь

  /// Вывод информации о пользоватлее (без сплита).
  Future<ApiParticipant?> getParticipant() async {
    final contents = await _readFile(_pathParticipant);
    if (contents.isNotEmpty) {
      final map = jsonDecode(contents);
      return ApiParticipant.fromApi(map);
    } else {
      return null;
    }
  }

  /// Ввод информации о пользователе (без сплита).
  Future setParticipant(Map map) async {
    final contents = jsonEncode(map);
    await _writeFile(_pathParticipant, contents);
  }
  //#endregion

  //#region Отметка

  /// Получение списка отметок Checkpoints.
  Future<List<ApiCheckpoint>?> getCheckpoints() async {
    final contents = await _readFile(_pathCheckpoints);
    if (contents.isNotEmpty) {
      final dataList = jsonDecode(contents);
      return ApiCheckpoint.splitFromApi(dataList);
    } else {
      return null;
    }
  }

  /// Получение последнего загруженого Checkpoint.
  Future<ApiCheckpoint?> getLastCheckpoint() async {
    final contents = await _readFile(_pathCheckpoints);
    if (contents.isNotEmpty) {
      final List<dynamic> dataList = jsonDecode(contents);
      if (dataList.isEmpty) return null;
      return ApiCheckpoint.fromApi(dataList[dataList.length - 1]);
    } else {
      return null;
    }
  }

  /// Записать данные отметки в список.
  Future setCheckpoint(Map map) async {
    await _store.append(_pathCheckpoints, map);
  }

  /// Очистить данные списка отметок.
  Future deleteCheckpoints() async {
    await _deleteFile(_pathCheckpoints);
  }
  //#endregion

  //#region Сплитф

  /// Получение данных [ApiSplit].
  ///
  /// [ApiSplit.startTime] может быть равен `null`.
  /// [ApiSplit.finishTime] может быть равен `null`.
  Future<ApiSplit?> getSplit() async {
    final contents = await _readFile(_pathSplit);
    if (contents.isNotEmpty) {
      final map = jsonDecode(contents);
      return ApiSplit.fromApi(map);
    } else {
      return null;
    }
  }

  Future setSplit(Map map) async {
    final contents = jsonEncode(map);
    await _writeFile(_pathSplit, contents);
  }

  //#endregion
}
