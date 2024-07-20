import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/res/resources_export.dart';

import 'package:shared_preferences/shared_preferences.dart';

enum ThemeType { auto, dark, light, blue } //1 for auto,2 for dark ,3 for light

enum ThemeName { dark, light, blue } //1 for auto,2 for dark ,3 for light

class ThemeDataObject {
  ThemeData firstTheme = lightTheme;
  ThemeData secondaryTheme = darkTheme;
  ThemeMode themeMode = ThemeMode.system;
  ThemeName themeName = ThemeName.light;
  ThemeType themeType = ThemeType.auto;
}

class CurrentThemeCubit extends Cubit<ThemeDataObject> {
  ThemeData firstTheme = darkTheme;
  ThemeData secondaryTheme = darkTheme;

  CurrentThemeCubit(ThemeDataObject initialState) : super(initialState);

  Future<void> changeTheme(ThemeType theme) async {
    SharedPreferences sp;
    ThemeDataObject themes = ThemeDataObject();

    sp = await SharedPreferences.getInstance();
    switch (theme) {
      case ThemeType.dark:
        {
          themes.firstTheme = darkTheme;
          themes.secondaryTheme = darkTheme;
          themes.themeMode = ThemeMode.dark;
          themes.themeName = ThemeName.dark;
          themes.themeType = ThemeType.dark;
          firstTheme = darkTheme;
          secondaryTheme = darkTheme;
          ColorSchemeExtension.theme = 'dark';
          AppImage.theme = 'dark';
          emit(themes);
          sp.setInt("theme_number", 2);
        }
        break;
      case ThemeType.auto:
        {
          var brightness = SchedulerBinding.instance.window.platformBrightness;
          bool isDarkMode = brightness == Brightness.dark;
          if (isDarkMode) {
            themes.firstTheme = lightTheme;
            themes.secondaryTheme = darkTheme;
            themes.themeMode = ThemeMode.system;
            themes.themeName = ThemeName.dark;
            themes.themeType = ThemeType.auto;

            // this.firstTheme = lightTheme;
            // this.secendryTheme = darkTheme;
            // ColorSchemeExtension.theme = themes;

            ColorSchemeExtension.theme = 'dark';
            AppImage.theme = 'dark';

            emit(themes);
          } else {
            themes.firstTheme = lightTheme;
            themes.secondaryTheme = darkTheme;
            themes.themeMode = ThemeMode.system;
            themes.themeName = ThemeName.light;
            themes.themeType = ThemeType.auto;
            // ColorSchemeExtension.theme = themes;
            ColorSchemeExtension.theme = 'light';
            AppImage.theme = 'light';

            emit(themes);
          }
          sp.setInt("theme_number", 1);
        }
        break;
      case ThemeType.light:
        {
          themes.firstTheme = lightTheme;
          themes.secondaryTheme = lightTheme;
          themes.themeMode = ThemeMode.light;
          themes.themeName = ThemeName.light;
          themes.themeType = ThemeType.light;
          // ColorSchemeExtension.theme = themes;
          ColorSchemeExtension.theme = 'light';
          AppImage.theme = 'light';

          emit(themes);
          sp.setInt("theme_number", 3);
        }
        break;
      case ThemeType.blue:
        themes.firstTheme = blueTheme;
        themes.secondaryTheme = blueTheme;
        themes.themeName = ThemeName.blue;
        themes.themeType = ThemeType.blue;
        // ColorSchemeExtension.theme = themes;
        ColorSchemeExtension.theme = 'blue';
        AppImage.theme = 'blue';

        emit(themes);
        sp.setInt("theme_number", 4);
        break;
    }
    // emit(null);
  }

  ThemeName getThemeName() {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    if (isDarkMode) {
      return ThemeName.dark;
    }
    return ThemeName.light;
  }
}
