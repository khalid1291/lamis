import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../repos/repos.dart';

class LocalizationCubit extends Cubit<Locale> {
  LocalizationCubit(Locale initialState) : super(initialState);

  void changeLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    switch (language) {
      case 'de':
        await prefs.setString(AppRepo.appLanguage, language);
        UserRepo().language = 'de';
        emit(const Locale('de', ''));
        break;
      case 'en':
        await prefs.setString(AppRepo.appLanguage, language);
        UserRepo().language = 'en';
        emit(const Locale('en', ''));
        break;

      case 'ar':
        await prefs.setString(AppRepo.appLanguage, language);
        UserRepo().language = 'ar';
        emit(const Locale('ar', ''));
        break;
      default:
        await prefs.setString(AppRepo.appLanguage, language);
        UserRepo().language = 'ar';
        emit(const Locale('ar', ''));
    }
  }
}
