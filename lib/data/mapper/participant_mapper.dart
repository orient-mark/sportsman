import '../../domain/model/participant.dart';
import '../api/model/api_participant.dart';

class ParticipantMapper {
  static Participant fromApi(ApiParticipant participant) {
    return Participant(
      name: participant.name.toString(),
      surname: participant.surname.toString(),
      chip: participant.chip.toInt(),
      participantId: participant.participantId.toString(),
      patronymic: participant.patronymic.toString(),
      birthDate: participant.birthDate.toString(),
    );
  }

  static Map toApi(Participant participant) => {
    'name': participant.name,
    'surname': participant.surname,
    'number_chip': participant.chip,
    'participant_id': participant.participantId,
    'patronymic': participant.patronymic,
    'birth_date': participant.birthDate,
  };
}
