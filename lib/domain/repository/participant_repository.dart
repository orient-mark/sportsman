import 'package:sportsman/domain/model/participant.dart';

abstract class ParticipantRepository {
  Future<Participant?> getResultParticipant();

  Future<Participant?> getParticipant();

  Future setParticipant(Participant participant);
}
