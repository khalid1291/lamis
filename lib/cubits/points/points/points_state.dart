part of 'points_cubit.dart';

@immutable
abstract class PointsState {}

class PointsInitial extends PointsState {}

class PointsLoading extends PointsState {}

class PointsPagination extends PointsState {}

class PointsDone extends PointsState {
  final MyPointsResponse myPointsResponse;
  PointsDone({required this.myPointsResponse});
}

class PointsError extends PointsState {
  final String errorMessage;
  PointsError({required this.errorMessage});
}
