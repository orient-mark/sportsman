import '../../domain/model/participant.dart';
import '../../domain/repository/participant_repository.dart';
import '../api/api_util.dart';

class ParticipantDataRepository extends ParticipantRepository {
  final ApiUtil _apiUtil;

  ParticipantDataRepository(this._apiUtil);

  @override
  Future<Participant?> getParticipant() {
    return _apiUtil.getParticipant();
  }

  @override
  Future setParticipant(Participant participant) {
    return _apiUtil.setParticipant(participant);
  }

  @override
  Future<String?> getParticipantFullJSON() {
    return _apiUtil.getParticipantFullJSON();
  }
}
