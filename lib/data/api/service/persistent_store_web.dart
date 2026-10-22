import 'dart:convert';
import 'dart:js_interop';

@JS('sportsmanStorage.read')
external JSPromise<JSString> _read(JSString key);
@JS('sportsmanStorage.write')
external JSPromise<JSAny?> _write(JSString key, JSString value);
@JS('sportsmanStorage.remove')
external JSPromise<JSAny?> _remove(JSString key);
@JS('sportsmanStorage.append')
external JSPromise<JSAny?> _append(JSString key, JSString value);

class PersistentStore {
  Future<String> read(String key) async =>
      (await _read(key.toJS).toDart).toDart;
  Future<void> write(String key, String value) async {
    await _write(key.toJS, value.toJS).toDart;
  }

  Future<void> remove(String key) async {
    await _remove(key.toJS).toDart;
  }

  Future<void> append(String key, Map value) async {
    await _append(key.toJS, jsonEncode(value).toJS).toDart;
  }
}
