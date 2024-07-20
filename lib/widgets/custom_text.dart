import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/cubits/cubits.dart';

enum TitleType { headline, body, subtitle, bottoms, time }

enum Language { rtl, ltr, center }

enum Typefont {
  amiri,
  raleway,
}

// ignore: must_be_immutable
class CustomText extends StatelessWidget {
  final Color? color;
  final TitleType? titletype;
  final Language? language;
  final Typefont? typefont;
  final String content;
  final int maxlines;
  final TextDecoration? textDecore;
  late BuildContext contexts;
  final double minTextSize;

  CustomText(
      {Key? key,
      this.color,
      this.titletype = TitleType.body,
      this.language = Language.ltr,
      this.typefont = Typefont.amiri,
      required this.content,
      this.textDecore = TextDecoration.none,
      this.minTextSize = 10,
      this.maxlines = 4})
      : super(key: key);

  AutoSizeText _eNLung(double width, FontWeight fontWeight, double widthChange,
      double minTextSize) {
    return AutoSizeText(content,
        overflow: TextOverflow.ellipsis,
        maxLines: maxlines,
        textAlign: TextAlign.left,
        minFontSize: minTextSize,
        stepGranularity: 2,
        style:
            contexts.watch<LocalizationCubit>().state == const Locale('ar', '')
                ? TextStyle(
                    letterSpacing: 0.2,
                    fontWeight: fontWeight,
                    fontSize: widthChange,
                    overflow: TextOverflow.visible,
                    color: color,
                    fontFamily: 'GeSsTow',
                    decoration: textDecore)
                : TextStyle(
                    letterSpacing: 0.2,
                    fontWeight: fontWeight,
                    fontSize: widthChange,
                    overflow: TextOverflow.visible,
                    color: color,
                    fontFamily: 'myriad',
                    decoration: textDecore)
        // style:
        //     contexts.watch<LocalizationCubit>().state == const Locale('ar', '')
        //         ? GoogleFonts.tajawal(
        //             textStyle: TextStyle(
        //                 letterSpacing: 0.2,
        //                 fontWeight: fontWeight,
        //                 fontSize: widthChange,
        //                 color: color,
        //                 // fontFamily: typefont == Typefont.raleway ? 'Raleway' : 'Amiri',
        //                 decoration: textDecore),
        //           )
        //         : GoogleFonts.ptSansNarrow(
        //             textStyle: TextStyle(
        //                 letterSpacing: 0.2,
        //                 fontWeight: fontWeight,
        //                 fontSize: widthChange,
        //                 color: color,
        //                 // fontFamily: typefont == Typefont.raleway ? 'Raleway' : 'Amiri',
        //                 decoration: textDecore),
        //           )
        // TextStyle(
        //     letterSpacing: 0.2,
        //     fontWeight: fontWeight,
        //     fontSize: widthChange,
        //     color: color,
        //     fontFamily: typefont == Typefont.raleway ? 'Raleway' : 'Amiri',
        //     decoration: textDecore),
        );
  }

  AutoSizeText _arLung(double width, FontWeight fontWeight, double widthChange,
      double minTextSize) {
    return AutoSizeText(content,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.right,
        maxLines: maxlines,
        stepGranularity: 2,
        minFontSize: minTextSize,
        style:
            contexts.watch<LocalizationCubit>().state == const Locale('ar', '')
                ? TextStyle(
                    letterSpacing: 0.2,
                    fontWeight: fontWeight,
                    fontSize: widthChange,
                    color: color,
                    overflow: TextOverflow.visible,
                    fontFamily: 'GeSsTow',
                    decoration: textDecore)
                : TextStyle(
                    letterSpacing: 0.2,
                    fontWeight: fontWeight,
                    fontSize: widthChange,
                    color: color,
                    fontFamily: 'myriad',
                    decoration: textDecore)
        // style:
        //     contexts.watch<LocalizationCubit>().state == const Locale('ar', '')
        //         ? GoogleFonts.tajawal(
        //             textStyle: TextStyle(
        //               letterSpacing: 0.2,
        //               decoration: textDecore,
        //               fontWeight: fontWeight,
        //               fontSize: widthChange,
        //               color: color,
        //               // fontFamily: typefont == Typefont.raleway ? 'Raleway' : 'Amiri',
        //             ),
        //           )
        //         : GoogleFonts.ptSansNarrow(
        //             textStyle: TextStyle(
        //               letterSpacing: 0.2,
        //               decoration: textDecore,
        //               fontWeight: fontWeight,
        //               fontSize: widthChange,
        //               color: color,
        //               // fontFamily: typefont == Typefont.raleway ? 'Raleway' : 'Amiri',
        //             ),
        //           )
        );
  }

