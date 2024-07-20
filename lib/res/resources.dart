import 'package:flutter/cupertino.dart';

import 'dimensions/app_dimension.dart';
import 'resources_export.dart';

class Resources {
  final BuildContext _context;

  Resources(this._context);

  Strings get strings {
    // It could be from the user preferences or even from the current locale
    Locale locale = Localizations.localeOf(_context);
    switch (locale.languageCode) {
      case 'ar':
        return ArabicStrings();
      default:
        return EnglishStrings();
    }
  }

  AppColors get color {
    return AppColors();
  }

  AppDimension get dimension {
    return AppDimension();
  }

  AppImage get images {
    return AppImage();
  }

  static Resources of(BuildContext context) {
    return Resources(context);
  }
}
