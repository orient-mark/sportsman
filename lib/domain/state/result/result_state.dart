import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:sportsman/domain/model/participant.dart';

import '../../repository/participant_repository.dart';

part 'result_state.g.dart';

class ResultState = ResultStateBase with _$ResultState;

abstract class ResultStateBase with Store {
  ResultStateBase(this._participantRepository);

  final ParticipantRepository _participantRepository;

  @observable
  late Participant _participant;

  /// Строка в формате JSON для передачи данных о участнике
  late String participantJSON;

  /// Фамилия Имя участника
  late String participantName;
  late int participantChip;

  late String participantSportsTrack;

  /// Содержит список отметки в формате JSON
  List<String> participantResult = List.empty(growable: true);

  /// Размер шага сборки
  @observable
  int stepSize = 10;

  @observable
  bool isLoading = false;
  @observable
  bool isGeted = false;
  @observable
  bool isFinished = false;

  /// Добавляем по размеру [stepSize]
  @action
  Future<void> getResult() async {
    isFinished = false;
    isGeted = false;
    isLoading = true;
    final data = await _participantRepository.getResultParticipant();
    if (data != null) {
      _participant = data;

      participantName = "${_participant.surname} ${_participant.name}";
      participantChip = _participant.chip;
      // TODO добавить в participant трассу participant.track
      participantSportsTrack = "number track";

      DateTime? startTime = _participant.split!.startTime;
      DateTime? finishTime = _participant.split!.finishTime;

      if (finishTime == null) {
        isGeted = true;
        isLoading = false;
        return;
      }
      isFinished = true;

      var marks = _participant.split!.marks!;

      participantJSON = jsonEncode({
        'name': _participant.name,
        'surname': _participant.surname,
        'number_chip': _participant.chip,
        'start': startTime?.toIso8601String(),
        'finish': finishTime.toIso8601String(),
        'count_cp': marks.length,
      });

      List<Map> listMap = List<Map>.empty(growable: true);
      var kyeTime = startTime ?? finishTime;

      for (int i = 0; i < marks.length; i++) {
        // Добавляем по размеру [stepSize]
        if (i > 0 && (i % stepSize) == 0) {
          participantResult.add(jsonEncode(listMap));
          listMap.clear();
        }

        // Если время от старта, то положительное будет
        // иначе отрицательное.
        var deltaTime = marks[i].time.difference(kyeTime);

        listMap.add({marks[i].info: deltaTime.inMilliseconds});
      }
      if (listMap.isNotEmpty) {
        participantResult.add(jsonEncode(listMap));
        listMap.clear();
      }

      isGeted = true;
    }
    isLoading = false;
  }
}
