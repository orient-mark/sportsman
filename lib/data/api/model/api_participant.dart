class ApiParticipant {
  final String _name;
  final String _surname;
  final num _chip;

  String get name => _name;
  String get surname => _surname;
  num get chip => _chip;

  ApiParticipant.fromApi(Map<String, dynamic> map)
      : _name = map['name'],
        _surname = map['surname'],
        _chip = map['number_chip'];
}
