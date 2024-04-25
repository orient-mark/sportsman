import 'package:sportsman/data/api/model/api_checkpoint.dart';
import 'package:sportsman/domain/model/checkpoint.dart';

class CheckpointMapper {
  static Checkpoint _fromApi(ApiCheckpoint checkpoint) {
    return Checkpoint(
      info: checkpoint.info.toString(),
      time: checkpoint.time.toInt(),
    );
  }

  static List<Checkpoint> listFromApi(List<ApiCheckpoint> dataList) {
    var split = <Checkpoint>[];
    for (var data in dataList) {
      split.add(_fromApi(data));
    }
    return split;
  }

  static Checkpoint fromApi(ApiCheckpoint checkpoint) {
    return _fromApi(checkpoint);
  }

  static Map toApi(Checkpoint checkpoint) => {
        'info': checkpoint.info,
        'time': checkpoint.time,
      };
}
