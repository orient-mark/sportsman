// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeState on HomeStateBase, Store {
  late final _$participantAtom =
      Atom(name: 'HomeStateBase.participant', context: context);

  @override
  Participant get participant {
    _$participantAtom.reportRead();
    return super.participant;
  }

  bool _participantIsInitialized = false;

  @override
  set participant(Participant value) {
    _$participantAtom.reportWrite(
        value, _participantIsInitialized ? super.participant : null, () {
      super.participant = value;
      _participantIsInitialized = true;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'HomeStateBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$isGetedAtom =
      Atom(name: 'HomeStateBase.isGeted', context: context);

  @override
  bool get isGeted {
    _$isGetedAtom.reportRead();
    return super.isGeted;
  }

  @override
  set isGeted(bool value) {
    _$isGetedAtom.reportWrite(value, super.isGeted, () {
      super.isGeted = value;
    });
  }

  late final _$getParticipantAsyncAction =
      AsyncAction('HomeStateBase.getParticipant', context: context);

  @override
  Future<void> getParticipant() {
    return _$getParticipantAsyncAction.run(() => super.getParticipant());
  }

  late final _$setParticipantAsyncAction =
      AsyncAction('HomeStateBase.setParticipant', context: context);

  @override
  Future<void> setParticipant(String name, String surname, int chip) {
    return _$setParticipantAsyncAction
        .run(() => super.setParticipant(name, surname, chip));
  }

  @override
  String toString() {
    return '''
participant: ${participant},
isLoading: ${isLoading},
isGeted: ${isGeted}
    ''';
  }
}
