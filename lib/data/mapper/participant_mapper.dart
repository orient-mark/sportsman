import '../../domain/model/participant.dart';
import '../api/model/api_participant.dart';

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
