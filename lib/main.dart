import 'package:flutter/material.dart';

import 'internal/application.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized().deferFirstFrame();
  runApp(const Application(releaseFirstFrame: true));
}
