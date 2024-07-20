part of 'counters_cubit.dart';

abstract class CountersState {}

class CountersInitial extends CountersState {}

class CountersLoading extends CountersState {}

class CountersDone extends CountersState {
  final ProfileCountersResponse profileCountersResponse;

  CountersDone({required this.profileCountersResponse});
}

class CountersError extends CountersState {}
