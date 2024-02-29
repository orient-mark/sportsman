class ApiParticipant {
  final String name;
  final String surname;
  final num chip;

  ApiParticipant.fromApi(Map<String, dynamic> map)
      : name = map['name'],
        surname = map['surname'],
        chip = map['number_chip'];
}
