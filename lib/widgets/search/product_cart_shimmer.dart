import 'package:flutter/material.dart';
import 'package:lamis/res/resources_export.dart';

import '../../screens/screens.dart';
import '../general/delayed_animation.dart';

class ProductCartShimmer extends StatelessWidget {
  const ProductCartShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const FixedHieght(),
          GridView.builder(
              itemCount: 2,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.618),
              itemBuilder: (context, index) {
                return DelayedAnimation(
                  delay: index * 100,
                  fromSide: FromSide.bottom,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          context.resources.dimension.bigMargin),
                      color: Theme.of(context)
                          .colorScheme
                          .lamisColor
                          .withOpacity(0.3),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
