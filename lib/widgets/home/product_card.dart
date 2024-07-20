import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lamis/cubits/cubits.dart';

import '../../res/resources_export.dart';
import '../../screens/screens.dart';
import '../../widgets/widgets.dart';

// ignore: must_be_immutable
class ProductCard extends StatefulWidget {
  ProductCard(
      {Key? key,
      required this.id,
      this.image,
      this.name,
      this.mainPrice,
      this.strokedPrice,
      this.hasDiscount,
      this.wishListed = false,
      required this.willPop})
      : super(key: key);
  final int id;
  final String? image;
  final String? name;
  final String? mainPrice;
  final String? strokedPrice;
  final bool? hasDiscount;
  final Function willPop;
  bool wishListed;

  @override
  // ignore: library_private_types_in_public_api
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final AddToWishListCubit _addToWishListCubit = AddToWishListCubit();
  FToast fToast = FToast();

  @override
  void initState() {
    fToast.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedColor: Colors.transparent,
      openBuilder: (BuildContext _, VoidCallback openContainer) {
        return ProductDetails(
          image: widget.image ?? "",
          id: widget.id,
        );
      },
      tappable: true,
      transitionDuration: const Duration(milliseconds: 500),
      closedShape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.transparent, width: 0.0),
        borderRadius: BorderRadius.circular(16.0),
      ),
      closedElevation: 0.0,
      onClosed: (value) {
        widget.willPop();
      },
      closedBuilder: (BuildContext _, VoidCallback openContainer) {
        return NeumorphismBrands(
          neumorphismType: NeumorphismType.product,
          activeTransparent: true,
          child: Card(
            color: Theme.of(context).colorScheme.productColor,
            //clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17.0),
            ),
            elevation: 0.0,
            child: Stack(
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: ClipRRect(
                          clipBehavior: Clip.hardEdge,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16), bottom: Radius.zero),
                          child: CachedNetworkImage(
                              height: 140,
                              // width: 60,
                              // imageUrl: "https://via.placeholder.com/350x200",
                              imageUrl: widget.image ?? '',
                              fit: BoxFit.fitHeight,
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
                        ),
                      ),
                      Container(
                        height: 70,
                        margin: const EdgeInsets.only(bottom: 2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CustomText(
                                content: widget.name ?? "",
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryTextColor,
                                titletype: TitleType.bottoms,
                                language:
                                    context.read<LocalizationCubit>().state ==
                                            const Locale('ar', '')
                                        ? Language.rtl
                                        : Language.ltr,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  widget.hasDiscount ?? true
                                      ? Expanded(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: CustomText(
                                                  maxlines: 1,
                                                  content:
                                                      widget.strokedPrice ?? '',
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .subText,
                                                  textDecore: TextDecoration
                                                      .lineThrough,
                                                  titletype: TitleType.body,
                                                  language: context
                                                              .read<
                                                                  LocalizationCubit>()
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
                                                  minTextSize: 6,
                                                  maxlines: 1,
                                                  content:
                                                      widget.mainPrice ?? "",
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .redColor,
                                                  titletype: TitleType.body,
                                                  language: context
                                                              .read<
                                                                  LocalizationCubit>()
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
                                            content: widget.mainPrice ?? "",
                                            color: Theme.of(context)
                                                .colorScheme
                                                .redColor,
                                            titletype: TitleType.body,
                                            language: context
                                                        .read<
                                                            LocalizationCubit>()
                                                        .state ==
                                                    const Locale('ar', '')
                                                ? Language.ltr
                                                : Language.rtl,
                                          ),
                                        ),
                                  // const SizedBox(
                                  //   width: 20,
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ).customMargins(),
                    ]),
                Positioned(
                  right: 1,
                  top: 1,
                  child: Column(
                    children: [
                      BlocBuilder(
                        bloc: _addToWishListCubit,
                        builder: (context, state) {
                          if (state is AddToWishListDone) {
                            widget.wishListed =
                                state.response.isInWishList ?? false;
                          }
                          return NeumorphismContainer(
                              child: SizedBox(
                            height: 30,
                            child: IconButton(
                              iconSize: 15,
                              icon: Icon(
                                widget.wishListed
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
                                color: Theme.of(context).colorScheme.redColor,
                              ),
                              onPressed: () {
                                if (context.read<IsLoggedInCubit>().state ==
                                    false) {
                                  fToast.showToast(
                                      child: ToastBody(
                                    text: context.resources.strings.mustLogIn,
                                    iconColor:
                                        Theme.of(context).colorScheme.redColor,
                                    bgColor: Theme.of(context)
                                        .colorScheme
                                        .toastBackGround,
                                  ));
                                } else {
                                  fToast.showToast(
                                      child: ToastBody(
                                    bgColor: Theme.of(context)
                                        .colorScheme
                                        .toastBackGround,
                                    text: context.resources.strings.loading,
                                  ));
                                  if (widget.wishListed) {
                                    _addToWishListCubit
                                        .removeFromWishList(widget.id);
                                  } else {
                                    _addToWishListCubit
                                        .addToWishList(widget.id);
                                  }
                                }
                                // carouselController.previousPage();
                              },
                            ),
                          ));
                        },
                      ),
                      const FixedHieght(),
                      NeumorphismContainer(
                          child: SizedBox(
                        height: 30,
                        child: IconButton(
                          iconSize: 15,
                          icon: Icon(
                            Icons.add_shopping_cart,
                            color: Theme.of(context).colorScheme.lamisColor,
                          ),
                          onPressed: () async {
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProductDetails(
                                      image: widget.image ?? "",
                                      id: widget.id,
                                    )));
                          },
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
