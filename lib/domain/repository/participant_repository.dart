import 'package:sportsman/domain/model/participant.dart';

abstract class ParticipantRepository {
  Future<Participant?> getParticipant();

  Future setParticipant(Participant participant);
}
