import 'package:flutter/material.dart';

import 'base_colors.dart';

class AppColors implements BaseColors {
  // Map<int, Color> _primary = {
  //   50: Color.fromRGBO(22, 134, 206, 0.1),
  //   100: Color.fromRGBO(22, 134, 206, 0.2),
  //   200: Color.fromRGBO(22, 134, 206, 0.3),
  //   300: Color.fromRGBO(22, 134, 206, 0.4),
  //   400: Color.fromRGBO(22, 134, 206, 0.5),
  //   500: Color.fromRGBO(22, 134, 206, 0.6),
  //   600: Color.fromRGBO(22, 134, 206, 0.7),
  //   700: Color.fromRGBO(22, 134, 206, 0.8),
  //   800: Color.fromRGBO(22, 134, 206, 0.9),
  //   900: Color.fromRGBO(22, 134, 206, 1.0),
  // };

  @override
  MaterialColor get colorAccent => Colors.amber;

  // @override
  // MaterialColor get colorPrimary => MaterialColor(0xff1686ce, _primary);
  // @override
  // MaterialColor get colorPrimaryDark => MaterialColor(0xff000000, _primary);
  @override
  Color get colorPrimaryTextDark => const Color(0xffffffff);

  @override
  Color get colorPrimaryText => const Color(0xff49ABFF);

  @override
  Color get colorSecondaryText => const Color(0xff3593FF);

  @override
  Color get colorWhite => const Color(0xffffffff);

  @override
  Color get colorBlack => const Color(0xff000000);

  @override
  Color get castChipColor => Colors.deepOrangeAccent;

  @override
  Color get catChipColor => Colors.indigoAccent;

  @override
  Color get primaryColor => throw UnimplementedError();
}

extension ColorSchemeExtension on ColorScheme {
  // static ThemeDataObject theme = ThemeDataObject();

  static String theme = '';

  ///background color for most of the pages
  Color get scaffoldColor {
    switch (theme) {
      case 'dark':
        return const Color(0xFF1D2333);

      case 'light':
        return const Color(0xFFF8F8F8);

      default:
        {
          return const Color(0xFFFfffff);
        }
    }
  }

  Color get homeScreen {
    switch (theme) {
      case 'dark':
        return const Color(0xFF1D2333);

      case 'light':
        return const Color(0xFFFfffff);

      default:
        {
          return const Color(0xFFFfffff);
        }
    }
  }

  ///this is the primary color for the application
  Color get lamisColor {
    switch (theme) {
      case 'dark':
        return const Color(0xFF109dcd);

      case 'light':
        return const Color(0xFF108DCD);

      // case 'blue':
      //   return const Color(0xFF2E3BAF);
      default:
        {
          return const Color(0xFF108DCD);
        }
    }
  }

  Color get productColor {
    switch (theme) {
      case 'dark':
        return const Color(0xFF222939);

      case 'light':
        return const Color(0xFFffffff);

      // case 'blue':
      //   return const Color(0xFF2E3BAF);
      default:
        {
          return const Color(0xFFffffff);
        }
    }
  }

  Color get shadowColor {
    switch (theme) {
      case 'dark':
        return const Color(0xffffffff);
      case 'light':
        return const Color.fromRGBO(73, 73, 73, 1);

      default:
        {
          return const Color.fromRGBO(73, 73, 73, 1);
        }
    }
  }

  Color get shadow400 {
    switch (theme) {
      case 'dark':
        return const Color(0xff0f101a);
      case 'light':
        return Colors.grey[400]!;

      default:
        {
          return Colors.grey[400]!;
        }
    }
  }

  Color get shadow100 {
    switch (theme) {
      case 'dark':
        return const Color(0xFF1D2333);
      case 'light':
        return Colors.grey[100]!;

      default:
        {
          return Colors.grey[100]!;
        }
    }
  }

  Color get shadow200 {
    switch (theme) {
      case 'dark':
        return const Color(0xff0f101a);
      case 'light':
        return Colors.grey[200]!;

      default:
        {
          return Colors.grey[200]!;
        }
    }
  }

  Color get subText {
    switch (theme) {
      case 'dark':
        return const Color(0xFFA6A2A2);
      case 'light':
        return const Color(0xFFA6A2A2);

      default:
        {
          return const Color(0xFFC4C4C4);
        }
    }
  }

  Color get toastBackGround {
    switch (theme) {
      case 'dark':
        return const Color(0xFF2B3147);
      case 'light':
        return const Color(0xFFE4ECEE);

      default:
        {
          return const Color(0xFFE4ECEE);
        }
    }
  }

