import 'package:flutter/material.dart';

import '../resources_export.dart';

var appColor = AppColors();
var lightTheme = ThemeData(
  useMaterial3: false,
  primaryColor: Colors.black,
  colorScheme: ColorScheme.fromSwatch().copyWith(
      background: const Color(0xffECF2F6), brightness: Brightness.light),
);

var darkTheme = ThemeData(
  useMaterial3: false,
  primaryColor: Colors.white,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSwatch().copyWith(
      background: const Color(0xFF2B3147), brightness: Brightness.dark),
);
var blueTheme = ThemeData(
  useMaterial3: false,
  primaryColor: const Color(0xFF2E3BAF),
);

extension LightThemeEx on ThemeData {
  Color get appSubTitleColor {
    return const Color(0xFF5F6368);
  }
}
