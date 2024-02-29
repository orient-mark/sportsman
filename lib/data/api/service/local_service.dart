import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sportsman/data/api/api_participant.dart';

class LocalService {
  Future<String> get _pathApplicationDirectory async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> contentsFile(String path) async {
    final pathDirectory = await _pathApplicationDirectory;
    final file = await File('$pathDirectory/$path').create(recursive: true);
    return await file.readAsString();
  }

  Future<ApiParticipant> getParticipant() async {
    final string = await contentsFile('data/participant.json');
    final map = jsonDecode(string);
    return ApiParticipant.fromApi(map['participant']);
  }
}