  Color get selectedBorder {
    switch (theme) {
      case 'dark':
        return const Color(0xFF8888ff);
      case 'light':
        return const Color(0xFF222244);

      default:
        {
          return const Color(0xFF222244);
        }
    }
  }

  Color get border {
    switch (theme) {
      case 'dark':
        return const Color(0xFF66889d);
      case 'light':
        return const Color(0xFF224450);
      default:
        {
          return const Color(0xFF224450);
        }
    }
  }

  Color get background {
    switch (theme) {
      case 'dark':
        return const Color(0xFF434B60);
      case 'light':
        return const Color(0xFFAAAACA);

      default:
        {
          return const Color(0xFFAAAACA);
        }
    }
  }

  Color get greenColor {
    switch (theme) {
      case 'dark':
        return const Color(0xFF33bb3E);
      case 'light':
        return const Color(0xFF25C83F);

      default:
        {
          return const Color(0xFF25C83F);
        }
    }
  }

  Color get yellowColor {
    switch (theme) {
      case 'dark':
        return const Color(0xFFF3B42E);
      case 'light':
        return const Color(0xFFF9D062);

      default:
        {
          return const Color(0xFFF9D062);
        }
    }
  }

  Color get redColor {
    switch (theme) {
      case 'dark':
        return const Color(0xFFE40606);
      case 'light':
        return const Color(0xFFE40606);
      default:
        {
          return const Color(0xFFE40606).withOpacity(0.85);
        }
    }
  }

  Color get disabledColor {
    switch (theme) {
      case 'dark':
        return const Color(0xFFB5B5B5);
      case 'light':
        return const Color(0xFFB5B5B5);
      default:
        {
          return const Color(0xFFB5B5B5);
        }
    }
  }

  Color get cardColor {
    switch (theme) {
      case 'dark':
        return const Color(0xFF2B3147);
      case 'light':
        return const Color(0xffECF2F6);
      default:
        {
          return const Color(0xff222222);
        }
    }
  }

  /// do not use this color its only for the background color
  Color get colorForBubbles {
    switch (theme) {
      case 'dark':
        return const Color(0xFF66889d);
      case 'light':
        return const Color(0xFFDDE9EF);

      default:
        {
          return const Color(0xFFDDE9EF);
        }
    }
  }

  Color get primaryTextColor {
    switch (theme) {
      case 'dark':
        return const Color(0xFFFFFFFF);
      case 'light':
        return const Color(0xff05293B);
      default:
        {
          return const Color(0xff05293B);
        }
    }
  }

  Color get iconColor {
    switch (theme) {
      case 'dark':
        return const Color(0xFF109dcd);
      case 'light':
        return const Color(0xFF094E72);
      default:
        {
          return const Color(0xFF094E72);
        }
    }
  }

  Color get ordersIcon {
    switch (theme) {
      case 'dark':
        return const Color(0xFFffffff);
      case 'light':
        return const Color(0xFF094E72);
      default:
        {
          return const Color(0xFF094E72);
        }
    }
  }

  Color get drawerColor {
    switch (theme) {
      case 'dark':
        return const Color(0xFF1D2333);
      case 'light':
        return const Color(0xFFF5F5F5);
      default:
        {
          return const Color(0xFFF5F5F5);
        }
    }
  }

  Color get dropDownColor {
    switch (theme) {
      case 'dark':
        return const Color(0xFF1C1E20);
      case 'light':
        return const Color(0xFFEFEFEF);
      default:
        {
          return const Color(0xFF1C1E20);
        }
    }
  }

  Color get mainGradientFirst {
    switch (theme) {
      case 'dark':
        return const Color(0xFF1D2333);

      case 'light':
        return const Color(0xFFBBE4FA);

      // case 'blue':
      //   return const Color(0xFF2E3BAF);
      default:
        {
          return const Color(0xFFBBE4FA);
        }
    }
  }

  Color get mainGradientSecond {
    switch (theme) {
      case 'dark':
        return const Color(0xFF2B3147);

      case 'light':
        return const Color(0xFF0D74A9);

      // case 'blue':
      //   return const Color(0xFF2E3BAF);
      default:
        {
          return const Color(0xFF0D74A9);
        }
    }
  }

  Color get cartColor {
    switch (theme) {
      case 'dark':
        return const Color(0xFFECF2F6);

      case 'light':
        return const Color(0xFFECF2F6);

      // case 'blue':
      //   return const Color(0xFF2E3BAF);
      default:
        {
          return const Color(0xFFECF2F6);
        }
    }
  }

