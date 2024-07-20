import 'package:flutter/material.dart';
import 'package:lamis/res/app_context_extension.dart';
import 'package:lamis/res/colors/app_colors.dart';
import '../../widgets/widgets.dart';

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.resources.dimension.smallContainerSize,
      child: GridView.builder(
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Chip(
            padding: EdgeInsets.only(
                bottom: context.resources.dimension.verySmallMargin),
            backgroundColor:
                Theme.of(context).colorScheme.lamisColor.withOpacity(0.3),
            label: SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: CustomText(
                  content: "",
                  color: Theme.of(context).colorScheme.scaffoldColor,
                  language: Language.center,
                )),
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.2),
      ),
    );
  }
}
