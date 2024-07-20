part of 'update_map_location_cubit.dart';

abstract class UpdateMapLocationState {}

class UpdateMapLocationInitial extends UpdateMapLocationState {}

class UpdateMapLocationLoading extends UpdateMapLocationState {}

class UpdateMapLocationDone extends UpdateMapLocationState {
  final GeneralResponse response;

  UpdateMapLocationDone(this.response);
}

class UpdateMapLocationError extends UpdateMapLocationState {
  final String message;

  UpdateMapLocationError(this.message);
}
