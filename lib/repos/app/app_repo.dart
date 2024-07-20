import 'package:flutter/foundation.dart';
import 'package:lamis/cubits/cubits.dart';
import 'package:lamis/data/remote/remote.dart';
import 'package:lamis/models/general/general_response.dart';
import 'package:lamis/models/general/general_settings.dart';
import 'package:lamis/models/general/notification_response.dart';
import 'package:lamis/models/general/social_links.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRepo {
  static const String themeKey = "theme_number";
  static const String isFirstOpenKey = "is_first_open";
  static const String isTutorialShow = "is_tutorial_show";
  static const String isLoggedInKey = "is_logged_in";
  static const String appLanguage = "app_language";
  final BaseApiService _apiService = NetworkApiService();

  bool showTutorial = true;
  Future<ThemeType> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? themeNumber = prefs.getInt(themeKey);

      switch (themeNumber) {
        case 1:
          {
            return ThemeType.auto;
          }
        case 2:
          {
            return ThemeType.dark;
          }
        case 3:
          {
            return ThemeType.light;
          }
        case 4:
          {
            return ThemeType.blue;
          }
        case null:
          {
            return ThemeType.auto;
          }
      }
    } catch (e) {
      if (kDebugMode) {
        print("the error is ${e.toString()}");
      }
    }
    return ThemeType.auto;
  }

  Future<bool> loadFirstTimeAppOpened() async {
    bool? firstTimeAppOpened;
    try {
      final prefs = await SharedPreferences.getInstance();
      firstTimeAppOpened = prefs.getBool(isFirstOpenKey);
    } catch (e) {
      if (kDebugMode) {
        print("this is the exception ${e.toString()}");
      }
    }
    return firstTimeAppOpened ?? true;
  }

  Future<bool> loadShowTutorial() async {
    bool? firstTimeShowTutorials;
    try {
      final prefs = await SharedPreferences.getInstance();
      firstTimeShowTutorials = prefs.getBool(isTutorialShow);
    } catch (e) {
      if (kDebugMode) {
        print("this is the exception ${e.toString()}");
      }
    }
    return firstTimeShowTutorials ?? true;
  }

  Future<bool> loadIsLoggedIn() async {
    bool? isLoggedIn;
    try {
      final prefs = await SharedPreferences.getInstance();
      isLoggedIn = prefs.getBool(isLoggedInKey);
    } catch (e) {
      if (kDebugMode) {
        print("the  exception is ${e.toString()}");
      }
    }

    return isLoggedIn ?? false;
  }

  Future<bool> loadAppOutdated() async {
    //Stub code
    return false;
  }

  Future<String> loadAppLanguage() async {
    String? isLoggedIn;
    try {
      final prefs = await SharedPreferences.getInstance();
      isLoggedIn = prefs.getString(appLanguage);
    } catch (e) {
      if (kDebugMode) {
        print("this is the exception ${e.toString()}");
      }
    }
    return isLoggedIn ?? 'ar';
  }

  Future<GeneralSettings> getGeneralSettings() async {
    try {
      dynamic response =
          await _apiService.getRequest(ApiEndPoints.generalSettings);
      return generalSettingsResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<SocialLinksResponse> getSocialLinks() async {
    try {
      dynamic response = await _apiService.getRequest(ApiEndPoints.socialLinks);
      return socialLinksResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralResponse> changelang(String lang) async {
    Map<String, String> body = {"language": lang};
    try {
      dynamic response = await _apiService.postRequestAuthenticated(
          ApiEndPoints.updateLang, body);
      return generalResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<NotificationResponse> getUserNotifications({page = 1}) async {
    try {
      dynamic response = await _apiService
          .getRequestAuthenticated("${ApiEndPoints.notification}?page=$page");
      return notificationsResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
