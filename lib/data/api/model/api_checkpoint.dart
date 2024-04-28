/// Информация в пункте [info]
/// Время отмеки [time]
class ApiCheckpoint {
  final String _info;
  final String _time;

  String get info => _info;
  String get time => _time;

  ApiCheckpoint.fromApi(Map<String, dynamic> json)
      : _info = json['info'],
        _time = json['time'];

  static List<ApiCheckpoint> splitFromApi(List<dynamic> dataList) {
    var split = <ApiCheckpoint>[];
    for (var data in dataList) {
      split.add(ApiCheckpoint.fromApi(data));
    }
    return split;
  }
}
