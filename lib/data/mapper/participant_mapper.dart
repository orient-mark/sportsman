import 'package:sportsman/data/api/model/api_participant.dart';
import 'package:sportsman/domain/model/participant.dart';

class ParticipantMapper {
  static Participant fromApi(ApiParticipant participant) {
    return Participant(
      name: participant.name.toString(),
      surname: participant.surname.toString(),
      chip: participant.chip.toInt(),
    );
  }

  static Map toApi(Participant participant) => {
        'name': participant.name,
        'surname': participant.surname,
        'number_chip': participant.chip,
      };
}
