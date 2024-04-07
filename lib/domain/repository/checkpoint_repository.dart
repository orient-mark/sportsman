import 'package:sportsman/domain/model/checkpoint.dart';

abstract class CheckpointRepository {
  Future<List<Checkpoint>> getCheckpoint();

  Future setCheckpoint(Checkpoint checkpoint);
}
