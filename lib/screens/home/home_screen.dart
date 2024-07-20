import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:rate_my_app/rate_my_app.dart';

import '../../blocs/blocs.dart';
import '../../cubits/cubits.dart';
import '../../res/resources_export.dart';
import '../../widgets/home/flash_deal.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FeaturedProductsBloc _productsBloc = FeaturedProductsBloc();
  final AdvertSliderBloc _sliderBloc = AdvertSliderBloc();
  final CategoriesBloc _categoriesBloc = CategoriesBloc();
  final TodayDealBloc _todaysBloc = TodayDealBloc();
  final BrandsCubit _brandsCubit = BrandsCubit();
  final FlashDealsCubit _flashDeal = FlashDealsCubit();
  static final ScrollController controller = ScrollController();
  CarouselController buttonCarouselController = CarouselController();

  // RateMyApp rateMyApp = RateMyApp(
  //   preferencesPrefix: 'rateMyApp_',
  //   minDays: 0, // Show rate popup on first day of install.
  //   remindDays: 0,
  //   remindLaunches: 1,
  //   minLaunches:
  //       1, // Show rate popup after 3 launches of app after minDays is passed.
  // );
  @override
  void initState() {
    createBlocs();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<RateAppCubit>().state.init().then((_) {
        if (context.read<RateAppCubit>().state.shouldOpenDialog) {
          context.read<RateAppCubit>().state.showRateDialog(
                context,
                title: context.resources.strings.rateTitle, // The dialog title.
                message: context
                    .resources.strings.rateMessage, // The dialog message.
                rateButton: context
                    .resources.strings.rate, // The dialog "rate" button text.
                noButton: context
                    .resources.strings.noThanks, // The dialog "no" button text.
                laterButton: context.resources.strings
                    .maybeLater, // The dialog "later" button text.
                listener: (button) {
                  switch (button) {
                    case RateMyAppDialogButton.rate:
                      break;
                    case RateMyAppDialogButton.later:
                      break;
                    case RateMyAppDialogButton.no:
                      context.read<RateAppCubit>().state.reset();
                      break;
                  }

                  return true; // Return false if you want to cancel the click event.
                },
                ignoreNativeDialog: Platform
                    .isAndroid, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
                dialogStyle: const DialogStyle(), // Custom dialog styles.
                onDismissed: () => context.read<RateAppCubit>().state.callEvent(
                    RateMyAppEventType
                        .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
                // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
                // actionsBuilder: (context) => [], // This one allows you to use your own buttons.
              );
        }
      });
      if (mounted && context.read<RateAppCubit>().state.shouldOpenDialog) {
        // rateMyApp.callEvent(eventType)
        context.read<RateAppCubit>().state.showRateDialog(context);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          context.read<LocalizationCubit>().state == const Locale('ar', '')
              ? TextDirection.rtl
              : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.homeScreen,
        body: ListView(
          controller: controller,
          children: [
            // Center(child: Text("home"),),
            const FixedHieght(),
            buildHomeCarouselSlider(
                _sliderBloc, null, buttonCarouselController),

            //const FixedHieght(),

            buildFlashDeal(_flashDeal, createBlocs),
            const FixedHieght(),

            buildTodaysDealCards(
                _todaysBloc, context.read<UserGuideCubit>().todayDeal),
            const FixedHieght(),

            buildHomeFeaturedCategories(_categoriesBloc,
                context.read<UserGuideCubit>().featuredCategories),

            const FixedHieght(),

            Container(
              child: buildHomeFeaturedProducts(context, _productsBloc),
            ),
            const FixedHieght(),
            Column(
              // key: context.read<UserGuideCubit>().ourBrands,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHomeBrands(_brandsCubit, null),
              ],
            ),
            const FixedHieght(),
          ],
        ).customMargins(),
      ),
    );
  }

  void createBlocs() {
    _productsBloc.add(FeaturedProductsFetch());
    _sliderBloc.add(AdvertSliderFetch());
    _categoriesBloc.add(FeaturedCategoriesFetch());
    _todaysBloc.add(TodayDealFetch());
    _brandsCubit.getBrands();
    _flashDeal.getFlashDeals();
  }
}

