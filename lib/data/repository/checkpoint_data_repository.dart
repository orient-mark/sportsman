import 'package:sportsman/data/api/api_util.dart';
import 'package:sportsman/domain/model/checkpoint.dart';
import 'package:sportsman/domain/repository/checkpoint_repository.dart';

class CheckpointDataRepository extends CheckpointRepository {
  final ApiUtil _apiUtil;

  CheckpointDataRepository(this._apiUtil);

  @override
  Future<List<Checkpoint>> getCheckpoints() {
    return _apiUtil.getCheckpoints();
  }

  @override
  Future<Checkpoint> getCheckpoint() {
    return _apiUtil.getCheckpoint();
  }

  @override
  Future setCheckpoint(Checkpoint checkpoint) {
    return _apiUtil.setCheckpoint(checkpoint);
  }
}
