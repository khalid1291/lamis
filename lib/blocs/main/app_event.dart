part of 'app_bloc.dart';

abstract class AppEvent {}

class FetchAppData extends AppEvent {
  ///for test
  Connectivity? connectivity;
  FetchAppData({this.connectivity});
}

class EndDemo extends AppEvent {}

class StartTutorial extends AppEvent {}

class ContinueAsGuest extends AppEvent {}

class EndTutorial extends AppEvent {}