class FixedHieght extends StatelessWidget {
  const FixedHieght({
    Key? key,
    this.extra = false,
  }) : super(key: key);
  final bool extra;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: extra ? 30 : 10,
    );
  }
}

buildHomeFeaturedProducts(context, FeaturedProductsBloc productsBloc) {
  ScrollController featuredProductScrollController = ScrollController();
  return BlocBuilder<FeaturedProductsBloc, FeaturedProductsState>(
    bloc: productsBloc,
    builder: (context, state) {
      bool getIsTablet() {
        bool isTablet;
        double ratio = MediaQuery.of(context).size.width /
            MediaQuery.of(context).size.height;
        if ((ratio >= 0.74) && (ratio < 1.5)) {
          isTablet = true;
        } else {
          isTablet = false;
        }
        return isTablet;
      }

      if (state is FeaturedProductsLoading) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const FixedHieght(),
            GridView.builder(
                itemCount: 2,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: getIsTablet()
                    ? const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.0,
                      )
                    : const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.618),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          context.resources.dimension.bigMargin),
                      color: Theme.of(context)
                          .colorScheme
                          .lamisColor
                          .withOpacity(0.3),
                    ),
                  );
                }),
          ],
        );
      }
      if (state is FeaturedProductsDone) {
        if (state.value.products.isEmpty) {
          return Image(
            image: AssetImage(
              context.resources.images.noDataImage,
            ),
            fit: BoxFit.fitWidth,
          );
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
              child: CustomText(
                content: context.resources.strings.featuredProducts,
                color: Theme.of(context).colorScheme.primaryTextColor,
                titletype: TitleType.headline,
                language: context.read<LocalizationCubit>().state ==
                        const Locale('ar', '')
                    ? Language.rtl
                    : Language.ltr,
              ),
            ),
            const FixedHieght(),
            GridView.builder(
                // 2
                //addAutomaticKeepAlives: true,
                itemCount: state.value.products.length,
                controller: featuredProductScrollController,
                gridDelegate: getIsTablet()
                    ? const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1,
                      )
                    : const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 0.680),
                // padding:
                //     EdgeInsets.all(context.resources.dimension.zeroElevation),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // 3
                  return DelayedAnimation(
                    delay: index * 200,
                    fromSide: FromSide.bottom,
                    child: ProductCard(
                        willPop: () {
                          productsBloc.add(FeaturedProductsFetch());
                        },
                        wishListed: state.value.products[index].wishlisted!,
                        id: state.value.products[index].id,
                        image: state.value.products[index].thumbnailImage,
                        name: state.value.products[index].name,
                        mainPrice: state.value.products[index].mainPrice,
                        strokedPrice: state.value.products[index].strokedPrice,
                        hasDiscount: state.value.products[index].hasDiscount),
                  );
                }
                //   id: 1,
                //   name: "some name",
                //   main_price: "1000",
                //   stroked_price: "900",
                //   has_discount: true,
                // );
                // }
                ),
          ],
        );
      }
      if (state is FeaturedProductsError) {
        return CustomErrorWidget(onTap: () {
          productsBloc.add(FeaturedProductsFetch());
        });
      }
      return GridView.builder(
          // 2
          //addAutomaticKeepAlives: true,
          itemCount: 3,
          controller: featuredProductScrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.618),
          padding: EdgeInsets.all(context.resources.dimension.mediumMargin),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            // 3
            return ProductCard(
              willPop: () {},
              wishListed: false,
              id: 1,
              name: "some name",
              mainPrice: "1000",
              strokedPrice: "900",
              hasDiscount: true,
            );
          });
    },
  );
  // } else if (_totalProductData == 0) {
  //   return Center(
  //       child: Text(
  //           AppLocalizations.of(context).common_no_product_is_available));
  // } else {
  //   return Container(); // should never be happening
  // }
}

