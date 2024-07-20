part of 'get_cities_cubit.dart';

abstract class GetCitiesState {}

class GetCitiesInitial extends GetCitiesState {}

class GetCitiesLoading extends GetCitiesState {}

class GetCitiesDone extends GetCitiesState {
  final CityResponse cityResponse;

  GetCitiesDone(this.cityResponse);
}

class GetCitiesError extends GetCitiesState {
  final String message;

  GetCitiesError(this.message);
}
