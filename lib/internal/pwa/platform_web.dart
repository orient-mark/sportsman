import 'dart:js_interop';

import 'package:mobile_scanner/mobile_scanner.dart';

@JS('sportsmanPwa.setSafeToUpdate')
external void _setSafeToUpdate(JSBoolean safe);
@JS('sportsmanPwa.beginOperation')
external void _beginOperation();
@JS('sportsmanPwa.endOperation')
external void _endOperation();
@JS('sportsmanPwa.torchAvailable')
external JSBoolean _torchAvailable();
@JS('sportsmanPwa.toggleTorch')
external JSPromise<JSBoolean> _toggleTorch();

void initializePwa() {
  MobileScannerPlatform.instance
    ..setWebBarcodeReader(WebBarcodeReader.zxingJs)
    ..setBarcodeLibraryScriptUrl(
      Uri.base.resolve('vendor/zxing.min.js').toString(),
    );
}

void setPwaSafeToUpdate(bool safe) => _setSafeToUpdate(safe.toJS);
Future<T> runPwaOperation<T>(Future<T> Function() operation) async {
  _beginOperation();
  try {
    return await operation();
  } finally {
    _endOperation();
  }
}

Future<bool> webTorchAvailable() async => _torchAvailable().toDart;
Future<bool> toggleWebTorch() async => (await _toggleTorch().toDart).toDart;