  AutoSizeText _center(double width, FontWeight fontWeight, double widthChange,
      double minTextSize) {
    return AutoSizeText(content,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: maxlines,
        minFontSize: minTextSize,
        stepGranularity: 2,
        style:
            contexts.watch<LocalizationCubit>().state == const Locale('ar', '')
                ? TextStyle(
                    letterSpacing: 0.2,
                    fontWeight: fontWeight,
                    fontSize: widthChange,
                    color: color,
                    overflow: TextOverflow.visible,
                    fontFamily: 'GeSsTow',
                    decoration: textDecore)
                : TextStyle(
                    letterSpacing: 0.2,
                    fontWeight: fontWeight,
                    fontSize: widthChange,
                    color: color,
                    overflow: TextOverflow.visible,
                    fontFamily: 'myriad',
                    decoration: textDecore)
        // style:
        //     contexts.watch<LocalizationCubit>().state == const Locale('ar', '')
        //         ? GoogleFonts.tajawal(
        //             textStyle: TextStyle(
        //               letterSpacing: 0.6,
        //               fontWeight: fontWeight,
        //               fontSize: widthChange,
        //               decoration: textDecore,
        //               color: color,
        //               //fontFamily: typefont == Typefont.raleway ? 'Raleway' : 'Amiri',
        //             ),
        //           )
        //         : GoogleFonts.ptSansNarrow(
        //             textStyle: TextStyle(
        //               letterSpacing: 0.2,
        //               fontWeight: fontWeight,
        //               fontSize: widthChange,
        //               decoration: textDecore,
        //               color: color,
        //               //fontFamily: typefont == Typefont.raleway ? 'Raleway' : 'Amiri',
        //             ),
        //           )
        );
  }

  AutoSizeText _headlineTitle(double width) {
    switch (language!) {
      case Language.rtl:
        return _arLung(width, FontWeight.w600, 24, minTextSize);
      case Language.ltr:
        return _eNLung(width, FontWeight.w600, 24, minTextSize);
      case Language.center:
        return _center(width, FontWeight.w600, 24, minTextSize);
    }
  }

  AutoSizeText _bodyTitle(double width) {
    switch (language!) {
      case Language.rtl:
        return _arLung(width, FontWeight.w400, 12, minTextSize);
      case Language.ltr:
        return _eNLung(width, FontWeight.w400, 12, minTextSize);
      case Language.center:
        return _center(width, FontWeight.w400, 12, minTextSize);
    }
  }

  AutoSizeText _subtitle(double width) {
    switch (language!) {
      case Language.rtl:
        return _arLung(width, FontWeight.w600, 18, minTextSize);
      case Language.ltr:
        return _eNLung(width, FontWeight.w600, 18, minTextSize);
      case Language.center:
        return _center(width, FontWeight.w700, 22, minTextSize);
    }
  }

  AutoSizeText _bottom(double width) {
    switch (language!) {
      case Language.rtl:
        return MediaQuery.of(contexts).orientation == Orientation.portrait
            ? _arLung(width, FontWeight.w700, 14, minTextSize)
            : _arLung(width, FontWeight.normal, 18, minTextSize);
      case Language.ltr:
        return MediaQuery.of(contexts).orientation == Orientation.portrait
            ? _eNLung(width, FontWeight.w700, 14, minTextSize)
            : _eNLung(width, FontWeight.normal, 18, minTextSize);
      case Language.center:
        return MediaQuery.of(contexts).orientation == Orientation.portrait
            ? _center(width, FontWeight.w700, 15, minTextSize)
            : _center(width, FontWeight.normal, 18, minTextSize);
    }
  }

  AutoSizeText _time(double width) {
    switch (language!) {
      case Language.rtl:
        return _arLung(width, FontWeight.normal, 9, minTextSize);
      case Language.ltr:
        return _eNLung(width, FontWeight.normal, 9, minTextSize);
      case Language.center:
        return _center(width, FontWeight.w700, 9, minTextSize);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    contexts = context;

    switch (titletype!) {
      case TitleType.headline:
        return _headlineTitle(width);
      case TitleType.body:
        return _bodyTitle(width);
      case TitleType.subtitle:
        return _subtitle(width);
      case TitleType.bottoms:
        return _bottom(width);
      case TitleType.time:
        return _time(width);
    }
  }
}
