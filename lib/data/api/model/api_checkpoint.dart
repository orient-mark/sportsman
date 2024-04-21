/// Информация в пункте [info]
/// Время отмеки [time]
class ApiCheckpoint {
  final String info;
  final num time;

  ApiCheckpoint.fromApi(Map<String, dynamic> json)
      : info = json['info'],
        time = json['time'];

  static List<ApiCheckpoint> splitFromApi(List<dynamic> dataList) {
    var split = <ApiCheckpoint>[];
    for (var data in dataList) {
      split.add(ApiCheckpoint.fromApi(data));
    }
    return split;
  }
}
