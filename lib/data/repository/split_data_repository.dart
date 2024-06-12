import '../../domain/model/split.dart';
import '../../domain/repository/split_repository.dart';
import '../api/api_util.dart';

class SplitDataRepository extends SplitRepository {
  final ApiUtil _apiUtil;

  SplitDataRepository(this._apiUtil);

  @override
  Future<Split?> getSplit() {
    return _apiUtil.getSplit();
  }

  @override
  Future setSplit(Split split) {
    return _apiUtil.setSplit(split);
  }
}
