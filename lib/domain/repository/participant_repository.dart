import 'package:sportsman/domain/model/participant.dart';

abstract class ParticipantRepository {
  Future<String?> getResult();

  Future<Participant?> getParticipant();

  Future setParticipant(Participant participant);
}
