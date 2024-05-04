import 'package:sportsman/data/api/model/api_checkpoint.dart';

class ApiParticipant {
  final String _name;
  final String _surname;
  final num _chip;
  late List<ApiCheckpoint> _split;

  String get name => _name;
  String get surname => _surname;
  num get chip => _chip;
  List<ApiCheckpoint> get split => _split;

  ApiParticipant.fromApi(Map<String, dynamic> map)
      : _name = map['name'],
        _surname = map['surname'],
        _chip = map['number_chip'];
}
