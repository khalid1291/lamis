part of 'app_bloc.dart';

@immutable
abstract class AppState {}

class AppInitial extends AppState {}

class AppLoading extends AppState {}

class AppOffline extends AppState {}

class AppDemo extends AppState {
  final ThemeType themeType;
  final GeneralSettings generalSettings;
  AppDemo({required this.themeType, required this.generalSettings});
}

class ShowTutorial extends AppState {
  final bool isLoggedIn;
  final String appLanguage;

  final ThemeType themeType;

  ShowTutorial(
      {required this.themeType,
      required this.isLoggedIn,
      required this.appLanguage});
}

class ShowLogin extends AppState {}

class AppReady extends AppState {
  final bool isLoggedIn;
  final bool showTutorial;

  final ThemeType themeType;
  final String appLanguage;

  AppReady(
      {required this.themeType,
      required this.isLoggedIn,
      required this.appLanguage,
      required this.showTutorial});
}

class AppOutdated extends AppState {}
