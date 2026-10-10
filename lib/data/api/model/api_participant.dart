class ApiParticipant {
  final String _name;
  final String _surname;
  final num _chip;
  final String? participantId;
  final String patronymic;
  final String birthDate;

  String get name => _name;
  String get surname => _surname;
  num get chip => _chip;

  ApiParticipant.fromApi(Map<String, dynamic> map)
    : _name = map['name'],
      _surname = map['surname'],
      _chip = map['number_chip'],
      participantId = map['participant_id'],
      patronymic = map['patronymic'] ?? '',
      birthDate = map['birth_date'] ?? '';
}
