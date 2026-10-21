import 'package:mobx/mobx.dart';
import 'package:result_transfer/result_transfer.dart';
import 'package:sportsman/domain/repository/participant_repository.dart';
import 'package:sportsman/domain/repository/split_repository.dart';

part 'result_state.g.dart';

class ResultState = ResultStateBase with _$ResultState;

abstract class ResultStateBase with Store {
  ResultStateBase(
    this._participantRepository, {
    this._splitRepository,
  });
  final ParticipantRepository _participantRepository;
  final SplitRepository? _splitRepository;

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
      final participant = _splitRepository == null
          ? await _participantRepository.getResultParticipant()
          : await _participantRepository.getParticipant();
      isGeted = participant != null;
      final split = _splitRepository == null
          ? participant?.split
          : await _splitRepository.getSplitAndMarks();
      final finish = split?.finishTime;
      final marks = split?.marks ?? [];
      document = ResultDocument(
        name: participant?.name ?? '',
        surname: participant?.surname ?? '',
        chip: participant?.chip ?? 0,
        participantId: participant?.participantId,
        patronymic: participant?.patronymic ?? '',
        birthDate: participant?.birthDate ?? '',
        start: split?.startTime,
        finish: finish,
        marks: marks.map(
          (mark) => ResultMark(code: mark.info, time: mark.time),
        ),
      );
      isFinished = finish != null;
      // An anonymous document is a local preview and must never be encoded.
      if (participant == null) return;
      if (split?.startTime == null && finish == null && marks.isEmpty) return;
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