buildHomeCarouselSlider(AdvertSliderBloc sliderBloc, Key? key,
    CarouselController carouselController) {
  CarouselOptions options = CarouselOptions(
    height: 150.0,
    aspectRatio: 2,
    viewportFraction: 1,
    autoPlay: true,
    autoPlayInterval: const Duration(seconds: 3),
    autoPlayAnimationDuration: const Duration(milliseconds: 800),
    autoPlayCurve: Curves.ease,
    enlargeCenterPage: true,
  );

  return Stack(
    children: [
      BlocBuilder<AdvertSliderBloc, AdvertSliderState>(
          key: key,
          bloc: sliderBloc,
          builder: (context, state) {
            if (state is AdvertSliderLoading) {
              return CarouselSlider(
                options: options,
                carouselController: carouselController,
                items: [1, 2, 3, 4, 5].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .lamisColor
                                .withOpacity(0.3),
                            borderRadius: BorderRadius.all(Radius.circular(
                                context.resources.dimension.bigMargin))),
                      );
                    },
                  );
                }).toList(),
              );
            }
            if (state is AdvertSliderDone) {
              if (state.value.sliders.isEmpty) {
                return Container();
              } else {
                return CarouselSlider(
                  options: options,
                  carouselController: carouselController,
                  items: state.value.sliders.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () {
                            // launch(
                            //   state.value.sliders[index].,
                            //   forceSafariVC: false,
                            //   forceWebView: false,
                            //   headers: <String, String>{
                            //     'my_header_key': 'my_header_value'
                            //   },
                            // )
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            // margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            // decoration: BoxDecoration(
                            //     color: Theme.of(context).colorScheme.disabledColor,
                            //     borderRadius: BorderRadius.all(Radius.circular(10))),
                            child: CachedNetworkImage(
                                // imageUrl: "https://via.placeholder.com/350x200",
                                imageUrl: i.photo,
                                fit: BoxFit.fill,
                                width: MediaQuery.of(context).size.width,
                                fadeOutDuration: const Duration(seconds: 1),
                                fadeInDuration: const Duration(seconds: 1),
                                errorWidget: (context, url, error) => Image(
                                      image: AssetImage(
                                        context.resources.images.noProduct,
                                      ),
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.contain,
                                    )),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              }
            }
            if (state is AdvertSliderError) {
              return CarouselSlider(
                options: options,
                carouselController: carouselController,
                items: [1, 2, 3].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .lamisColor
                                .withOpacity(0.3),
                            borderRadius: BorderRadius.all(Radius.circular(
                                context.resources.dimension.bigMargin))),
                        child: Center(
                            child: CachedNetworkImage(
                                imageUrl: "",
                                // imageUrl: i.photo,
                                fit: BoxFit.fill,
                                fadeOutDuration: const Duration(seconds: 1),
                                fadeInDuration: const Duration(seconds: 1),
                                errorWidget: (context, url, error) => Image(
                                      image: AssetImage(
                                        context.resources.images.noProduct,
                                      ),
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.contain,
                                    ))
                            // Text(
                            //   'text $i',
                            //   style: const TextStyle(fontSize: 16.0),
                            // ),
                            ),
                      );
                    },
                  );
                }).toList(),
              );
            }
            return Container();
          }),
      // Container(
      //   height: 150,
      //
      //   padding: const EdgeInsets.symmetric(horizontal: 0.0),
      //   child: Center(
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         NeumorphismContainer(
      //             child: GestureDetector(
      //                 onTap: () {
      //                   carouselController.previousPage();
      //                 },
      //                 child: const Padding(
      //                   padding: EdgeInsets.all(8.0),
      //                   child: Icon(
      //                     Icons.arrow_back_ios_rounded,
      //                     color: Color(0xFF108DCD),
      //                   ),
      //                 ))),
      //         NeumorphismContainer(
      //             child: GestureDetector(
      //                 onTap: () {
      //                   carouselController.nextPage();
      //                 },
      //                 child: const Padding(
      //                   padding: EdgeInsets.all(8.0),
      //                   child: Icon(
      //                     Icons.arrow_forward_ios_outlined,
      //                     color: Color(0xFF108DCD),
      //                   ),
      //                 ))),
      //       ],
      //     ),
      //   ),
      // ),
    ],
  );
}

