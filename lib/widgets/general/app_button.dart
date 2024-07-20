import 'package:flutter/material.dart';

import '../../res/resources_export.dart';
import '../../widgets/widgets.dart';

enum ButtonSize { big, medium, small }

class AppButton extends StatelessWidget {
  const AppButton(
      {Key? key,
      required this.onTap,
      required this.buttonText,
      this.color,
      this.buttonSize = ButtonSize.medium,
      this.textColor,
      this.padding = 8.0,
      this.isCountry = false,
      this.widget,
      this.isEnabled = true})
      : super(key: key);

  final GestureTapCallback onTap;
  final String buttonText;
  final Color? color;
  final Color? textColor;
  final ButtonSize buttonSize;
  final double padding;
  final bool isCountry;
  final Widget? widget;
  final bool isEnabled;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: GestureDetector(
        onTap: isEnabled ? onTap : () {},
        child: Container(
          width: getWidth(),
          height: 40.0,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: color ?? Theme.of(context).colorScheme.lamisColor,
            boxShadow: [
              BoxShadow(
                  spreadRadius: 0.2,
                  blurRadius: 9,
                  offset: const Offset(0, 5),
                  color: Theme.of(context)
                      .colorScheme
                      .shadowColor
                      .withOpacity(0.2))
            ],
            borderRadius:
                BorderRadius.circular(context.resources.dimension.mediumMargin),
          ),
          child: isCountry
              ? widget
              : Center(
                  child: CustomText(
                    content: buttonText,
                    language: Language.center,
                    color: textColor ?? Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  double getWidth() {
    switch (buttonSize) {
      case ButtonSize.big:
        return 200;
      case ButtonSize.medium:
        return 150;
      case ButtonSize.small:
        return 80;
      default:
        return 60;
    }
  }
}
