part of 'get_countries_cubit.dart';

abstract class GetCountriesState {}

class GetCountriesInitial extends GetCountriesState {}

class GetCountriesLoading extends GetCountriesState {}

class GetCountriesDone extends GetCountriesState {
  final CountryResponse countryResponse;

  GetCountriesDone(this.countryResponse);
}

class GetCountriesError extends GetCountriesState {
  final String message;

  GetCountriesError(this.message);
}
