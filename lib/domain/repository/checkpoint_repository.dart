import 'package:sportsman/domain/model/checkpoint.dart';

abstract class CheckpointRepository {
  Future<List<Checkpoint>> getCheckpoints();

  Future setCheckpoint(Checkpoint checkpoint);
}
