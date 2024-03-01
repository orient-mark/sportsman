import 'package:sportsman/data/api/api_util.dart';
import 'package:sportsman/data/api/service/local_service.dart';

class ApiModule {
  static ApiUtil? _apiUtil;

  static ApiUtil apiUtil() {
    _apiUtil ??= ApiUtil(LocalService());
    return _apiUtil!;
  }
}
