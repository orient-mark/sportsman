import 'package:sportsman/domain/model/checkpoint.dart';

abstract class CheckpointRepository {
  Future<Checkpoint?> getCheckpoint();

  Future setCheckpoint(Checkpoint checkpoint);

  Future deleteCheckpoints();
}
