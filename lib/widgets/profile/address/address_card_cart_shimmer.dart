import 'package:flutter/material.dart';

import '../../../widgets/widgets.dart';
import '../../../res/resources_export.dart';

class AddressCardShimmer extends StatelessWidget {
  const AddressCardShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(
            vertical: context.resources.dimension.mediumMargin),
        padding: EdgeInsets.symmetric(
            vertical: context.resources.dimension.mediumMargin),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: const [ShimmerContainer()],
            ),
            Row(
              children: const [ShimmerContainer()],
            ),
            Row(
              children: const [ShimmerContainer()],
            ),
            Row(
              children: const [ShimmerContainer()],
            ),
            Row(
              children: const [ShimmerContainer()],
            ),
            Row(
              children: const [ShimmerContainer()],
            ),
          ],
        ).customMargins());
  }
}
