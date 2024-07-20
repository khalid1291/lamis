part of "point_history_cubit.dart";

@immutable
abstract class PointHistoryState {}

class PointHistoryInitial extends PointHistoryState {}

class PointHistoryLoading extends PointHistoryState {}

class PointHistoryPagination extends PointHistoryState {}

class PointHistoryDone extends PointHistoryState {
  final ClubPointResponse clubPointResponse;
  PointHistoryDone({required this.clubPointResponse});
}

class PointHistoryError extends PointHistoryState {
  final String errorMessage;
  PointHistoryError({required this.errorMessage});
}
