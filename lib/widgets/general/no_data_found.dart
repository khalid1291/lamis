import 'package:flutter/material.dart';
import 'package:lamis/res/resources_export.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: context.resources.dimension.largeContainerSize,
        width: context.resources.dimension.largeContainerSize,
        child: Image(
          image: AssetImage(
            context.resources.images.noDataImage,
          ),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