buildHomeFeaturedCategories(CategoriesBloc categoriesBloc, Key key) {
  ScrollController featuredCategoriesScrollController = ScrollController();

  return BlocBuilder<CategoriesBloc, CategoriesState>(
    key: key,
    bloc: categoriesBloc,
    builder: (context, state) {
      if (state is CategoriesLoading) {
        return SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              return DelayedAnimation(
                delay: index * 200,
                fromSide: FromSide.right,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: context.resources.dimension.mediumMargin,
                      horizontal: context.resources.dimension.mediumMargin),
                  child: Container(
                    width: context.resources.dimension.middleContainerSize * 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          context.resources.dimension.bigMargin),
                      color: Theme.of(context)
                          .colorScheme
                          .lamisColor
                          .withOpacity(0.3),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }
      if (state is CategoriesDone) {
        if (state.value.categories.isEmpty) {
          return Container();
        } else {
          return Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 32,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      content: context.resources.strings.featuredCategories,
                      titletype: TitleType.headline,
                      color: Theme.of(context).colorScheme.primaryTextColor,
                      language: context.read<LocalizationCubit>().state ==
                              const Locale('ar', '')
                          ? Language.rtl
                          : Language.ltr,
                    ),
                    Padding(
                      padding: context.watch<LocalizationCubit>().state ==
                              const Locale("ar", "")
                          ? EdgeInsets.only(
                              right: context.resources.dimension.mediumMargin)
                          : EdgeInsets.only(
                              left: context.resources.dimension.mediumMargin),
                      child: NeumorphismContainer(
                          child: SizedBox(
                        height: 35,
                        child: IconButton(
                          iconSize: 20,
                          icon: CustomText(
                            content: context.resources.strings.all,
                            color: Theme.of(context).colorScheme.lamisColor,
                          ),
                          onPressed: () {
                            context.read<CurrentScreenCubit>().change(1);
                          },
                        ),
                      )),
                    ),
                  ],
                ),
              ),
              const FixedHieght(),
              SizedBox(
                height: 100,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    //addAutomaticKeepAlives: true,
                    itemCount: state.value.categories.length,
                    controller: featuredCategoriesScrollController,
                    // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 1,
                    //     crossAxisSpacing: 10,
                    //     mainAxisSpacing: 10,
                    //     childAspectRatio: 1.4),
                    padding: EdgeInsets.all(
                        context.resources.dimension.mediumMargin),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      // 3
                      return DelayedAnimation(
                        delay: index * 200,
                        fromSide: FromSide.right,
                        child: GestureDetector(
                          onTap: () async {
                            HapticFeedback.heavyImpact();
                            var val = await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CategoriesScreen(
                                id: state.value.categories[index].id,
                                isSubCategory: true,
                                title: state.value.categories[index].name,
                              );
                            }));
                            if (val) {}
                          },
                          child: NeumorphismBrands(
                            activeTransparent: true,
                            child: SizedBox(
                              width: 90,
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: 60,
                                    width: 90,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(context
                                            .resources.dimension.smallMargin),
                                      ),
                                      child: CachedNetworkImage(
                                          // imageUrl: "https://via.placeholder.com/350x200",
                                          imageUrl: state
                                              .value.categories[index].icon,
                                          fadeOutDuration:
                                              const Duration(seconds: 1),
                                          fadeInDuration:
                                              const Duration(seconds: 1),
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              Image(
                                                image: AssetImage(
                                                  context.resources.images
                                                      .noProduct,
                                                ),
                                                height: 100,
                                                width: 100,
                                                fit: BoxFit.contain,
                                              )),
                                    ),
                                  ),
                                  // const FixedHieght(),
                                  // Expanded(
                                  //   child: CustomText(
                                  //     content: state.value.categories[index].name,
                                  //     titletype: TitleType.time,
                                  //     language: Language.center,
                                  //     color: Theme.of(context).colorScheme.subText,
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          );
        }
      }
      if (state is CategoriesError) {
        return CustomErrorWidget(
          onTap: () {
            categoriesBloc.add(FeaturedCategoriesFetch());
          },
        );
      }
      return SizedBox(
        height: 150,
        child: GridView.builder(
            scrollDirection: Axis.horizontal,
            //addAutomaticKeepAlives: true,
            itemCount: 3,
            controller: featuredCategoriesScrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.618),
            padding: EdgeInsets.all(context.resources.dimension.mediumMargin),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              // 3
              return Container(
                // height: 140,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(context.resources.dimension.bigMargin)),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.border)),
                margin: EdgeInsets.all(context.resources.dimension.bigMargin),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // const Expanded(
                    //     child: Image(
                    //   image: AssetImage(
                    //     "assets/images/flowers.jpg",
                    //   ),
                    //   height: 100,
                    //   fit: BoxFit.cover,
                    // )),
                    const FixedHieght(),
                    CustomText(content: "featured Category")
                  ],
                ),
              );
            }),
      );
    },
  );
}

