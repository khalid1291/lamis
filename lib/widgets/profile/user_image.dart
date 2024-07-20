import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../data/remote/network/base_api_service.dart';
import '../../res/resources_export.dart';

class UserImage extends StatelessWidget {
  const UserImage({Key? key, required this.userImage}) : super(key: key);
  final String userImage;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: context.resources.dimension.defaultMargin,
          left: context.resources.dimension.defaultMargin,
          bottom: context.resources.dimension.smallMargin),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.height * 0.2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: userImage != BaseApiService.imagesRoute
              ? FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: userImage,
                  fit: BoxFit.fill,
                  imageErrorBuilder: (context, object, stacktrace) {
                    return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        height: context.resources.dimension.bigMargin,
                        width: context.resources.dimension.bigMargin,
                        color: Theme.of(context).colorScheme.cardColor);
                  },
                )
              : Image.asset(
                  'assets/images/user_image_place_holder.png',
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
