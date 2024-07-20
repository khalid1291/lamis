import '../../../../cubits/cubits.dart';

class SwitchState {
  final int themeNumber;
  ThemeType theme = ThemeType.auto;
  SwitchState({required this.themeNumber}) {
    switch (themeNumber) {
      case 0:
        theme = ThemeType.auto;

        break;
      case 1:
        theme = ThemeType.dark;

        break;
      case 2:
        theme = ThemeType.light;
    }
  }
}
