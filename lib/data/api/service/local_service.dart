import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../model/api_checkpoint.dart';
import '../model/api_participant.dart';

class LocalService {
  final String _pathParticipant = 'data/participant.json';
  final String _pathCheckpoints = 'data/checkpoints.json';

  Future<String> get _pathApplicationDirectory async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _getFile(String path) async {
    final pathDirectory = await _pathApplicationDirectory;
    return await File('$pathDirectory/$path').create(recursive: true);
  }

  Future _writeFile(String path, String contents) async {
    final file = await _getFile(path);
    await file.writeAsString(contents);
  }

  Future<String> _readFile(String path) async {
    final file = await _getFile(path);
    return await file.readAsString();
  }

  Future _deleteFile(String path) async {
    final file = await _getFile(path);
    await file.delete();
  }

  ///TODO get null
  Future<ApiParticipant> getParticipant() async {
    final contents = await _readFile(_pathParticipant);
    final map = jsonDecode(contents);
    return ApiParticipant.fromApi(map);
  }

  Future setParticipant(Map map) async {
    final contents = jsonEncode(map);
    await _writeFile(_pathParticipant, contents);
  }

  /// Получение сплита состоящего из Checkpoints
  Future<List<ApiCheckpoint>?> getCheckpoints() async {
    final contents = await _readFile(_pathCheckpoints);
    if (contents.isNotEmpty) {
      final dataList = jsonDecode(contents);
      return ApiCheckpoint.splitFromApi(dataList);
    } else {
      return null;
    }
  }

  /// Получение последнего загруженого Checkpoints
  Future<ApiCheckpoint?> getCheckpoint() async {
    final contents = await _readFile(_pathCheckpoints);
    if (contents.isNotEmpty) {
      final List<dynamic> dataList = jsonDecode(contents);
      return ApiCheckpoint.fromApi(dataList[dataList.length - 1]);
    } else {
      return null;
    }
  }

  /// Записать данные отметки в сплит
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

  /// Очистить данные сплита
  Future deleteCheckpoints() async {
    await _deleteFile(_pathCheckpoints);
  }
}
