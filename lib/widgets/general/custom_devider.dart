import 'package:flutter/material.dart';
import 'package:lamis/res/resources_export.dart';

class CustomDevider extends StatelessWidget {
  const CustomDevider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: context.resources.dimension.highElevation),
      child: Divider(
        color: Theme.of(context).colorScheme.lamisColor.withOpacity(0.4),
        height: context.resources.dimension.veryHighElevation,
      ),
    );
  }
}
