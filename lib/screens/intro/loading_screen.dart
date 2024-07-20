import 'package:flutter/material.dart';

import '../../res/resources_export.dart';

import '../../widgets/widgets.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      title: '',
      children: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: context.resources.dimension.largeContainerSize,
          ),
          SizedBox(
            height: context.resources.dimension.largeContainerSize,
            width: context.resources.dimension.largeContainerSize,
            child: Image(
              image: AssetImage(
                context.resources.images.familyImage,
              ),
              fit: BoxFit.fitWidth,
            ),
          ),
          Center(
              child: LinearProgressIndicator(
            color: Theme.of(context).colorScheme.lamisColor,
          )),
          const Spacer(),
          SizedBox(
            height: context.resources.dimension.middleContainerSize,
            width: context.resources.dimension.largeContainerSize,
            child: Image(
              image: AssetImage(
                context.resources.images.cleaningImage,
              ),
              fit: BoxFit.fitWidth,
            ),
          ),
          const Spacer(),
        ],
      ).customMargins(),
    );
  }
}
