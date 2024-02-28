class ApiCheckpoint {
  final String info;
  final num time;

  ApiCheckpoint.formApi(Map<String, dynamic> map)
      : info = map['checkpoint_results']['info'],
        time = map['checkpoint_results']['time'];
}
