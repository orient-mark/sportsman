import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
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

  /// Получаем файл из файловой системы по адресу [путь].
  ///
  /// Если файла нет, то происходит его запись.
  Future<File> _getFile(String path) async {
    final pathDirectory = await _pathApplicationDirectory;
    return await File('$pathDirectory/$path').create(recursive: true);
  }

  Future<String> get _pathApplicationDirectory async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Перезаписываем содержание файла по адресу [путь].
  Future _writeFile(String path, String contents) async {
    final file = await _getFile(path);
    await file.writeAsString(contents);
  }

  /// Получаем содержание файла по адресу [путь].
  Future<String> _readFile(String path) async {
    final file = await _getFile(path);
    return await file.readAsString();
  }

  /// Удаляет файл из файловой системы по адресу [путь].
  Future _deleteFile(String path) async {
    final file = await _getFile(path);
    await file.delete();
  }
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
    final contents = await _readFile(_pathCheckpoints);
    late List<dynamic> dataList;
    if (contents.isNotEmpty) {
      dataList = jsonDecode(contents);
    } else {
      dataList = <dynamic>[];
    }
    dataList.add(map);
    final content = jsonEncode(dataList);
    await _writeFile(_pathCheckpoints, content);
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