buildHomeBrands(BrandsCubit brandsCubit, Key? key) {
  ScrollController brandsScrollController = ScrollController();

  return BlocBuilder(
    key: key,
    bloc: brandsCubit,
    builder: (context, state) {
      if (state is BrandsLoading) {
        return SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              return DelayedAnimation(
                delay: index * 200,
                fromSide: FromSide.right,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: context.resources.dimension.mediumMargin,
                      horizontal: context.resources.dimension.mediumMargin),
                  child: Container(
                    width: context.resources.dimension.middleContainerSize * 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          context.resources.dimension.bigMargin),
                      color: Theme.of(context)
                          .colorScheme
                          .lamisColor
                          .withOpacity(0.3),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }
      if (state is BrandsDone) {
        if (state.response.brands.isEmpty) {
          return Container();
        } else {
          return Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 32,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      content: context.resources.strings.ourBrands,
                      titletype: TitleType.headline,
                      color: Theme.of(context).colorScheme.primaryTextColor,
                      language: context.read<LocalizationCubit>().state ==
                              const Locale('ar', '')
                          ? Language.rtl
                          : Language.ltr,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.response.brands.length,
                    controller: brandsScrollController,
                    padding: EdgeInsets.all(
                        context.resources.dimension.mediumMargin),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      // 3
                      return DelayedAnimation(
                        delay: index * 200,
                        fromSide: FromSide.right,
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.heavyImpact();
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return BrandProducts(
                                id: state.response.brands[index].id,
                                brandName: state.response.brands[index].name,
                              );
                            }));
                          },
                          child: SizedBox(
                            width: 110,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(context
                                        .resources.dimension.imageBorderRadius),
                                    topLeft: Radius.circular(context
                                        .resources.dimension.imageBorderRadius),
                                  ),
                                  child: Container(
                                    width: 200,
                                    height: 100,
                                    padding: const EdgeInsets.all(12.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      // width: 40,
                                      // height: 29,
                                      child: CachedNetworkImage(
                                          imageUrl:
                                              state.response.brands[index].logo,
                                          fadeOutDuration:
                                              const Duration(seconds: 1),
                                          fadeInDuration:
                                              const Duration(seconds: 1),
                                          fit: BoxFit.contain,
                                          errorWidget: (context, url, error) =>
                                              Image(
                                                image: AssetImage(
                                                  context.resources.images
                                                      .noProduct,
                                                ),
                                                height: 100,
                                                width: 100,
                                                fit: BoxFit.contain,
                                              )),
                                    ),
                                  ),
                                ),
                                //  const FixedHieght(),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          );
        }
      }
      if (state is BrandsError) {
        return CustomErrorWidget(
          onTap: () {
            brandsCubit.getBrands();
          },
        );
      }
      return SizedBox(
        height: 150,
        child: GridView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            controller: brandsScrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.618),
            padding: EdgeInsets.all(context.resources.dimension.mediumMargin),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              // 3
              return Container(
                // height: 140,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(context.resources.dimension.bigMargin)),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.border)),
                margin: EdgeInsets.all(context.resources.dimension.bigMargin),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Image(
                      image: AssetImage(
                        context.resources.images.emptyCartImage,
                      ),
                      height: 100,
                      fit: BoxFit.cover,
                    )),
                  ],
                ),
              );
            }),
      );
    },
  );
}

