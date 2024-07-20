import 'dart:io' show Platform;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/models/general/general_settings.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../repos/repos.dart';
import '../../cubits/cubits.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AppRepo appRepo;

  AppBloc({required this.appRepo}) : super(AppInitial()) {
    on<FetchAppData>((event, emit) async {
      emit(AppLoading());
      ThemeType themeType = await appRepo.loadTheme();

      bool isLoggedIn = await appRepo.loadIsLoggedIn();

      bool isFirstTimeAppOpened = await appRepo.loadFirstTimeAppOpened();

      bool showTutorial = await appRepo.loadShowTutorial();

      bool appOutDated = await appRepo.loadAppOutdated();

      String appLanguage = await appRepo.loadAppLanguage();

      if (Platform.isAndroid) {
        if (Platform.environment.containsKey('FLUTTER_TEST')) {
          var connectivityResult =
              await (FetchAppData().connectivity?.checkConnectivity());
          if (connectivityResult == ConnectivityResult.none) {
            emit(AppOffline());
            return;
          }
        } else {
          try {
            var connectivityResult = await (Connectivity().checkConnectivity());
            if (connectivityResult == ConnectivityResult.none) {
              emit(AppOffline());
              return;
            }
          } catch (e) {
            if (kDebugMode) {
              print("could not check connectivity");
            }
          }
        }
      }
      if (appOutDated) {
        emit(AppOutdated());
      } else if (isFirstTimeAppOpened) {
        try {
          GeneralSettings generalSettings = await appRepo.getGeneralSettings();
          emit(AppDemo(themeType: themeType, generalSettings: generalSettings));
        } catch (e) {
          emit(AppOffline());
        }
      } else if (showTutorial) {
        emit(ShowTutorial(
          appLanguage: appLanguage,
          isLoggedIn: isLoggedIn,
          themeType: themeType,
        ));
      } else {
        emit(AppReady(
            themeType: themeType,
            isLoggedIn: isLoggedIn,
            appLanguage: appLanguage,
            showTutorial: false));
      }
    });

    on<ContinueAsGuest>((event, emit) async {
      emit(ShowLogin());
    });

    on<EndDemo>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppRepo.isFirstOpenKey, false);
      bool showTutorial = await appRepo.loadShowTutorial();
      bool isLoggedIn = await appRepo.loadIsLoggedIn();
      String appLanguage = await appRepo.loadAppLanguage();

      emit(AppReady(
          isLoggedIn: isLoggedIn,
          themeType: ThemeType.auto,
          appLanguage: appLanguage,
          showTutorial: showTutorial));
    });
    on<EndTutorial>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppRepo.isTutorialShow, false);
      String appLanguage = await appRepo.loadAppLanguage();

      emit(AppReady(
          isLoggedIn: false,
          themeType: ThemeType.auto,
          appLanguage: appLanguage,
          showTutorial: false));
    });
    on<StartTutorial>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppRepo.isTutorialShow, true);
      ThemeType themeType = await appRepo.loadTheme();
      bool isLoggedIn = await appRepo.loadIsLoggedIn();
      String appLanguage = await appRepo.loadAppLanguage();

      emit(ShowTutorial(
          themeType: themeType,
          isLoggedIn: isLoggedIn,
          appLanguage: appLanguage));
    });
  }
}
