import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/models/models.dart';
import 'package:lamis/res/resources_export.dart';

import '../../cubits/cubits.dart';
import '../../screens/screens.dart';
import '../widgets.dart';

class ToDayDealCard extends StatelessWidget {
  const ToDayDealCard({Key? key, required this.response}) : super(key: key);

  final MiniProduct response;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetails(
            image: response.thumbnailImage,
            id: response.id,
          );
        }));
      },
      child: SizedBox(
        width: 170,
        height: 100,
        // decoration: BoxDecoration(),
        child: NeumorphismBrands(
          neumorphismType: NeumorphismType.todayDeal,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Container(
                      margin: EdgeInsets.only(
                          top: context.resources.dimension.mediumMargin),
                      //height: 158,
                      child: ClipRRect(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(17), bottom: Radius.zero),
                        child: CachedNetworkImage(
                            height: 140,
                            width: 130,
                            // imageUrl: "https://via.placeholder.com/350x200",
                            imageUrl: response.thumbnailImage,
                            fit: BoxFit.contain,
                            fadeOutDuration: const Duration(seconds: 1),
                            fadeInDuration: const Duration(seconds: 3),
                            errorWidget: (context, url, error) => Image(
                                  image: AssetImage(
                                    context.resources.images.noProduct,
                                  ),
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.contain,
                                )),
                        // Image(image: AssetImage("assets/images/flowers.jpg",),height: 100,fit: BoxFit.cover,)
                        //     FadeInImage.assetNetwork(
                        //
                        //   image: widget.image!,
                        //   fit: BoxFit.cover, placeholder: null,
                        // )
                      )),
                ),
                Container(
                  height: 70,
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomText(
                          content: response.name,
                          color: Theme.of(context).colorScheme.subText,
                          titletype: TitleType.bottoms,
                          language: context.read<LocalizationCubit>().state ==
                                  const Locale('ar', '')
                              ? Language.rtl
                              : Language.ltr,
                        ),
                      ),
                      Row(
                        children: [
                          response.hasDiscount
                              ? Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: CustomText(
                                          maxlines: 1,
                                          content: response.strokedPrice,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .subText,
                                          textDecore:
                                              TextDecoration.lineThrough,
                                          titletype: TitleType.body,
                                          language: context
                                                      .read<LocalizationCubit>()
                                                      .state ==
                                                  const Locale('ar', '')
                                              ? Language.rtl
                                              : Language.ltr,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: CustomText(
                                          maxlines: 1,
                                          content: response.mainPrice,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .redColor,
                                          titletype: TitleType.body,
                                          language: context
                                                      .read<LocalizationCubit>()
                                                      .state ==
                                                  const Locale('ar', '')
                                              ? Language.rtl
                                              : Language.ltr,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Expanded(
                                  child: CustomText(
                                    content: response.mainPrice,
                                    color:
                                        Theme.of(context).colorScheme.redColor,
                                    titletype: TitleType.body,
                                    language: context
                                                .read<LocalizationCubit>()
                                                .state ==
                                            const Locale('ar', '')
                                        ? Language.rtl
                                        : Language.ltr,
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ).customMargins(),
              ]),
        ),
      ),
    );
  }
}
