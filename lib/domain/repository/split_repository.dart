import 'dart:async';

import '../model/split.dart';

abstract class SplitRepository {
  Future<Split?> getSplit();

  /// Loads marks as well, including marks recorded before a start.
  Future<Split?> getSplitAndMarks() => getSplit();

  Future setSplit(Split split);
}
