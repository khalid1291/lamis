part of 'get_states_cubit.dart';

abstract class GetStatesState {}

class GetStatesInitial extends GetStatesState {}

class GetStatesLoading extends GetStatesState {}

class GetStatesDone extends GetStatesState {
  final MyStateResponse response;

  GetStatesDone(this.response);
}

class GetStatesError extends GetStatesState {
  final String message;

  GetStatesError(this.message);
}
