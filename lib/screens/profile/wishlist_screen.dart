import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lamis/res/resources_export.dart';

import '../../cubits/cubits.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  final GetUserWishListCubit _getUserWishListCubit = GetUserWishListCubit();
  FToast fToast = FToast();
  @override
  void initState() {
    _getUserWishListCubit.getUserWishList();
    fToast.init(context);
    super.initState();
  }

  Future<bool> _willPopCallback() async {
    // _productQuantityCubit.save(1);
    Navigator.of(context).pop(true);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        extendBodyBehindAppBar: true,
        appBar: CustomAppBar(
          title: context.resources.strings.wishlist,
        ),
        body: ListView(
          children: [
            // Center(
            //   child: CustomText(
            //     content: context.resources.strings.wishlist,
            //     titletype: TitleType.subtitle,
            //     language: Language.center,
            //   ),
            // ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.resources.dimension.mediumMargin,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: context.resources.dimension.mediumMargin),
                  child:
                      BlocBuilder<GetUserWishListCubit, GetUserWishListState>(
                    bloc: _getUserWishListCubit,
                    builder: (context, state) {
                      if (state is GetUserWishListLoading) {
                        return ListView.builder(
                            itemCount: 3,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return DelayedAnimation(
                                delay: index * 150,
                                child: _WishListShimmerCard(
                                  delete: () {},
                                  productName: "",
                                  image: "",
                                  rating: 0,
                                ),
                              );
                            });
                      }
                      if (state is GetUserWishListDone) {
                        if (state.response.wishlistItems!.isEmpty) {
                          return Column(
                            children: [
                              const FixedHieght(
                                extra: true,
                              ),
                              SizedBox(
                                height: context
                                    .resources.dimension.largeContainerSize,
                                width: context
                                    .resources.dimension.largeContainerSize,
                                child: Image(
                                  image: AssetImage(
                                    context.resources.images.noDataImage,
                                  ),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ],
                          );
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.response.wishlistItems?.length,
                            itemBuilder: (context, index) {
                              return DelayedAnimation(
                                delay: index * 150,
                                child: _WishListCard(
                                  id: state.response.wishlistItems![index]
                                      .product.id,
                                  delete: () {
                                    fToast.showToast(
                                        child: ToastBody(
                                      bgColor: Theme.of(context)
                                          .colorScheme
                                          .toastBackGround,
                                      text: context.resources.strings.loading,
                                    ));
                                    _getUserWishListCubit.removeFromWishlist(
                                        state.response.wishlistItems![index]
                                            .product.id);
                                  },
                                  productName: state.response
                                      .wishlistItems![index].product.name!,
                                  image: state.response.wishlistItems![index]
                                      .product.thumbnailImage!,
                                  description: state.response
                                      .wishlistItems![index].product.basePrice,
                                  rating: state.response.wishlistItems![index]
                                      .product.rating!,
                                ),
                              );
                            });
                      }
                      if (state is GetUserWishListError) {
                        return CustomErrorWidget(
                          onTap: () {
                            _getUserWishListCubit.getUserWishList();
                          },
                        );
                      }
                      return ListView.builder(
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return _WishListCard(
                              id: 0,
                              delete: () {},
                              productName: "",
                              image: "",
                              rating: 0,
                            );
                          });
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _WishListCard extends StatelessWidget {
  const _WishListCard({
    Key? key,
    required this.image,
    required this.productName,
    this.description,
    required this.rating,
    required this.delete,
    required this.id,
  }) : super(key: key);

  final String image;
  final String productName;
  final String? description;
  final double rating;
  final Function delete;
  final int id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.heavyImpact();
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ProductDetails(
              image: image,
              id: id,
            );
          }));
        },
        child: Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.cardColor,
            borderRadius: BorderRadius.circular(
                context.resources.dimension.defaultMargin),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow400,
                spreadRadius: 2,
                blurRadius: 6,
                offset: const Offset(2, 7), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: context
                                      .read<LocalizationCubit>()
                                      .state ==
                                  const Locale("ar", "")
                              ? BorderRadius.only(
                                  topRight: Radius.circular(
                                    context.resources.dimension.defaultMargin,
                                  ),
                                  bottomRight: Radius.circular(
                                    context.resources.dimension.defaultMargin,
                                  ),
                                )
                              : BorderRadius.only(
                                  topLeft: Radius.circular(
                                    context.resources.dimension.defaultMargin,
                                  ),
                                  bottomLeft: Radius.circular(
                                    context.resources.dimension.defaultMargin,
                                  ),
                                ),
                        ),
                        height: 140,
                        width: 120,
                        child: ClipRRect(
                          clipBehavior: Clip.hardEdge,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(17)),
                          child: CachedNetworkImage(
                              // imageUrl: "https://via.placeholder.com/350x200",
                              imageUrl: image,
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
                        )),
                  ),

                  // Image(image: AssetImage("assets/images/flowers.jpg"))),
                  Container(
                    padding:
                        EdgeInsets.all(context.resources.dimension.smallMargin),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.cardColor,
                      borderRadius: context.read<LocalizationCubit>().state ==
                              const Locale("en", "")
                          ? BorderRadius.only(
                              topRight: Radius.circular(
                                context.resources.dimension.defaultMargin,
                              ),
                              bottomRight: Radius.circular(
                                context.resources.dimension.defaultMargin,
                              ),
                            )
                          : BorderRadius.only(
                              topLeft: Radius.circular(
                                context.resources.dimension.defaultMargin,
                              ),
                              bottomLeft: Radius.circular(
                                context.resources.dimension.defaultMargin,
                              ),
                            ),
                    ),
                    height: 140,
                    width: MediaQuery.of(context).size.width - 180,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                            child: Row(
                          // mainAxisAlignment:
                          //     MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, bottom: 30),
                                child: CustomText(
                                  content: productName,
                                  typefont: Typefont.raleway,
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
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(bottom: 30, right: 1),
                              child: NeumorphismBrands(
                                  blueLiner: true,
                                  boxShape: BoxShape.circle,
                                  neumorphismType: NeumorphismType.icon,
                                  child: GestureDetector(
                                      onTap: () {},
                                      child: SizedBox(
                                        height: 35,
                                        child: IconButton(
                                          iconSize: 17,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .redColor,
                                          onPressed: () {
                                            delete();
                                          },
                                          icon: const Icon(Icons.favorite),
                                        ),
                                      ))),
                            ),
                          ],
                        )),
                        Center(
                            child: Row(
                          // mainAxisAlignment:
                          //     MainAxisAlignment.spaceBetween,
                          children: const [],
                        )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: CustomText(
                                  maxlines: 1,
                                  minTextSize: 6,
                                  content: description ?? "",
                                  typefont: Typefont.raleway,
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
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: RatingBar(
                                itemSize: context.resources.dimension.bigMargin,
                                ignoreGestures: true,
                                initialRating: rating.toDouble(),
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                ratingWidget: RatingWidget(
                                    full: Icon(
                                      Icons.star,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .yellowColor,
                                      size: 15,
                                    ),
                                    empty: Icon(
                                      Icons.star_border,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .yellowColor,
                                      size: 15,
                                    ),
                                    half: Icon(
                                      Icons.star_half,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .yellowColor,
                                      size: 15,
                                    )),
                                itemPadding: EdgeInsets.only(
                                    right: context
                                        .resources.dimension.selectedBorder),
                                onRatingUpdate: (rating) {
                                  //print(rating);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).customMargins();
  }
}

class _WishListShimmerCard extends StatelessWidget {
  const _WishListShimmerCard({
    Key? key,
    required this.image,
    required this.productName,
    this.description,
    required this.rating,
    required this.delete,
  }) : super(key: key);

  final String image;
  final String productName;
  final String? description;
  final int rating;
  final Function delete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.lamisColor.withOpacity(0.1),
          borderRadius: BorderRadius.only(
              topLeft:
                  Radius.circular(context.resources.dimension.lightElevation),
              topRight: Radius.circular(
                  context.resources.dimension.extraHighElevation),
              bottomLeft: Radius.circular(
                  context.resources.dimension.extraHighElevation),
              bottomRight:
                  Radius.circular(context.resources.dimension.lightElevation)),
        ),
        child: Stack(children: [
          GestureDetector(
            onTap: () {},
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        color: Colors.transparent,
                        height: 140,
                        width: 140,
                        child: ClipRRect(
                          clipBehavior: Clip.hardEdge,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                                context.resources.dimension.smallMargin),
                          ),
                          child: CachedNetworkImage(
                              // imageUrl: "https://via.placeholder.com/350x200",
                              imageUrl: image,
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
                        )),

                    // Image(image: AssetImage("assets/images/flowers.jpg"))),
                    SizedBox(
                      height: 120,
                      width: MediaQuery.of(context).size.width - 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                              child: CustomText(
                            content: productName,
                            color:
                                Theme.of(context).colorScheme.primaryTextColor,
                            titletype: TitleType.bottoms,
                            language: Language.center,
                          )),
                          Center(
                              child: CustomText(
                            content: description ?? '',
                            titletype: TitleType.subtitle,
                            color: Theme.of(context).colorScheme.subText,
                            typefont: Typefont.amiri,
                          )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              RatingBar(
                                itemSize: context.resources.dimension.bigMargin,
                                ignoreGestures: true,
                                initialRating: rating.toDouble(),
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                ratingWidget: RatingWidget(
                                    full: Icon(
                                      Icons.star,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .yellowColor,
                                      size: 15,
                                    ),
                                    empty: Icon(
                                      Icons.star_border,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .yellowColor,
                                      size: 15,
                                    ),
                                    half: Icon(
                                      Icons.star_half,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .yellowColor,
                                      size: 15,
                                    )),
                                itemPadding: EdgeInsets.only(
                                    right: context
                                        .resources.dimension.selectedBorder),
                                onRatingUpdate: (rating) {
                                  //print(rating);
                                },
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //     // widget.decrease();
                              //   },
                              //   child: Container(
                              //       decoration: BoxDecoration(
                              //         color: Theme.of(context)
                              //             .colorScheme
                              //             .cardColor,
                              //         borderRadius: const BorderRadius.only(
                              //             topLeft: Radius.circular(7.0),
                              //             topRight: Radius.circular(2.0),
                              //             bottomLeft: Radius.circular(7.0),
                              //             bottomRight: Radius.circular(2.0)),
                              //       ),
                              //       height: 25,
                              //       width: 25,
                              //       child: Center(
                              //           child: Column(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.center,
                              //         children: const [
                              //           Icon(
                              //             Icons.minimize,
                              //             size: 12,
                              //           ),
                              //           SizedBox(
                              //             height: 2,
                              //           )
                              //         ],
                              //       ))),
                              // ),
                              // Text(""),
                              // GestureDetector(
                              //     onTap: () {
                              //       // widget.increase();
                              //     },
                              //     child: Container(
                              //         height: 25,
                              //         width: 25,
                              //         decoration: BoxDecoration(
                              //           color: Theme.of(context)
                              //               .colorScheme
                              //               .cardColor,
                              //           borderRadius: const BorderRadius.only(
                              //               topLeft: Radius.circular(2.0),
                              //               topRight: Radius.circular(7.0),
                              //               bottomLeft: Radius.circular(2.0),
                              //               bottomRight: Radius.circular(7.0)),
                              //         ),
                              //         child: const Center(
                              //             child: Icon(
                              //           Icons.add,
                              //           size: 12,
                              //         )))),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.heavyImpact();
                                  delete();
                                },
                                child: const Center(
                                    child: Icon(
                                  Icons.favorite,
                                  size: 20,
                                )),
                              ),
                            ],
                          ),
                        ],
                      ).customMargins(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    ).customMargins();
  }
}
