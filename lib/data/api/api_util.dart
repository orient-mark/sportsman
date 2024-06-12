import '../../domain/model/checkpoint.dart';
import '../../domain/model/participant.dart';
import '../mapper/checkpoint_mapper.dart';
import '../mapper/participant_mapper.dart';
import 'service/local_service.dart';

class ApiUtil {
  final LocalService _localService;

  ApiUtil(this._localService);

  //#region Пользователь

  Future<Participant?> getParticipant() async {
    final result = await _localService.getParticipant();
    if (result != null) {
      return ParticipantMapper.fromApi(result);
    } else {
      return null;
    }
  }

  Future setParticipant(Participant participant) async {
    final map = ParticipantMapper.toApi(participant);
    await _localService.setParticipant(map);
  }

  //#endregion
  //#region Сплит
  Future<Split?> getSplit() async {
    final result = await _localService.getSplit();
    if (result != null) {
      return SplitMapper.fromApi(result);
    } else {
      return null;
    }
  }
  Future setSplit(Split split) async {
    final map = SplitMapper.toApi(split);
    await _localService.setSplit(map);
  }
  //#endregion

  //#region Отметка

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

  Future<Participant?> getParticipantAndSlpit() async {
    final result = await _localService.getParticipant();
    if (result != null) {
      final split = await _localService.getCheckpoints();
      if (split != null) {
        final participant = ParticipantMapper.fromApi(result);
        participant.split = CheckpointMapper.listFromApi(split);
        return participant;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
  //#endregion
}
