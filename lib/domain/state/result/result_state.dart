import 'package:mobx/mobx.dart';
import 'package:result_transfer/result_transfer.dart';
import 'package:sportsman/domain/repository/participant_repository.dart';

part 'result_state.g.dart';

class ResultState = ResultStateBase with _$ResultState;

abstract class ResultStateBase with Store {
  ResultStateBase(this._participantRepository);
  final ParticipantRepository _participantRepository;

  ResultDocument? document;
  List<String> qrFrames = const [];
  String? error;

  @observable
  bool isLoading = false;
  @observable
  bool isGeted = false;
  @observable
  bool isFinished = false;

  @action
  Future<void> getResult() async {
    if (isLoading) return;
    isLoading = true;
    isFinished = false;
    isGeted = false;
    document = null;
    qrFrames = const [];
    error = null;
    try {
      final participant = await _participantRepository.getResultParticipant();
      if (participant == null) return;
      isGeted = true;
      final split = participant.split;
      final finish = split?.finishTime;
      if (finish == null) return;
      final marks = split?.marks ?? [];
      document = ResultDocument(
        name: participant.name,
        surname: participant.surname,
        chip: participant.chip,
        start: split?.startTime,
        finish: finish,
        marks: marks.map(
          (mark) => ResultMark(code: mark.info, time: mark.time),
        ),
      );
      isFinished = true;
      qrFrames = ResultQrEncoder.encode(document!);
    } catch (_) {
      error = document == null
          ? 'Не удалось загрузить результат. Попробуйте ещё раз.'
          : 'Не удалось подготовить QR-передачу результата.';
    } finally {
      isLoading = false;
    }
  }
}
