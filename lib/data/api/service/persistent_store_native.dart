import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PersistentStore {
  Future<File> _file(String key) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$key');
  }

  Future<String> read(String key) async {
    final file = await _file(key);
    return await file.exists() ? file.readAsString() : '';
  }

  Future<void> write(String key, String contents) async {
    final file = await _file(key);
    await file.parent.create(recursive: true);
    await file.writeAsString(contents, flush: true);
  }

  Future<void> remove(String key) async {
    final file = await _file(key);
    if (await file.exists()) await file.delete();
  }

  Future<void> append(String key, Map value) async {
    final contents = await read(key);
    final values = contents.isEmpty
        ? <dynamic>[]
        : jsonDecode(contents) as List;
    values.add(value);
    await write(key, jsonEncode(values));
  }
}
