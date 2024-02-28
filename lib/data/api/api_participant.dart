class ApiParticipant {
  final String name;
  final String surname;
  final num chip;

  ApiParticipant.fromApi(Map<String, dynamic> map)
      : name = map['participant_results']['name'],
        surname = map['participant_results']['surname'],
        chip = map['participant_results']['number_chip'];
}
