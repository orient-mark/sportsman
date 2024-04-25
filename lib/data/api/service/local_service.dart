import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sportsman/data/api/model/api_checkpoint.dart';
import 'package:sportsman/data/api/model/api_participant.dart';

class LocalService {
  final String pathParticipant = 'data/participant.json';
  final String pathCheckpoints = 'data/checkpoints.json';

  Future<String> get _pathApplicationDirectory async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> getFile(String path) async {
    final pathDirectory = await _pathApplicationDirectory;
    return await File('$pathDirectory/$path').create(recursive: true);
  }

  Future writeFile(String path, String contents) async {
    final file = await getFile(path);
    await file.writeAsString(contents);
  }

  Future appendFile(String path, String contents) async {
    final file = await getFile(path);
    await file.writeAsString(
      contents,
      mode: FileMode.append,
    );
  }

  Future<String> readFile(String path) async {
    final file = await getFile(path);
    return await file.readAsString();
  }

  Future deleteFile(String path) async {
    final file = await getFile(path);
    await file.delete();
  }

  Future<ApiParticipant> getParticipant() async {
    final contents = await readFile(pathParticipant);
    final map = jsonDecode(contents);
    return ApiParticipant.fromApi(map);
  }

  Future setParticipant(Map map) async {
    final contents = jsonEncode(map);
    await writeFile(pathParticipant, contents);
  }

  /// Получение сплита состоящего из Checkpoints
  Future<List<ApiCheckpoint>?> getCheckpoints() async {
    final contents = await readFile(pathCheckpoints);
    if (contents.isNotEmpty) {
      final dataList = jsonDecode(contents);
      return ApiCheckpoint.splitFromApi(dataList);
    } else {
      return null;
    }
  }

  /// Получение последнего загруженого Checkpoints
  Future<ApiCheckpoint?> getCheckpoint() async {
    final contents = await readFile(pathCheckpoints);
    if (contents.isNotEmpty) {
      final List<dynamic> dataList = jsonDecode(contents);
      return ApiCheckpoint.fromApi(dataList[dataList.length - 1]);
    } else {
      return null;
    }
  }

  /// Записать данные сплита в файл
  Future setCheckpoint(Map map) async {
    final contents = await readFile(pathCheckpoints);
    late List<dynamic> dataList;
    if (contents.isNotEmpty) {
      dataList = jsonDecode(contents);
    } else {
      dataList = <dynamic>[];
    }
    dataList.add(map);
    final content = jsonEncode(dataList);
    await writeFile(pathCheckpoints, content);
  }

  /// Очистить данные сплита
  Future deleteCheckpoints() async {
    await deleteFile(pathCheckpoints);
  }
}
