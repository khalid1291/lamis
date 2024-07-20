part of 'general_settings_cubit.dart';

abstract class GeneralSettingsState {}

class GeneralSettingsInitial extends GeneralSettingsState {}

class GeneralSettingsLoading extends GeneralSettingsState {}

class GeneralSettingsDone extends GeneralSettingsState {
  final GeneralSettings generalSettings;

  GeneralSettingsDone(this.generalSettings);
}

class GeneralSettingsError extends GeneralSettingsState {
  final String message;

  GeneralSettingsError(this.message);
}
