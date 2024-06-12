import '../../domain/model/split.dart';
import '../api/model/api_split.dart';

class SplitMapper {
  static Split fromApi(ApiSplit split) {
    return Split(
      startTime:
          split.startTime != null ? DateTime.parse(split.startTime!) : null,
      finishTime:
          split.finishTime != null ? DateTime.parse(split.finishTime!) : null,
    );
  }

  static Map toApi(Split split) => {
        'start': split.startTime?.toIso8601String(),
        'finish': split.finishTime?.toIso8601String(),
      };
}
