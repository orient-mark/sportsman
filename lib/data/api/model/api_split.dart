class ApiSplit {
  final String? _startTime;
  final String? _finishTime;

  String? get startTime => _startTime;
  String? get finishTime => _finishTime;

  ApiSplit.fromApi(Map<String, dynamic> json)
      : _startTime = json['start'],
        _finishTime = json['finish'];
}
