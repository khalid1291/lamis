part of 'change_country_cubit.dart';

abstract class ChangeCountryState {}

class ChangeCountryInitial extends ChangeCountryState {}

class ChangeCountryLoading extends ChangeCountryState {}

class ChangeCountryDone extends ChangeCountryState {
  final GeneralResponse response;

  ChangeCountryDone(this.response);
}

class ChangeCountryError extends ChangeCountryState {
  final String message;

  ChangeCountryError(this.message);
}
