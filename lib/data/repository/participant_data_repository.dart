import 'package:sportsman/data/api/api_util.dart';
import 'package:sportsman/domain/model/participant.dart';
import 'package:sportsman/domain/repository/participant_repository.dart';

class ParticipantDataRepository extends ParticipantRepository {
  final ApiUtil _apiUtil;

  ParticipantDataRepository(this._apiUtil);

  @override
  Future<Participant> getParticipant() {
    return _apiUtil.getParticipant();
  }
}
