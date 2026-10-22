import 'package:flutter/material.dart';

import 'internal/application.dart';
import 'internal/pwa/platform.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized().deferFirstFrame();
  initializePwa();
  runApp(const Application(releaseFirstFrame: true));
}
