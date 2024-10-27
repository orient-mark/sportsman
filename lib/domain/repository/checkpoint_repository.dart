import 'package:sportsman/domain/model/checkpoint.dart';

abstract class CheckpointRepository {
  Future<Checkpoint?> getLastCheckpoint();

  Future setCheckpoint(Checkpoint checkpoint);

  Future deleteCheckpoints();
}