buildTodaysDealCards(TodayDealBloc todaysBloc, Key key) {
  ScrollController todaysDealScrollController = ScrollController();
  return BlocBuilder<TodayDealBloc, TodayDealState>(
      key: key,
      bloc: todaysBloc,
      builder: (context, state) {
        if (state is TodayDealLoading) {
          return Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(context.resources.dimension.bigMargin),
              color: Theme.of(context).colorScheme.lamisColor.withOpacity(0.3),
            ),
          );
        }
        if (state is TodayDealDone) {
          // ignore: prefer_is_empty
          if (state.value.products.isEmpty) {
            return Container();
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        content: context.resources.strings.todaysDeal,
                        titletype: TitleType.headline,
                        color: Theme.of(context).colorScheme.primaryTextColor,
                        language: context.read<LocalizationCubit>().state ==
                                const Locale('ar', '')
                            ? Language.rtl
                            : Language.ltr,
                      ),
                      Padding(
                        padding: context.watch<LocalizationCubit>().state ==
                                const Locale("ar", "")
                            ? EdgeInsets.only(
                                right: context.resources.dimension.mediumMargin)
                            : EdgeInsets.only(
                                left: context.resources.dimension.mediumMargin),
                        child: NeumorphismContainer(
                            child: SizedBox(
                          height: 35,
                          child: IconButton(
                            iconSize: 20,
                            icon: CustomText(
                              content: context.resources.strings.all,
                              color: Theme.of(context).colorScheme.lamisColor,
                            ),
                            onPressed: () {
                              context.read<CurrentScreenCubit>().change(2);
                            },
                          ),
                        )),
                      ),
                    ],
                  ),
                ),
                const FixedHieght(),
                SizedBox(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.value.products.length,
                      controller: todaysDealScrollController,
                      itemBuilder: (BuildContext context, int index) {
                        var product = state.value.products[index];

                        return Padding(
                          padding: EdgeInsets.only(
                              right: context.resources.dimension.smallMargin),
                          child: DelayedAnimation(
                            fromSide: FromSide.right,
                            delay: 200 * index,
                            child: ToDayDealCard(
                              response: product,
                            ),
                          ),
                        );
                      }),
                ),
              ],
            );
          }
        }
        if (state is TodayDealError) {
          return CustomErrorWidget(
            onTap: () {
              todaysBloc.add(TodayDealFetch());
            },
          );
        }

        return Container();
      });
}

buildFlashDeal(FlashDealsCubit flashDealsCubit, Function willPop) {
  List<CountdownTimerController> timerControllerList = [];

  DateTime convertTimeStampToDateTime(int timeStamp) {
    var dateToTimeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    return dateToTimeStamp;
  }

  buildFlashDealListItem(flashDealResponse, index) {
    DateTime end =
        convertTimeStampToDateTime(flashDealResponse.flashDeals[index].date);
    // var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc, true);// YYYY-mm-dd
    DateTime now = DateTime.now().toUtc();
    int diff = end.difference(now).inMilliseconds;
    int endTime = diff + now.millisecondsSinceEpoch;

    void onEnd() {}

    CountdownTimerController timeController =
        CountdownTimerController(endTime: endTime, onEnd: onEnd);
    timerControllerList.add(timeController);

    return FlashDealWidget(
      timerControllerList: timerControllerList,
      index: index,
      response: flashDealResponse,
      willPop: willPop,
    );
    // return FlashDealListItem(
    //   timerControllerList: _timerControllerList,
    //   index: index,
    //   response: flashDealResponse,
    // );
  }

  return BlocBuilder<FlashDealsCubit, FlashDealsState>(
    bloc: flashDealsCubit,
    builder: (context, state) {
      if (state is FlashDealsLoading) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: context.resources.dimension.middleContainerSize,
            padding: EdgeInsets.all(context.resources.dimension.mediumMargin),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.lamisColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(
                  context.resources.dimension.mediumMargin),
            ),
          ),
        );
      }
      if (state is FlashDealsDone) {
        if (state.response.flashDeals!.isEmpty) {
          return Container();
        } else {
          return SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              reverse: true,
              scrollDirection: Axis.horizontal,
              itemCount: state.response.flashDeals?.length,
              itemBuilder: (context, index) {
                // print(state.response.flashDeals![0].date);
                //return BackgroundLeave(
                //     child: buildFlashDealListItem(state.response, index));
                return buildFlashDealListItem(state.response, index);
              },
            ),
          );
          // BackgroundLeave(
          //   // color: Theme.of(context).colorScheme.yellowColor.withOpacity(0.3),
          //   child: LaistView.builder(
          //     scrollDirection: Axis.horizontal,
          //     itemCount: state.response.flashDeals?.length,
          //     itemBuilder: (context, index) {
          //       // print(state.response.flashDeals![0].date);
          //       return buildFlashDealListItem(state.response, index);
          //     },
          //   ),
          // );
        }
      }
      return Container(
        height: 30,
      );
    },
  );
}

