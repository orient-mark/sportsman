import 'split.dart';

class Participant {
  final String name;
  final String surname;
  final int chip;
  final String participantId;
  final String? patronymic;
  final String birthDate;
  Split? split;

  Participant({
    required this.name,
    required this.surname,
    required this.chip,
    required this.participantId,
    required this.patronymic,
    required this.birthDate,
  });
}
