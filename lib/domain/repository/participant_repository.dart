import 'package:sportsman/domain/model/participant.dart';

abstract class ParticipantRepository {
  Future<String?> getParticipantFullJSON();

  Future<Participant?> getParticipant();

  Future setParticipant(Participant participant);
}
