import 'package:sportsman/data/api/api_participant.dart';
import 'package:sportsman/domain/model/participant.dart';

class ParticipantMapper {
  static Participant fromApi(ApiParticipant participant) {
    return Participant(
      name: participant.name.toString(),
      surname: participant.surname.toString(),
      chip: participant.chip.toInt(),
    );
  }
}
