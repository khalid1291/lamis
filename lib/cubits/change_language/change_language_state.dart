part of 'change_language_cubit.dart';

abstract class ChangeLanguageState {}

class ChangeLanguageInitial extends ChangeLanguageState {}

class ChangeLanguageLoading extends ChangeLanguageState {}

class ChangeLanguageDone extends ChangeLanguageState {
  final GeneralResponse generalResponse;

  ChangeLanguageDone(this.generalResponse);
}

class ChangeLanguageError extends ChangeLanguageState {}
