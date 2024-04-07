import 'package:sportsman/data/api/model/api_checkpoint.dart';
import 'package:sportsman/domain/model/checkpoint.dart';

class CheckpointMapper {
  static Checkpoint fromApi(ApiCheckpoint checkpoint) {
    return Checkpoint(
      info: checkpoint.info.toString(),
      time: checkpoint.time.toInt(),
    );
  }

  static List<Checkpoint> listFromApi(List<ApiCheckpoint> dataList) {
    var split = <Checkpoint>[];
    for (var data in dataList) {
      split.add(CheckpointMapper.fromApi(data));
    }
    return split;
  }

  static Map toApi(Checkpoint checkpoint) => {
        'info': checkpoint.info,
        'time': checkpoint.time,
      };
}
