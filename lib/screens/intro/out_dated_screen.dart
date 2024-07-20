import 'package:flutter/material.dart';
import '../../res/resources_export.dart';
import '../../widgets/widgets.dart';

class OutDatedScreen extends StatelessWidget {
  const OutDatedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(context.resources.dimension.bigMargin),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: context.resources.dimension.bigMargin,
            ),
            SizedBox(
              height: context.resources.dimension.largeContainerSize,
              width: context.resources.dimension.largeContainerSize,
              child: Image(
                image: AssetImage(context.resources.strings.appOutDated),
                fit: BoxFit.fitWidth,
              ),
            ),
            Center(
              child: CustomText(
                content: context.resources.strings.appOutDated,
                color: Theme.of(context).colorScheme.primaryTextColor,
                titletype: TitleType.headline,
                language: Language.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
