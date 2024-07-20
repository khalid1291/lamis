import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lamis/res/app_context_extension.dart';
import 'package:lamis/res/colors/app_colors.dart';

import '../widgets.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.onPress,
      required this.content,
      this.red = false})
      : super(key: key);
  final Function onPress;
  final String content;
  final bool red;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        onPress();
        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   return const CheckoutScreen();
        // }));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: context.resources.dimension.extraHighElevation),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  context.resources.dimension.defaultMargin),
              color: red
                  ? Theme.of(context).colorScheme.redColor
                  : Theme.of(context).colorScheme.lamisColor),
          child: SizedBox(
            height: 65,
            width: MediaQuery.of(context).size.width * 0.66,
            child: Center(
              child: CustomText(
                content: content,
                titletype: TitleType.bottoms,
                color: context.resources.color.colorWhite,
                language: Language.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
