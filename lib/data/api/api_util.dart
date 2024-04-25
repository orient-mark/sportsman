import 'package:sportsman/data/api/service/local_service.dart';
import 'package:sportsman/data/mapper/checkpoint_mapper.dart';
import 'package:sportsman/data/mapper/participant_mapper.dart';
import 'package:sportsman/domain/model/checkpoint.dart';
import 'package:sportsman/domain/model/participant.dart';

class ApiUtil {
  final LocalService _localService;

  ApiUtil(this._localService);

  Future<Participant> getParticipant() async {
    final result = await _localService.getParticipant();
    return ParticipantMapper.fromApi(result);
  }

  Future setParticipant(Participant participant) async {
    final map = ParticipantMapper.toApi(participant);
    await _localService.setParticipant(map);
  }

  Future<List<Checkpoint>?> getCheckpoints() async {
    final result = await _localService.getCheckpoints();
    if (result != null) {
      return CheckpointMapper.listFromApi(result);
    } else {
      return null;
    }
  }

  Future<Checkpoint?> getCheckpoint() async {
    final result = await _localService.getCheckpoint();
    if (result != null) {
      return CheckpointMapper.fromApi(result);
    } else {
      return null;
    }
  }

  Future setCheckpoint(Checkpoint checkpoint) async {
    final map = CheckpointMapper.toApi(checkpoint);
    await _localService.setCheckpoint(map);
  }

  Future deleteCheckpoints() async {
    await _localService.deleteCheckpoints();
  }
}
