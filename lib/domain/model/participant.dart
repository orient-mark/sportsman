import 'package:sportsman/domain/model/checkpoint.dart';

class Participant {
  final String name;
  final String surname;
  final int chip;
  final List<Checkpoint> result;

  Participant({
    required this.name,
    required this.surname,
    required this.chip,
    required this.result,
  });
}
