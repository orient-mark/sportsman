import 'package:sportsman/domain/model/checkpoint.dart';

class Participant {
  final String name;
  final String surname;
  final int chip;
  List<Checkpoint>? split;

  Participant({
    required this.name,
    required this.surname,
    required this.chip,
  });
}
