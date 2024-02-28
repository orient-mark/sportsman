import 'package:sportsman/data/api/api_checkpoint.dart';
import 'package:sportsman/domain/model/checkpoint.dart';

class CheckpointMapper {
  static Checkpoint fromApi(ApiCheckpoint checkpoint) {
    return Checkpoint(
      info: checkpoint.toString(),
      time: checkpoint.time.toInt(),
    );
  }
}