  Color get userInfoCard {
    switch (theme) {
      case 'dark':
        return const Color(0xFF423F3F);

      case 'light':
        return const Color(0xFF423F3F);

      // case 'blue':
      //   return const Color(0xFF2E3BAF);
      default:
        {
          return const Color(0xFF423F3F);
        }
    }
  }

  Color get drawerLayerOne {
    switch (theme) {
      case 'dark':
        return const Color(0xFF1D2333).withOpacity(0.6);

      case 'light':
        return const Color(0xFF9CD1EB).withOpacity(1);

      default:
        {
          return const Color(0xFF9CD1EB).withOpacity(1);
        }
    }
  }

  Color get darkBlue {
    switch (theme) {
      case 'dark':
        return const Color(0xFF00ACEC);

      case 'light':
        return const Color(0xFF001EA4);

      default:
        {
          return const Color(0xFF001EA4);
        }
    }
  }

  Color get lightBlue {
    switch (theme) {
      case 'dark':
        return const Color(0xFF00ACEC);

      case 'light':
        return const Color(0xFF00ACEC);

      default:
        {
          return const Color(0xFF00ACEC);
        }
    }
  }

  Color get drawerLayerTow {
    switch (theme) {
      case 'dark':
        return const Color(0xFF434B60).withOpacity(0.5);

      case 'light':
        return const Color(0xff108DCD).withOpacity(0.1);

      // case 'blue':
      //   return const Color(0xFF2E3BAF);
      default:
        {
          return const Color(0xff108DCD).withOpacity(0.1);
        }
    }
  }

  Color get drawerLayerThree {
    switch (theme) {
      case 'dark':
        return const Color(0xFF434B60).withOpacity(0);

      case 'light':
        return const Color(0xff72C3ED).withOpacity(0.25);

      // case 'blue':
      //   return const Color(0xFF2E3BAF);
      default:
        {
          return const Color(0xff72C3ED).withOpacity(0.25);
        }
    }
  }

  List<Color> get blueShadeLiner {
    switch (theme) {
      case 'dark':
        return [
          const Color(0xFF2B3147),
          const Color(0xFF2B3147),
          const Color(0xFF2B3147),
          const Color(0xFF1D2333),
          const Color(0xFF1D2333)
        ];
      case 'light':
        return [
          const Color(0xFFD6E3E5),
          const Color(0xFFE8EEF0),
          const Color(0xFFEEF3F4),
          const Color(0xFFFCFCFB),
          const Color(0xFFFFFFFF)
        ];
      default:
        {
          return [
            const Color(0xFFe4eaf0),
            const Color(0xFFe4e4f0),
            const Color(0xFFEEF3F4),
            const Color(0xFFFCFCFB),
            const Color(0xFFFFFFFF)
          ];
        }
    }
  }

  List<Color> get blueLiner {
    switch (theme) {
      case 'dark':
        return [
          const Color(0xFF1D2333),
          const Color(0xFF1D2333),
          const Color(0xFF2B3147),
          const Color(0xFF2B3147),
          const Color(0xFF2B3147),
        ];
      case 'light':
        return [
          const Color(0xFF89D3F6),
          const Color(0xFF54B8E8),
          const Color(0xFF47A5D3),
          const Color(0xFF3890BA),
          const Color(0xFF008FD3)
        ];
      default:
        {
          return [
            const Color(0xFF89D3F6),
            const Color(0xFF54B8E8),
            const Color(0xFF47A5D3),
            const Color(0xFF3890BA),
            const Color(0xFF008FD3)
          ];
        }
    }
  }

  List<Color> get grayShadeLiner {
    switch (theme) {
      case 'dark':
        return [
          const Color(0xFF2B3147),
          const Color(0xFF2B3147),
          const Color(0xFF2B3147),
          const Color(0xFF1D2333),
          const Color(0xFF1D2333)
        ];
      case 'light':
        return [
          const Color(0xFFE5DFD6),
          const Color(0xFFE7E2D9),
          const Color(0xFFF4F2EE),
          const Color(0xFFFCFCFB),
          const Color(0xFFFFFFFF)
        ];
      default:
        {
          return [
            const Color(0xFFE5DFD6),
            const Color(0xFFE7E2D9),
            const Color(0xFFF4F2EE),
            const Color(0xFFFCFCFB),
            const Color(0xFFFFFFFF)
          ];
        }
    }
  }
// Color get  => this.brightness == Brightness.light
//       ?  const Color(0xFF001EA4)
//       :  const Color(0xFFE3E3E1);
}
