import 'package:sportsman/domain/model/participant.dart';

abstract class ParticipantRepository {
  Future<Participant> getParticipant({
    required int id,
  });
}