class FlashDealListItem extends StatelessWidget {
  const FlashDealListItem({
    Key? key,
    required List<CountdownTimerController> timerControllerList,
    required this.index,
    this.response,
    required this.willPop,
  })  : _timerControllerList = timerControllerList,
        super(key: key);

  final List<CountdownTimerController> _timerControllerList;
  final int index;
  final dynamic response;
  final Function willPop;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: CountdownTimer(
        controller: _timerControllerList[index],
        widgetBuilder: (_, CurrentRemainingTime? time) {
          return GestureDetector(
            onTap: () async {
              HapticFeedback.heavyImpact();
              var val = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return ProductsScreen(
                  title: response.flashDeals[index].title,
                  id: response.flashDeals[index].id,
                  flashDeal: true,
                );
              }));

              if (val) {
                willPop;
              }
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 103,
                    height: 100,
                    child: Center(
                        child: time == null
                            ? Text(
                                "end",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .scaffoldColor,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600),
                              )
                            : BuildTimerRowRow(
                                time: time,
                              )),
                  ),
                  Card(
                    color: Colors.transparent,
                    elevation: 0.0,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        width: 165,
                        height: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: CachedNetworkImage(
                            imageUrl: response.flashDeals[index].banner,
                            fadeOutDuration: const Duration(seconds: 1),
                            fadeInDuration: const Duration(seconds: 1),
                            errorWidget: (context, url, error) => Image(
                              image: AssetImage(
                                context.resources.images.noProduct,
                              ),
                              height: 100,
                              width: 100,
                              fit: BoxFit.contain,
                            ),
                          ),
                        )),
                  ),
                  Center(
                    child: SizedBox(
                      width: 70,
                      height: 70,
                      child: CustomText(
                        content: response.flashDeals[index].title,
                        color: Colors.white,
                        titletype: TitleType.body,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BuildTimerRowRow extends StatelessWidget {
  const BuildTimerRowRow({
    Key? key,
    required this.time,
  }) : super(key: key);

  final CurrentRemainingTime time;
  String timeText(String txt, {defaultLength = 3}) {
    var blankZeros = defaultLength == 3 ? "000" : "00";
    var leadingZeros = "";
    if (defaultLength == 3 && txt.length == 1) {
      leadingZeros = "00";
    } else if (defaultLength == 3 && txt.length == 2) {
      leadingZeros = "0";
    } else if (defaultLength == 2 && txt.length == 1) {
      leadingZeros = "0";
    }

    var newtxt = (txt == "" || txt == null.toString()) ? blankZeros : txt;

    // print(txt + " " + default_length.toString());
    // print(newtxt);

    if (defaultLength > txt.length) {
      newtxt = leadingZeros + newtxt;
    }
    //print(newtxt);

    return newtxt;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2.0),
      child: SizedBox(
        //  color: Theme.of(context).colorScheme.yellowColor.withOpacity(0.1),
        height: 20,
        width: 110,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              content: timeText(time.days.toString(), defaultLength: 2),
              color: Colors.white,
              titletype: TitleType.body,
            ),
            CustomText(
              content: " : ",
              color: Colors.white,
              titletype: TitleType.time,
            ),
            CustomText(
              content: timeText(time.hours.toString(), defaultLength: 2),
              color: Colors.white,
              titletype: TitleType.body,
            ),
            CustomText(
              content: " : ",
              color: Colors.white,
              titletype: TitleType.time,
            ),
            CustomText(
              content: timeText(time.min.toString(), defaultLength: 2),
              titletype: TitleType.body,
              color: Colors.white,
            ),
            CustomText(
              content: " : ",
              color: Colors.white,
              titletype: TitleType.time,
            ),
            CustomText(
              content: timeText(time.sec.toString(), defaultLength: 2),
              color: Colors.white,
              titletype: TitleType.body,
            ),
          ],
        ),
      ),
    );
  }
}
