import 'package:sportsman/data/api/service/local_service.dart';
import 'package:sportsman/data/mapper/participant_mapper.dart';
import 'package:sportsman/domain/model/participant.dart';

class ApiUtil {
  final LocalService _localService;

  ApiUtil(this._localService);

  Future<Participant> getParticipant() async {
    final result = await _localService.getParticipant();
    return ParticipantMapper.fromApi(result);
  }
}
