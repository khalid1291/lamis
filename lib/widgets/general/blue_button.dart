import 'package:flutter/material.dart';
import 'package:lamis/res/resources_export.dart';

import '../custom_text.dart';

class BlueButton extends StatelessWidget {
  const BlueButton({Key? key, required this.onTap, required this.content})
      : super(key: key);
  final GestureTapCallback onTap;
  final String content;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        height: context.resources.dimension.containerSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              context.resources.dimension.circularImageContainer),
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: Theme.of(context).colorScheme.blueLiner),
        ),
        child: Center(
          child: CustomText(
            content: content,
            color: context.resources.color.colorWhite,
            titletype: TitleType.bottoms,
          ),
        ),
      ),
    );
  }
}
