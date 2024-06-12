import 'dart:async';

import '../model/split.dart';

abstract class SplitRepository {
  Future<Split?> getSplit();

  Future setSplit(Split split);
}
