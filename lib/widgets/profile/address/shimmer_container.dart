import 'package:flutter/material.dart';
import '../../../res/resources_export.dart';

class ShimmerContainer extends StatelessWidget {
  const ShimmerContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: context.resources.dimension.juniorElevation),
      width: MediaQuery.of(context).size.width / 2,
      height: context.resources.dimension.defaultMargin,
      color: Theme.of(context).colorScheme.lamisColor.withOpacity(0.2),
    );
  }
}
