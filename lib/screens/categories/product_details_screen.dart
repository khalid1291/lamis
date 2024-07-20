import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lamis/screens/cart/cart_screen.dart';
import 'package:lamis/screens/home/home_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../blocs/blocs.dart';
import '../../cubits/cubits.dart';
import '../../cubits/products/product_variables/variant_discount_price_cubit.dart';
import '../../repos/repos.dart' show UserRepo;
import '../../res/resources_export.dart';
import '../../widgets/widgets.dart';
import '../brands/brand_products.dart';
import '../intro/login_screen.dart';
import '../products/reviews_screen.dart';

class ProductDetails extends StatefulWidget {
  final int id;
  final String image;

  const ProductDetails({Key? key, required this.id, required this.image})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final ScrollController _mainScrollController = ScrollController();
  final ScrollController _colorScrollController = ScrollController();
  final ScrollController _variantScrollController = ScrollController();
  final ScrollController _imageScrollController = ScrollController();
  final TextEditingController _quantityController = TextEditingController();
  TextEditingController sellerChatMessageController = TextEditingController();

  List<BoxShadow> boxShadowDetails = [
    BoxShadow(
        color: Theme.of(context).colorScheme.shadow400,
        offset: const Offset(4, 4),
        blurRadius: 10,
        spreadRadius: 1),
    BoxShadow(
        color: Theme.of(context).colorScheme.shadow200,
        offset: const Offset(3, 3),
        blurRadius: 10,
        spreadRadius: 1),
    BoxShadow(
        color: Theme.of(context).colorScheme.shadow100,
        offset: const Offset(-4, -4),
        blurRadius: 10,
        spreadRadius: 1),
  ];
  // ignore: prefer_typing_uninitialized_variables
  late var _productDetails;
  final _productImageList = [];
  final _colorList = [];
  final _selectedChoices = [];
  var _choiceString = "";

  final List<dynamic> _relatedProducts = [];
  // final bool _relatedProductInit = false;
  final List<dynamic> _topProducts = [];
  final bool _topProductInit = false;
  bool firstBuild = true;

  final ProductsBloc _productDetailsBloc = ProductsBloc();
  final SelectedIndexCubit _chosedIndexCubit = SelectedIndexCubit(0);
  final SelectedColorIndexCubit _chosedColorIndexCubit =
      SelectedColorIndexCubit(0);
  final ProductAppBarStringCubit _productAppBarStringCubit =
      ProductAppBarStringCubit(". . .");
  final ProductSinglePriceCubit _productSinglePriceCubit =
      ProductSinglePriceCubit(1);
  final ProductSinglePriceStringCubit _productSinglePriceStringCubit =
      ProductSinglePriceStringCubit("");
  final VariantDiscountPriceCubit variantDiscountPriceCubit =
      VariantDiscountPriceCubit("");
  final ProductStockCubit _productStockCubit = ProductStockCubit(0);
  final ProductVariantCubit _productVariantCubit = ProductVariantCubit("");
  final ProductQuantityCubit _productQuantityCubit = ProductQuantityCubit(1);
  final ProductTotalPriceCubit _productTotalPriceCubit =
      ProductTotalPriceCubit(0);
  final ProductVariantBloc _productVariantBloc = ProductVariantBloc();
  final CartDataNetworkCubit _cartDataNetworkCubit = CartDataNetworkCubit();
  final CheckIfInUserWishListCubit _checkIfInUserWishListCubit =
      CheckIfInUserWishListCubit();
  final IsInWishListCubit _isInWishListCubit = IsInWishListCubit(false);
  final AddToWishListCubit _addToWishListCubit = AddToWishListCubit();
  final RemoveFromWishListCubit _removeFromWishListCubit =
      RemoveFromWishListCubit();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ProductReviewCubit productReviewCubit = ProductReviewCubit();
  FToast fToast = FToast();
  @override
  void initState() {
    _productDetailsBloc.add(FetchProductDetails(widget.id));
    _checkIfInUserWishListCubit.checkIfnUserWishlist(widget.id);
    productReviewCubit.getReviews(productId: widget.id);
    fToast.init(context);
    _quantityController.selection = TextSelection.fromPosition(
        TextPosition(offset: _quantityController.text.length));

    super.initState();
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    _variantScrollController.dispose();
    _imageScrollController.dispose();
    _colorScrollController.dispose();
    super.dispose();
  }

  void setProductDetailValues() {
    if (_productDetails != null) {
      _productAppBarStringCubit.save(_productDetails.priceHighLow);
      _productSinglePriceCubit.save(_productDetails.calculablePrice);
      _productSinglePriceStringCubit.save(_productDetails.mainPrice);
      variantDiscountPriceCubit.save(_productDetails.strokedPrice);
      calculateTotalPrice();
      _productStockCubit.save(_productDetails.currentStock);
      if (_productImageList.isEmpty) {
        _productDetails.photos.forEach((photo) {
          _productImageList.add(photo.path);
        });
      }
      if (_selectedChoices.isEmpty) {
        _productDetails.choiceOptions.forEach((choiceOpiton) {
          _selectedChoices.add(choiceOpiton.options[0]);
        });
      }
      if (_colorList.isEmpty) {
        _productDetails.colors.forEach((color) {
          _colorList.add(color);
        });
      }

      setChoiceString();

      if (_productDetails.colors.length > 0 ||
          _productDetails.choiceOptions.length > 0) {
        fetchAndSetVariantWiseInfo(changeAppbarString: true);
      }
    }
  }

  void setChoiceString() {
    _choiceString = _selectedChoices.join(",").toString();
  }

  addToWishList() {
    _addToWishListCubit.addToWishList(widget.id);
  }

  removeFromWishList() async {
    _removeFromWishListCubit.removeFromWishList(widget.id);
  }

  onWishTap() {
    if (context.read<IsLoggedInCubit>().state == false) {
      fToast.showToast(
          child: ToastBody(
        text: context.resources.strings.mustLogIn,
        iconColor: Theme.of(context).colorScheme.redColor,
        bgColor: Theme.of(context).colorScheme.toastBackGround,
      ));
    } else {
      // fToast.showToast(
      //     child: ToastBody(
      //   bgColor: Theme.of(context).colorScheme.toastBackGround,
      //   text: context.resources.strings.loading,
      // ));
      if (_isInWishListCubit.state) {
        removeFromWishList();
      } else {
        addToWishList();
      }
    }
  }

  void fetchAndSetVariantWiseInfo({bool changeAppbarString = true}) async {
    var colorString = _colorList.isNotEmpty
        ? _colorList[_chosedColorIndexCubit.state]
            .toString()
            .replaceAll("#", "")
        : "";
    _productVariantBloc
        .add(FetchProductVariants(widget.id, colorString, _choiceString));
  }

  void reset() {
    restProductDetailValues();
    _productImageList.clear();
    _colorList.clear();
    _selectedChoices.clear();
    _relatedProducts.clear();
    _topProducts.clear();
    _choiceString = "";
    _chosedColorIndexCubit.save(0);
    _productQuantityCubit.save(1);
    _isInWishListCubit.save(false);
    _quantityController.clear();
    _productAppBarStringCubit.save("...");
    _productSinglePriceCubit.save(0);
    _productSinglePriceStringCubit.save("");
    variantDiscountPriceCubit.save("");
    _productStockCubit.save(-1);
    _productVariantCubit.save("");
    _productTotalPriceCubit.save(0);
  }

  void restProductDetailValues() {
    _productAppBarStringCubit.save(" . . .");
    _productDetails = null;
    _productImageList.clear();
    // _currentImage = 0;
  }

  void calculateTotalPrice() {
    if (_productQuantityCubit.state == 0) {
      _productTotalPriceCubit.save(_productSinglePriceCubit.state);
    } else {
      _productTotalPriceCubit.save(_productSinglePriceCubit.state);
    }
  }

  void _onVariantChange(choiceOptionsIndex, value) {
    _selectedChoices[choiceOptionsIndex] = value;
    setChoiceString();
    fetchAndSetVariantWiseInfo();
  }

  void _onColorChange(index) {
    _chosedColorIndexCubit.save(index);
    fetchAndSetVariantWiseInfo();
  }

  void onPressAddToCart(context, snackbar) {
    addToCart(mode: "add_to_cart", context: context, snackbar: snackbar);
  }

  void onPressBuyNow(context) {
    addToCart(mode: "buy_now", context: context);
  }

  addToCart({mode, required BuildContext context, snackbar}) async {
    if (context.read<IsLoggedInCubit>().state) {
      if (_productQuantityCubit.state > _productStockCubit.state) {
        fToast.showToast(
            child: ToastBody(
          text: context.resources.strings.outOfStockWarning,
          iconColor: Theme.of(context).colorScheme.redColor,
          bgColor: Theme.of(context).colorScheme.toastBackGround,
        ));
      } else {
        _cartDataNetworkCubit.addToCart(
            _productDetails.id,
            _productVariantCubit.state,
            UserRepo().user.id,
            _productQuantityCubit.state);
        if (mode == "buy_now") {
          if (_productQuantityCubit.state >= _productDetails.minPurchaseQty) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return const CartScreen();
            }));
          }
        }
      }
    } else {
      fToast.showToast(
        child: ToastBody(
          text: context.resources.strings.mustLogIn,
          iconColor: Theme.of(context).colorScheme.redColor,
          bgColor: Theme.of(context).colorScheme.toastBackGround,
        ),
      );
      var res =
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LoginScreen(
          prevCountry: UserRepo().country,
        );
      }));
      if (res != null && res == true) {
        _checkIfInUserWishListCubit.checkIfnUserWishlist(widget.id);
      }
    }
  }

  void onPressShare(context) async {
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(_productDetails.link,
        subject: _productAppBarStringCubit.state,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  Future<bool> _willPopCallback() async {
    // _productQuantityCubit.save(1);
    Navigator.of(context).pop(true);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    SnackBar addedToCartSnackbar = SnackBar(
      content: Text(context.resources.strings.addedToCart),
      action: SnackBarAction(
        label: context.resources.strings.showCart,
        onPressed: () {
          Navigator.of(context).maybePop(true);
          context.read<CurrentScreenCubit>().change(2);
        },
      ),
    );
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Directionality(
        textDirection:
            context.read<LocalizationCubit>().state == const Locale('ar', '')
                ? TextDirection.rtl
                : TextDirection.ltr,
        child: Scaffold(
            key: _scaffoldKey,
            extendBodyBehindAppBar: true,
            backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
            bottomNavigationBar: Container(
              color: Colors.transparent,
              height: context.resources.dimension.middleContainerSize,
              child: Center(
                child: Container(
                  height: context.resources.dimension.priceContainer,
                  width: MediaQuery.of(context).size.width / 1.5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.scaffoldColor,
                    // boxShadow: boxShadowDetails,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.lamisColor,
                        width: 1.5),
                    borderRadius: BorderRadius.circular(
                        context.resources.dimension.veryHighElevation),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width:
                            (MediaQuery.of(context).size.width / 1.5) / 2 - 1.5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              onPressAddToCart(context, addedToCartSnackbar);
                            },
                            child: CustomText(
                              content: context.resources.strings.addToCart,
                              titletype: TitleType.bottoms,
                              minTextSize: 14,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryTextColor,
                              language: Language.center,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: context.resources.dimension.selectedBorder,
                        color: Theme.of(context).colorScheme.lamisColor,
                      ),
                      SizedBox(
                        width:
                            (MediaQuery.of(context).size.width / 1.5) / 2 - 2.5,
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.heavyImpact();
                            onPressBuyNow(context);
                          },
                          child: CustomText(
                            content: context.resources.strings.buyNow,
                            // AppLocalizations.of(context).product_details_screen_button_buy_now,
                            titletype: TitleType.bottoms,

                            color:
                                Theme.of(context).colorScheme.primaryTextColor,
                            language: Language.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            appBar: buildAppBar(statusBarHeight, context),
            body: BlocListener<ProductVariantBloc, ProductVariantState>(
              bloc: _productVariantBloc,
              listener: (context, state) {
                if (state is ProductVariantLoading) {
                  fToast.showToast(
                      child: ToastBody(
                    bgColor: Theme.of(context).colorScheme.toastBackGround,
                    text: context.resources.strings.loading,
                  ));
                }
                if (state is ProductVariantDone) {
                  _productSinglePriceCubit.save(state.response.price);
                  _productStockCubit.save(state.response.stock ?? 0);

                  _productQuantityCubit.save(1);
                  _quantityController.text = 1.toString();

                  _productVariantCubit.save(state.response.variant ?? '');
                  calculateTotalPrice();
                  _productSinglePriceStringCubit
                      .save(state.response.priceString ?? '');

                  variantDiscountPriceCubit
                      .save(state.response.basePriceString ?? '');
                  _productAppBarStringCubit.save(
                      "${state.response.variant} ${state.response.priceString}");

                  int pindex = 0;
                  _productDetails.photos.forEach((photo) {
                    if (photo.variant == _productVariantCubit.state &&
                        state.response.image != "") {
                      _chosedIndexCubit.save(pindex);
                    }

                    pindex++;
                  });
                }
              },
              child: BlocListener(
                bloc: _checkIfInUserWishListCubit,
                listener: (context, state) {
                  if (state is CheckIfInUserWishListDone) {
                    _isInWishListCubit.save(state.response.isInWishList!);
                  }
                },
                child: BlocBuilder<ProductsBloc, ProductsState>(
                  bloc: _productDetailsBloc,
                  builder: (context, state) {
                    if (state is ProductDetailsDone) {
                      if (state.product.detailedProducts.isEmpty) {
                        _productDetailsBloc.add(ProductError());
                      } else {
                        _productDetails = state.product.detailedProducts[0];
                        // print(state.product.detailedProducts[0].stockVisibility);

                        if (firstBuild) {
                          setProductDetailValues();
                          firstBuild = false;
                        }
                        return ListView(
                          padding: EdgeInsets.only(
                              top: context.resources.dimension.lightElevation),
                          controller: _mainScrollController,
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          children: [
                            /// build product image
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                context.resources.dimension.highElevation,
                                100,
                                context.resources.dimension.highElevation,
                                context.resources.dimension.defaultMargin,
                              ),
                              child: buildProductImageSection(),
                            ),

                            ///product name reviews rating

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        BlocBuilder(
                                          bloc: _productTotalPriceCubit,
                                          builder: (context, state) {
                                            return CustomText(
                                              content: _productDetails
                                                      .currencySymbol +
                                                  " " +
                                                  _productTotalPriceCubit.state
                                                      .toStringAsFixed(2),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .redColor,
                                              titletype: TitleType.subtitle,
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        _productDetails.hasDiscount
                                            ? BlocBuilder(
                                                bloc: variantDiscountPriceCubit,
                                                builder: (context, state) {
                                                  return CustomText(
                                                    content:
                                                        variantDiscountPriceCubit
                                                            .state,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .subText,
                                                    titletype:
                                                        TitleType.bottoms,
                                                    textDecore: TextDecoration
                                                        .lineThrough,
                                                  );
                                                },
                                              )
                                            : Container(),
                                      ],
                                    ),
                                    // CustomText(
                                    //   content: _productDetails.priceHighLow,
                                    //   color:
                                    //       Theme.of(context).colorScheme.subText,
                                    //   titletype: TitleType.bottoms,
                                    // ),
                                    _productDetails != null
                                        ? SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: CustomText(
                                              maxlines: 2,
                                              content:
                                                  _productDetails.name ?? " ",
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryTextColor,
                                              titletype: TitleType.subtitle,
                                              language: context
                                                          .read<
                                                              LocalizationCubit>()
                                                          .state ==
                                                      const Locale('ar', '')
                                                  ? Language.rtl
                                                  : Language.ltr,
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        CustomText(
                                          content:
                                              "${context.resources.strings.reviews}:",
                                          titletype: TitleType.bottoms,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryTextColor,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: context.resources
                                                  .dimension.verySmallMargin),
                                          child: CustomText(
                                            // "4.2",
                                            content:
                                                "(${_productDetails.ratingCount})",
                                            titletype: TitleType.bottoms,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryTextColor,
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
                                    GestureDetector(
                                        onTap: () {
                                          HapticFeedback.heavyImpact();
                                          if (context
                                              .read<IsLoggedInCubit>()
                                              .state) {
                                            showRatingBottomSheet();
                                          } else {
                                            fToast.showToast(
                                              child: ToastBody(
                                                text: context.resources.strings
                                                    .mustLogIn,
                                                bgColor: Theme.of(context)
                                                    .colorScheme
                                                    .toastBackGround,
                                                iconColor: Theme.of(context)
                                                    .colorScheme
                                                    .redColor,
                                              ),
                                              gravity: ToastGravity.CENTER,
                                              toastDuration:
                                                  const Duration(seconds: 2),
                                            );
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .yellowColor,
                                              size: 30,
                                            ),
                                            CustomText(
                                              content:
                                                  "${_productDetails.rating}/5",
                                              titletype: TitleType.subtitle,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryTextColor,
                                            ),
                                          ],
                                        )
                                        // RatingBar(
                                        //   itemSize:
                                        //       context.resources.dimension.bigMargin,
                                        //   ignoreGestures: true,
                                        //   initialRating: double.parse(
                                        //       _productDetails.rating.toString()),
                                        //   direction: Axis.horizontal,
                                        //   allowHalfRating: false,
                                        //   itemCount: 5,
                                        //   ratingWidget: RatingWidget(
                                        //       full: Icon(Icons.star,
                                        //           color: Theme.of(context)
                                        //               .colorScheme
                                        //               .yellowColor),
                                        //       empty: Icon(Icons.star_border,
                                        //           color: Theme.of(context)
                                        //               .colorScheme
                                        //               .yellowColor),
                                        //       half: Icon(Icons.star_half,
                                        //           color: Theme.of(context)
                                        //               .colorScheme
                                        //               .yellowColor)),
                                        //   itemPadding: EdgeInsets.only(
                                        //       right: context.resources.dimension
                                        //           .selectedBorder),
                                        //   onRatingUpdate: (rating) {
                                        //     //print(rating);
                                        //   },
                                        // ),
                                        ),
                                  ],
                                ),
                              ],
                            ).customMargins(),
                            const FixedHieght(),

                            const FixedHieght(),
                            buildClubPointRow().customMargins(),
                            const FixedHieght(),

                            ///brands
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  content: context.resources.strings.brand,
                                  titletype: TitleType.subtitle,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryTextColor,
                                ),
                                BrandImage(
                                    // boxShadowDetails: boxShadowDetails,
                                    productDetails: _productDetails),
                              ],
                            ).customMargins(),
                            const FixedHieght(),

                            ///colors
                            buildColorRow(),

                            ///quantity
                            BlocListener(
                              bloc: _cartDataNetworkCubit,
                              listener: (context, state) {
                                if (state is CartDataNetworkGetMessage) {
                                  context
                                      .read<MainPageCartCubit>()
                                      .fetchRemoteData();
                                  fToast.showToast(
                                      child: ToastBody(
                                    text: state.message,
                                    bgColor: Theme.of(context)
                                        .colorScheme
                                        .toastBackGround,
                                  ));
                                }
                              },
                              child: buildQuantityRow(),
                            ),

                            ///options
                            buildChoiceOptionList(),
                            const FixedHieght(),

                            ///description
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  content:
                                      context.resources.strings.description,
                                  titletype: TitleType.subtitle,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryTextColor,
                                ),
                                Html(data: _productDetails.description),
                              ],
                            ).customMargins(),

                            const FixedHieght(),
                            Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width / 3,
                                height: 2,
                                color: Theme.of(context)
                                    .colorScheme
                                    .lamisColor
                                    .withOpacity(0.6),
                              ),
                            ),
                            const FixedHieght(),

                            ///reviews
                            BlocBuilder<ProductReviewCubit, ProductReviewState>(
                              bloc: productReviewCubit,
                              builder: (context, state) {
                                if (state is ProductReviewLoading) {
                                  return SizedBox(
                                    height: 300,
                                    child: ListView.builder(
                                      itemCount: 2,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return DelayedAnimation(
                                          delay: index * 100,
                                          fromSide: FromSide.right,
                                          child: const ReviewCardShimmer(),
                                        );
                                      },
                                    ),
                                  );
                                }
                                if (state is ProductReviewDone) {
                                  if (state.response?.reviews?.isEmpty ??
                                      true) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomText(
                                              content: context
                                                  .resources.strings.reviews,
                                              titletype: TitleType.subtitle,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryTextColor,
                                            ),
                                            NeumorphismContainer(
                                                child: SizedBox(
                                              height: 35,
                                              child: IconButton(
                                                iconSize: 20,
                                                icon: CustomText(
                                                  content: context
                                                      .resources.strings.add,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .lamisColor,
                                                ),
                                                onPressed: () {
                                                  if (context
                                                      .read<IsLoggedInCubit>()
                                                      .state) {
                                                    showRatingBottomSheet();
                                                  } else {
                                                    fToast.showToast(
                                                      child: ToastBody(
                                                        text: context.resources
                                                            .strings.mustLogIn,
                                                        bgColor: Theme.of(
                                                                context)
                                                            .colorScheme
                                                            .toastBackGround,
                                                        iconColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .redColor,
                                                      ),
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                      toastDuration:
                                                          const Duration(
                                                              seconds: 2),
                                                    );
                                                  }
                                                },
                                              ),
                                            )),
                                          ],
                                        ),
                                        const FixedHieght(),
                                        SizedBox(
                                          height: context.resources.dimension
                                              .largeContainerSize,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Image(
                                            image: AssetImage(
                                              context
                                                  .resources.images.noReviews,
                                            ),
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                        CustomText(
                                          content: context
                                              .resources.strings.noReviewsYet,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryTextColor
                                              .withOpacity(0.8),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomText(
                                              content: context
                                                  .resources.strings.reviews,
                                              titletype: TitleType.subtitle,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryTextColor,
                                            ),
                                            NeumorphismContainer(
                                                child: SizedBox(
                                              height: 35,
                                              child: IconButton(
                                                iconSize: 20,
                                                icon: CustomText(
                                                  content: context
                                                      .resources.strings.all,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .lamisColor,
                                                ),
                                                onPressed: () async {
                                                  var res =
                                                      await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                    return ReviewsScreen(
                                                      productId: widget.id,
                                                    );
                                                  }));

                                                  if (res) {
                                                    productReviewCubit
                                                        .getReviews(
                                                            productId:
                                                                widget.id);
                                                  }
                                                },
                                              ),
                                            )),
                                          ],
                                        ),
                                        ListView.builder(
                                          padding: EdgeInsets.only(
                                              top: context.resources.dimension
                                                  .lightElevation),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              state.response!.reviews!.length >
                                                      2
                                                  ? 2
                                                  : 1,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return DelayedAnimation(
                                              delay: index * 150,
                                              fromSide: FromSide.right,
                                              child: ReviewCard(
                                                disableEdit: true,
                                                review: state
                                                    .response!.reviews![index],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  }
                                }
                                if (state is ProductReviewError) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    child: Center(
                                      child: CustomErrorWidget(
                                        onTap: () {
                                          productReviewCubit.getReviews(
                                              productId: widget.id);
                                        },
                                      ),
                                    ),
                                  );
                                }
                                return const Icon(Icons.description);
                              },
                            ).customMargins()
                            //
                            // //rate and brand
                            // Column(children: [
                            //   Padding(
                            //       padding: EdgeInsets.fromLTRB(
                            //         context.resources.dimension.highElevation,
                            //         context.resources.dimension.mediumElevation,
                            //         context.resources.dimension.highElevation,
                            //         context.resources.dimension.zeroElevation,
                            //       ),
                            //       child: buildRatingAndWishButtonRow()),
                            //   Padding(
                            //       padding: EdgeInsets.fromLTRB(
                            //         context.resources.dimension.highElevation,
                            //         context.resources.dimension.highElevation,
                            //         context.resources.dimension.highElevation,
                            //         context.resources.dimension.zeroElevation,
                            //       ),
                            //       child: buildBrandRow()),
                            //   Divider(
                            //     height:
                            //         context.resources.dimension.veryHighElevation,
                            //   ),
                            // ]),
                            // //main price row
                            //
                            // Padding(
                            //     padding: EdgeInsets.fromLTRB(
                            //       context.resources.dimension.highElevation,
                            //       context.resources.dimension.mediumElevation,
                            //       context.resources.dimension.highElevation,
                            //       context.resources.dimension.zeroElevation,
                            //     ),
                            //     child: buildMainPriceRow()),
                            //
                            // // points
                            //
                            // Padding(
                            //     padding: EdgeInsets.fromLTRB(
                            //       context.resources.dimension.highElevation,
                            //       context.resources.dimension.mediumElevation,
                            //       context.resources.dimension.highElevation,
                            //       context.resources.dimension.zeroElevation,
                            //     ),
                            //     child: buildClubPointRow()),
                            // // : Container(),
                            // Divider(
                            //   height: context.resources.dimension.veryHighElevation,
                            // ),
                            //
                            // ///choice options list
                            //
                            // buildChoiceOptionList(),
                            //
                            // ///color row
                            // _colorList.isEmpty
                            //     ? Container()
                            //     : Padding(
                            //         padding: EdgeInsets.fromLTRB(
                            //           context.resources.dimension.highElevation,
                            //           context.resources.dimension.highElevation,
                            //           context.resources.dimension.highElevation,
                            //           context.resources.dimension.zeroElevation,
                            //         ),
                            //         child: buildColorRow()),
                            //
                            // Padding(
                            //     padding: EdgeInsets.fromLTRB(
                            //       context.resources.dimension.highElevation,
                            //       context.resources.dimension.mediumElevation,
                            //       context.resources.dimension.highElevation,
                            //       context.resources.dimension.zeroElevation,
                            //     ),
                            //     child: BlocListener(
                            //       bloc: _cartDataNetworkCubit,
                            //       listener: (context, state) {
                            //         if (state is CartDataNetworkGetMessage) {
                            //           fToast.showToast(
                            //               child: ToastBody(
                            //             text: state.message,
                            //             bgColor:
                            //                 Theme.of(context).colorScheme.shadow,
                            //           ));
                            //         }
                            //       },
                            //       child: buildQuantityRow(),
                            //     )),
                            //
                            // Padding(
                            //     padding: EdgeInsets.fromLTRB(
                            //       context.resources.dimension.highElevation,
                            //       context.resources.dimension.highElevation,
                            //       context.resources.dimension.highElevation,
                            //       context.resources.dimension.zeroElevation,
                            //     ),
                            //     child: buildTotalPriceRow()),
                            // Divider(
                            //   height: context.resources.dimension.veryHighElevation,
                            // ),
                            //
                            // InkWell(
                            //   onTap: () {
                            //     Navigator.push(context,
                            //             MaterialPageRoute(builder: (context) {
                            //       return ReviewsScreen(
                            //         productId: widget.id,
                            //       );
                            //     }))
                            //         //     .then((value) {
                            //         //   onPopped(value);
                            //         // })
                            //         ;
                            //   },
                            //   child: SizedBox(
                            //     height: 40,
                            //     child: Padding(
                            //       padding: const EdgeInsets.fromLTRB(
                            //         16.0,
                            //         0.0,
                            //         8.0,
                            //         0.0,
                            //       ),
                            //       child: Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceBetween,
                            //         children: [
                            //           CustomText(
                            //             content: context.resources.strings.reviews,
                            //             // AppLocalizations.of(context).product_details_screen_reviews,
                            //             titletype: TitleType.subtitle,
                            //             color: Theme.of(context)
                            //                 .colorScheme
                            //                 .primaryTextColor,
                            //           ),
                            //           const Spacer(),
                            //           Icon(
                            //             Icons.reviews_outlined,
                            //             // Ionicons.ios_add,
                            //             color: Theme.of(context)
                            //                 .colorScheme
                            //                 .primaryTextColor,
                            //             size: 24,
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        );
                      }
                    }
                    if (state is ProductsError) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Container(
                          padding: EdgeInsets.all(
                              context.resources.dimension.defaultMargin),
                          child: CustomErrorWidget(
                            onTap: () {
                              _productDetailsBloc
                                  .add(FetchProductDetails(widget.id));
                              _checkIfInUserWishListCubit
                                  .checkIfnUserWishlist(widget.id);
                            },
                          ),
                        ),
                      );
                    }
                    return ProductCartShimmer(widget: widget);
                  },
                ),
              ),
            )),
      ),
    );
  }

  Row buildSellerRow(BuildContext context) {
    //print("sl:" + AppConfig.BASE_PATH + _productDetails.shop_logo);
    return Row(
      children: [
        _productDetails.addedBy == "admin"
            ? Container()
            : Padding(
                padding: context.read<LocalizationCubit>().state ==
                        const Locale('ar', '')
                    ? EdgeInsets.only(
                        left: context.resources.dimension.mediumElevation)
                    : EdgeInsets.only(
                        right: context.resources.dimension.mediumElevation),
                child: Container(
                  width: context.resources.dimension.containerSize,
                  height: context.resources.dimension.containerSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        context.resources.dimension.juniorElevation),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.border,
                        width: context.resources.dimension.selectedBorder / 2),
                    //shape: BoxShape.rectangle,
                  ),
                  child: FadeInImage.memoryNetwork(
                    fadeInDuration: const Duration(milliseconds: 10),
                    image: _productDetails.shopLogo,
                    fit: BoxFit.cover,
                    placeholder: kTransparentImage,
                    imageErrorBuilder: (context, object, stacktrace) {
                      return Container(
                          height: context.resources.dimension.bigMargin,
                          width: context.resources.dimension.bigMargin,
                          color: Theme.of(context).colorScheme.lamisColor);
                    },
                  ),
                ),
              ),
        SizedBox(
          width: MediaQuery.of(context).size.width * (.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                content: context.resources.strings.seller,
                titletype: TitleType.body,
                color: Theme.of(context).colorScheme.lamisColor,
                language: context.read<LocalizationCubit>().state ==
                        const Locale('ar', '')
                    ? Language.rtl
                    : Language.ltr,
              ),
              CustomText(
                content: _productDetails.shopName ?? "",
                titletype: TitleType.bottoms,
                color: Theme.of(context).colorScheme.lamisColor,
                language: context.read<LocalizationCubit>().state ==
                        const Locale('ar', '')
                    ? Language.rtl
                    : Language.ltr,
              )
            ],
          ),
        ),
        const Spacer(),
        Container(
            //     child: Row(
            //   children: [
            //     InkWell(
            //       onTap: () {
            //         // if (is_logged_in == false) {
            //         //   ToastComponent.showDialog("You need to log in", context,
            //         //       gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
            //         //   return;
            //         // }
            //
            //         onTapSellerChat();
            //       },
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 4.0),
            //         child: Text(
            //           "chat seller",
            //           // AppLocalizations.of(context).product_details_screen_chat_with_seller,
            //           style: TextStyle(
            //               decoration: TextDecoration.underline,
            //               color: Color.fromRGBO(7, 101, 136, 1),
            //               fontSize: 12,
            //               fontWeight: FontWeight.w600),
            //         ),
            //       ),
            //     ),
            //     Icon(Icons.message, size: 16, color: Color.fromRGBO(7, 101, 136, 1))
            //   ],
            // )
            )
      ],
    );
  }

  Row buildTotalPriceRow() {
    return Row(
      children: [
        Padding(
          padding:
              context.read<LocalizationCubit>().state == const Locale('ar', '')
                  ? EdgeInsets.only(
                      left: context.resources.dimension.mediumElevation)
                  : EdgeInsets.only(
                      right: context.resources.dimension.mediumElevation),
          child: SizedBox(
            width: context.resources.dimension.priceContainer,
            child: CustomText(
              content: context.resources.strings.totalPrice,
              color: Theme.of(context).colorScheme.subText,
              titletype: TitleType.bottoms,
              language: context.read<LocalizationCubit>().state ==
                      const Locale('ar', '')
                  ? Language.rtl
                  : Language.ltr,
            ),
          ),
        ),
        BlocBuilder(
          bloc: _productTotalPriceCubit,
          builder: (context, state) {
            return CustomText(
              // "total price",
              content: _productDetails.currencySymbol +
                  _productTotalPriceCubit.state.toString(),
              titletype: TitleType.bottoms,
              color: Theme.of(context).colorScheme.subText,
              language: context.read<LocalizationCubit>().state ==
                      const Locale('ar', '')
                  ? Language.rtl
                  : Language.ltr,
            );
          },
        )
      ],
    );
  }

  Widget buildQuantityRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              context.read<LocalizationCubit>().state == const Locale('ar', '')
                  ? EdgeInsets.only(
                      left: context.resources.dimension.mediumElevation,
                      bottom: context.resources.dimension.defaultMargin)
                  : EdgeInsets.only(
                      right: context.resources.dimension.mediumElevation,
                      bottom: context.resources.dimension.defaultMargin),
          child: SizedBox(
            width: context.resources.dimension.priceContainer,
            child: CustomText(
              content: context.resources.strings.quantity,
              titletype: TitleType.subtitle,
              color: Theme.of(context).colorScheme.primaryTextColor,
              language: context.read<LocalizationCubit>().state ==
                      const Locale('ar', '')
                  ? Language.rtl
                  : Language.ltr,
            ),
          ),
        ),
        Row(
          children: [
            Container(
              height: context.resources.dimension.extraHighElevation,
              // width: context.resources.dimension.middleContainerSize,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      context.resources.dimension.defaultMargin),
                  color: Theme.of(context).colorScheme.background),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  buildQuantityDownButton(),
                  BlocBuilder(
                    bloc: _productQuantityCubit,
                    builder: (context, state) {
                      int val = 1;
                      return Container(
                          color: Theme.of(context).colorScheme.background,
                          width:
                              context.resources.dimension.middleContainerSize,
                          child: Center(
                              child: BlocBuilder(
                            bloc: _productStockCubit,
                            builder: (context, state) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 3),
                                child: Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: TextField(
                                    controller: _quantityController,
                                    onEditingComplete: () {
                                      _productQuantityCubit.save(val);
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    onChanged: (value) {
                                      if (_quantityController.text.isNotEmpty) {
                                        val =
                                            int.parse(_quantityController.text);
                                        if (val > _productStockCubit.state) {
                                          fToast.showToast(
                                              gravity: ToastGravity.CENTER,
                                              child: ToastBody(
                                                bgColor: Theme.of(context)
                                                    .colorScheme
                                                    .toastBackGround,
                                                iconColor: Theme.of(context)
                                                    .colorScheme
                                                    .redColor,
                                                text:
                                                    "${context.resources.strings.availableStockQuantity}${_productStockCubit.state}",
                                              ));
                                          val = _productStockCubit.state;
                                          _quantityController.text =
                                              val.toString();
                                          _productQuantityCubit.save(val);
                                        } else {
                                          _quantityController.text =
                                              val.toString();
                                          _productQuantityCubit.save(val);
                                          _quantityController.selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset:
                                                          _quantityController
                                                              .text.length));
                                        }
                                      } else {
                                        _quantityController.clear();
                                      }
                                    },
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(
                                          _productStockCubit.state
                                              .toString()
                                              .length),
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]'))
                                    ],
                                    keyboardType:
                                        const TextInputType.numberWithOptions(),
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        errorText: null,
                                        filled: true,
                                        fillColor: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        hintText: _productQuantityCubit.state
                                            .toString(),
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryTextColor
                                              .withOpacity(0.7),
                                        )),
                                  ),
                                ),
                              );
                            },
                          )));
                    },
                  ),
                  buildQuantityUpButton()
                ],
              ),
            ),
            buildQuantity(_productDetails.stockVisibility),
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //       horizontal: context.resources.dimension.mediumElevation),
            //   child: BlocBuilder(
            //     bloc: _productStockCubit,
            //     builder: (context, state) {
            //       return buildQuantity(_productDetails.stockVisibility);
            //     },
            //   ),
            // )
          ],
        ),
      ],
    ).customMargins();
  }

  Widget buildQuantity(String stockVisibility) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: context.resources.dimension.mediumElevation),
      child: BlocBuilder(
        bloc: _productStockCubit,
        builder: (context, state) {
          if (stockVisibility == "quantity") {
            return CustomText(
              content: _productStockCubit.state == 0
                  ? context.resources.strings.outOfStock
                  : "${_productStockCubit.state} ${context.resources.strings.available}",
              // "(${_stock} ${AppLocalizations.of(context).product_details_screen_available})",
              titletype: TitleType.bottoms,
              color: Theme.of(context).colorScheme.subText,
              language: context.read<LocalizationCubit>().state ==
                      const Locale('ar', '')
                  ? Language.rtl
                  : Language.ltr,
            );
          } else if (stockVisibility == "text") {
            return CustomText(
              content: _productStockCubit.state == 0
                  ? context.resources.strings.outOfStock
                  : context.resources.strings.inStock,
              // "(${_stock} ${AppLocalizations.of(context).product_details_screen_available})",
              titletype: TitleType.bottoms,
              color: Theme.of(context).colorScheme.subText,
              language: context.read<LocalizationCubit>().state ==
                      const Locale('ar', '')
                  ? Language.rtl
                  : Language.ltr,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget buildChoiceOptionList() {
    return ListView.builder(
      padding: EdgeInsets.only(top: context.resources.dimension.lightElevation),
      itemCount: _productDetails.choiceOptions.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: context.resources.dimension.mediumElevation),
          child: buildChoiceOpiton(_productDetails.choiceOptions, index),
        );
      },
    );
  }

  Widget buildChoiceOpiton(choiceOptions, choiceOptionsIndex) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          context.resources.dimension.highElevation,
          context.resources.dimension.mediumElevation,
          context.resources.dimension.highElevation,
          context.resources.dimension.zeroElevation),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: context.read<LocalizationCubit>().state ==
                    const Locale('ar', '')
                ? EdgeInsets.only(
                    left: context.resources.dimension.mediumElevation,
                    bottom: context.resources.dimension.defaultMargin)
                : EdgeInsets.only(
                    right: context.resources.dimension.mediumElevation,
                    bottom: context.resources.dimension.defaultMargin),
            child: SizedBox(
              width: context.resources.dimension.priceContainer,
              child: CustomText(
                content: choiceOptions[choiceOptionsIndex].title,
                color: Theme.of(context).colorScheme.primaryTextColor,
                titletype: TitleType.subtitle,
                language: context.read<LocalizationCubit>().state ==
                        const Locale('ar', '')
                    ? Language.rtl
                    : Language.ltr,
              ),
            ),
          ),
          SizedBox(
            height: context.resources.dimension.textFieldHeight,
            width: MediaQuery.of(context).size.width,
            child: Scrollbar(
              controller: _variantScrollController,
              thumbVisibility: false,
              child: ListView.builder(
                itemCount: choiceOptions[choiceOptionsIndex].options.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(
                        context.resources.dimension.mediumMargin),
                    child: buildChoiceItem(
                        choiceOptions[choiceOptionsIndex].options[index],
                        choiceOptionsIndex,
                        index),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildChoiceItem(option, choiceOptionsIndex, index) {
    return Padding(
      padding: EdgeInsets.all(context.resources.dimension.lightElevation),
      child: InkWell(
        onTap: () {
          HapticFeedback.heavyImpact();
          _onVariantChange(choiceOptionsIndex, option);
        },
        child: BlocBuilder(
          bloc: _productVariantBloc,
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.scaffoldColor,
                border: Border.all(
                  color: _selectedChoices[choiceOptionsIndex] == option
                      ? Theme.of(context).colorScheme.lamisColor
                      : Theme.of(context).colorScheme.background,
                  width: 1,
                ),
                boxShadow: _selectedChoices[choiceOptionsIndex] == option
                    ? boxShadowDetails
                    : [],
                borderRadius: BorderRadius.circular(
                    context.resources.dimension.bigMargin),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: context.resources.dimension.smallText,
                    vertical: context.resources.dimension.lightElevation),
                child: Center(
                  child: CustomText(
                    content: option,
                    titletype: _selectedChoices[choiceOptionsIndex] == option
                        ? TitleType.bottoms
                        : TitleType.body,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                    language: Language.center,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildColorRow() {
    return _colorList.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: context.resources.dimension.priceContainer,
                child: CustomText(
                  content: context.resources.strings.color,
                  titletype: TitleType.subtitle,
                  color: Theme.of(context).colorScheme.primaryTextColor,
                  language: context.read<LocalizationCubit>().state ==
                          const Locale('ar', '')
                      ? Language.rtl
                      : Language.ltr,
                ),
              ),
              SizedBox(
                height: context.resources.dimension.listImageSize,
                width: MediaQuery.of(context).size.width -
                    context.resources.dimension.middleContainerSize,
                child: Scrollbar(
                  controller: _colorScrollController,
                  thumbVisibility: false,
                  child: ListView.builder(
                    itemCount: _colorList.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom:
                                context.resources.dimension.mediumElevation),
                        child: buildColorItem(index),
                      );
                    },
                  ),
                ),
              )
            ],
          ).customMargins();
  }

  Widget buildColorItem(index) {
    return Padding(
      padding:
          EdgeInsets.only(right: context.resources.dimension.mediumElevation),
      child: InkWell(
        onTap: () {
          HapticFeedback.heavyImpact();
          _onColorChange(index);
        },
        child: BlocBuilder(
          bloc: _chosedColorIndexCubit,
          builder: (context, state) {
            return Container(
              height: context.resources.dimension.containerSize,
              width: context.resources.dimension.containerSize,
              decoration: BoxDecoration(
                border: Border.all(
                    color: _chosedColorIndexCubit.state == index
                        ? ColorHelper.getColorFromColorCode(_colorList[index])
                        : Theme.of(context).colorScheme.background,
                    width: 2),
                borderRadius: BorderRadius.circular(
                    context.resources.dimension.highElevation),
                color: Theme.of(context).colorScheme.background,
              ),
              child: Padding(
                padding:
                    EdgeInsets.all(context.resources.dimension.lightElevation),
                child: Container(
                  height: context.resources.dimension.veryHighElevation,
                  width: context.resources.dimension.veryHighElevation,
                  decoration: BoxDecoration(
                    // border: Border.all(
                    //     color: Theme.of(context).colorScheme.border,
                    //     width: context.resources.dimension.selectedBorder),
                    borderRadius: BorderRadius.circular(
                        context.resources.dimension.highElevation),
                    color: ColorHelper.getColorFromColorCode(_colorList[index]),
                  ),
                  // color: ColorHelper.getColorFromColorCode(_colorList[index]),
                  child: _chosedColorIndexCubit.state == index
                      ? buildColorCheckerContainer()
                      : Container(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildColorCheckerContainer() {
    return Padding(
      padding: EdgeInsets.all(context.resources.dimension.juniorElevation),
      child: Icon(Icons.check,
          color: Theme.of(context).colorScheme.selectedBorder,
          size: context.resources.dimension.highElevation),
      //     Image.asset(
      //   "assets/white_tick.png",
      //   width: 16,
      //   height: 16,
      // )
    );
  }

  Widget buildClubPointRow() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              context.read<LocalizationCubit>().state == const Locale('ar', '')
                  ? EdgeInsets.only(
                      left: context.resources.dimension.mediumElevation)
                  : EdgeInsets.only(
                      right: context.resources.dimension.mediumElevation),
          child: SizedBox(
            width: context.resources.dimension.priceContainer,
            child: CustomText(
              content: context.resources.strings.point,
              // AppLocalizations.of(context).product_details_screen_club_point,
              language: context.read<LocalizationCubit>().state ==
                      const Locale('ar', '')
                  ? Language.rtl
                  : Language.ltr,
              color: Theme.of(context).colorScheme.primaryTextColor,
              titletype: TitleType.subtitle,
            ),
          ),
        ),
        NeumorphismContainer(
          child: Padding(
            padding: EdgeInsets.all(context.resources.dimension.mediumMargin),
            child: CustomText(
              // "",
              content: _productDetails.earnPoint.toString(),

              color: Theme.of(context).colorScheme.subText,
              titletype: TitleType.bottoms,
            ),
          ),
        ),
      ],
    );
  }

  Row buildMainPriceRow() {
    return Row(
      children: [
        Padding(
          padding:
              context.read<LocalizationCubit>().state == const Locale('ar', '')
                  ? EdgeInsets.only(
                      left: context.resources.dimension.mediumElevation)
                  : EdgeInsets.only(
                      right: context.resources.dimension.mediumElevation),
          child: SizedBox(
            width: context.resources.dimension.priceContainer,
            child: CustomText(
              content: context.resources.strings.price,
              // AppLocalizations.of(context).product_details_screen_price,
              color: Theme.of(context).colorScheme.subText,
              titletype: TitleType.bottoms,
              language: context.read<LocalizationCubit>().state ==
                      const Locale('ar', '')
                  ? Language.rtl
                  : Language.ltr,
            ),
          ),
        ),
        _productDetails.hasDiscount
            ? BlocBuilder(
                bloc: variantDiscountPriceCubit,
                builder: (context, state) {
                  return Padding(
                    padding: EdgeInsets.only(
                        right: context.resources.dimension.mediumElevation),
                    child: CustomText(
                      content: variantDiscountPriceCubit.state,
                      textDecore: TextDecoration.lineThrough,
                      color: Theme.of(context).colorScheme.subText,
                      titletype: TitleType.bottoms,
                      language: context.read<LocalizationCubit>().state ==
                              const Locale('ar', '')
                          ? Language.rtl
                          : Language.ltr,
                    ),
                  );
                },
              )
            : Container(),
        BlocBuilder(
          bloc: _productSinglePriceStringCubit,
          builder: (context, state) {
            return CustomText(
              content: _productSinglePriceStringCubit.state,
              titletype: TitleType.bottoms,
              color: Theme.of(context).colorScheme.subText,
              language: context.read<LocalizationCubit>().state ==
                      const Locale('ar', '')
                  ? Language.rtl
                  : Language.ltr,
            );
          },
        )
      ],
    );
  }

  AppBar buildAppBar(double statusBarHeight, BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      leading: Builder(
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: NeumorphismContainer(
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Theme.of(context).colorScheme.lamisColor,
                ),
                onPressed: () {
                  _willPopCallback();
                },
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              ),
            ),
          );
        },
      ),
      // title: SizedBox(
      //   height: kToolbarHeight +
      //       statusBarHeight -
      //       (MediaQuery.of(context).viewPadding.top > 40
      //           ? context.resources.dimension.containerSize
      //           : context.resources.dimension.defaultMargin),
      //   //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
      //   child: BlocBuilder(
      //     bloc: _productAppBarStringCubit,
      //     builder: (context, state) {
      //       return SizedBox(
      //           width: context.resources.dimension.largeContainerSize,
      //           child: Padding(
      //             padding: EdgeInsets.only(
      //                 top: context.resources.dimension.bigMargin),
      //             child: CustomText(
      //               content: _productAppBarStringCubit.state,
      //               // _appbarPriceString,
      //               titletype: TitleType.bottoms,
      //               color: Theme.of(context).colorScheme.primaryTextColor,
      //               language: Language.center,
      //             ),
      //           ));
      //     },
      //   ),
      // ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: NeumorphismContainer(
            child: IconButton(
              icon: Icon(
                Icons.share_outlined,
                color: Theme.of(context).colorScheme.lamisColor,
                size: 20,
              ),
              onPressed: () {
                onPressShare(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildRatingAndWishButtonRow() {
    return Row(
      children: const [],
    );
  }

  // Widget buildBrandRow() {
  //   return _productDetails.brand.id > 0
  //       ? InkWell(
  //           onTap: () {
  //             // Navigator.push(context, MaterialPageRoute(builder: (context) {
  //             //   return BrandProducts(id: _productDetails.brand.id,brand_name: _productDetails.brand.name,);
  //             // }));
  //           },
  //           child: Row(
  //             children: [
  //               Padding(
  //                 padding: context.read<LocalizationCubit>().state ==
  //                         const Locale('ar', '')
  //                     ? EdgeInsets.only(
  //                         left: context.resources.dimension.mediumElevation)
  //                     : EdgeInsets.only(
  //                         right: context.resources.dimension.mediumElevation),
  //                 child: SizedBox(
  //                   width: context.resources.dimension.priceContainer,
  //                   child: CustomText(
  //                     content: context.resources.strings.brand,
  //                     // AppLocalizations.of(context).product_details_screen_brand,
  //                     titletype: TitleType.bottoms,
  //                     color: Theme.of(context).colorScheme.subText,
  //                     language: context.read<LocalizationCubit>().state ==
  //                             const Locale('ar', '')
  //                         ? Language.rtl
  //                         : Language.ltr,
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.symmetric(
  //                     horizontal: context.resources.dimension.lightElevation),
  //                 child: CustomText(
  //                   content: _productDetails.brand.name ?? "",
  //                   color: Theme.of(context).colorScheme.subText,
  //                   titletype: TitleType.bottoms,
  //                   language: context.read<LocalizationCubit>().state ==
  //                           const Locale('ar', '')
  //                       ? Language.rtl
  //                       : Language.ltr,
  //                 ),
  //               ),
  //               const Spacer(),
  //             ],
  //           ),
  //         )
  //       : Container();
  // }

  Widget buildTopSellingProductList() {
    if (_topProductInit == false && _topProducts.isEmpty) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: context.resources.dimension.mediumElevation),
            child: Container(
              height: context.resources.dimension.priceContainer,
              color: Theme.of(context).colorScheme.cardColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: context.resources.dimension.mediumElevation),
            child: Container(
              height: context.resources.dimension.priceContainer,
              color: Theme.of(context).colorScheme.cardColor,
            ),
            // child: ShimmerHelper().buildBasicShimmer(
            //   height: 75.0,
            // )
          ),
          Padding(
            padding: EdgeInsets.only(
                top: context.resources.dimension.mediumElevation),
            child: Container(
              height: context.resources.dimension.priceContainer,
              color: Theme.of(context).colorScheme.cardColor,
            ),
            // child: ShimmerHelper().buildBasicShimmer(
            //   height: 75.0,
            // )
          ),
        ],
      );
    } else if (_topProducts.isNotEmpty) {
      return SingleChildScrollView(
        child: ListView.builder(
          itemCount: _topProducts.length,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
                padding: EdgeInsets.only(
                    bottom: context.resources.dimension.verySmallMargin),
                child: Container()
                // ListProductCard(
                //     id: _topProducts[index].id,
                //     image: _topProducts[index].thumbnail_image,
                //     name: _topProducts[index].name,
                //     main_price: _topProducts[index].main_price,
                //     stroked_price: _topProducts[index].stroked_price,
                //     has_discount: _topProducts[index].has_discount),
                );
          },
        ),
      );
    } else {
      return SizedBox(
          height: context.resources.dimension.middleContainerSize,
          child: Center(
              child: CustomText(
            content: context.resources.strings.sellingProduct,
            // AppLocalizations.of(context).product_details_screen_no_top_selling_product,
            titletype: TitleType.bottoms,
            color: Theme.of(context).colorScheme.subText,
            language: context.read<LocalizationCubit>().state ==
                    const Locale('ar', '')
                ? Language.rtl
                : Language.ltr,
          )));
    }
  }

  SizedBox buildQuantityUpButton() => SizedBox(
        width: context.resources.dimension.extraHighElevation,
        child: BlocBuilder(
          bloc: _productQuantityCubit,
          builder: (context, state) {
            return NeumorphismContainer(
              child: IconButton(
                  icon: Icon(Icons.add,
                      // FontAwesome.plus,
                      size: context.resources.dimension.defaultMargin,
                      color: Theme.of(context).colorScheme.primaryTextColor),
                  onPressed: () {
                    if (_productQuantityCubit.state <
                        _productStockCubit.state) {
                      _productQuantityCubit
                          .save(_productQuantityCubit.state + 1);
                      _quantityController.text =
                          "${_productQuantityCubit.state}";
                      // setState(() {});
                      calculateTotalPrice();
                    } else {
                      fToast.showToast(
                          child: ToastBody(
                        text:
                            "${context.resources.strings.availableStockQuantity}${_productStockCubit.state}",
                        iconColor: Theme.of(context).colorScheme.redColor,
                        bgColor: Theme.of(context).colorScheme.toastBackGround,
                      ));
                    }
                  }),
            );
          },
        ),
      );

  SizedBox buildQuantityDownButton() => SizedBox(
      width: context.resources.dimension.extraHighElevation,
      child: BlocBuilder(
        bloc: _productQuantityCubit,
        builder: (context, state) {
          return NeumorphismContainer(
            child: IconButton(
                icon: Icon(Icons.remove_sharp,
                    // FontAwesome.minus,
                    size: context.resources.dimension.defaultMargin,
                    color: Theme.of(context).colorScheme.primaryTextColor),
                onPressed: () {
                  if (_productQuantityCubit.state > 1) {
                    _productQuantityCubit.save(_productQuantityCubit.state - 1);
                    _quantityController.text = "${_productQuantityCubit.state}";
                    // setState(() {});
                    calculateTotalPrice();
                  }
                  if (_productQuantityCubit.state == 1) {
                    fToast.showToast(
                        child: ToastBody(
                      text: context.resources.strings.noMoreMinus,
                      iconColor: Theme.of(context).colorScheme.redColor,
                      bgColor: Theme.of(context).colorScheme.toastBackGround,
                    ));
                  } else if (_productStockCubit.state == 0) {
                    fToast.showToast(
                        child: ToastBody(
                      text: context.resources.strings.outOfStockWarning,
                      iconColor: Theme.of(context).colorScheme.redColor,
                      bgColor: Theme.of(context).colorScheme.toastBackGround,
                    ));
                  }
                }),
          );
        },
      ));

  showOverlay(BuildContext context) {}

  Future<dynamic> openPhotoDialog(BuildContext context, path) => showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(
                    context.resources.dimension.circularImageBorderRadius)),
                child: FadeInImage.memoryNetwork(
                  fadeInDuration: const Duration(milliseconds: 10),
                  placeholder: kTransparentImage,
                  image: path,
                  fit: BoxFit.fitHeight,
                  imageErrorBuilder: (context, object, stacktrace) {
                    return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(context.resources
                                  .dimension.circularImageBorderRadius),
                              bottomRight: Radius.circular(context.resources
                                  .dimension.circularImageBorderRadius)),
                          color: Theme.of(context).colorScheme.lamisColor,
                        ),
                        height: context.resources.dimension.bigMargin,
                        width: context.resources.dimension.bigMargin,
                        color: Theme.of(context).colorScheme.cardColor);
                  },
                )),

            // Align(
            //   alignment: Alignment.topRight,
            //   child: Container(
            //     decoration: ShapeDecoration(
            //       color: Theme.of(context).colorScheme.disabledColor,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.all(
            //           Radius.circular(
            //               context.resources.dimension.veryHighElevation),
            //         ),
            //       ),
            //     ),
            //     width: context.resources.dimension.listImageSize,
            //     height: context.resources.dimension.listImageSize,
            //     child: IconButton(
            //       icon: Icon(Icons.clear,
            //           color: Theme.of(context).colorScheme.selectedBorder),
            //       onPressed: () {
            //         Navigator.of(context, rootNavigator: true).pop();
            //       },
            //     ),
            //   ),
            // ),
          );
        },
      );

  Widget buildProductImageSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 2.5,
          width: 110,
          child: BlocBuilder(
            bloc: _chosedIndexCubit,
            builder: (context, state) {
              return Scrollbar(
                controller: _imageScrollController,
                thumbVisibility: false,
                thickness: context.resources.dimension.lightElevation,
                child: Padding(
                  padding:
                      // app_language_rtl.$ ? EdgeInsets.only(left: 8.0) :
                      EdgeInsets.only(
                          right: context.resources.dimension.smallMargin),
                  child: ListView.builder(
                      padding: EdgeInsets.all(
                          context.resources.dimension.lightElevation),
                      itemCount: _productImageList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        int itemIndex = index;
                        return GestureDetector(
                          onTap: () {
                            _chosedIndexCubit.save(itemIndex);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(
                                context.resources.dimension.mediumMargin),
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                boxShadow: boxShadowDetails,
                                borderRadius: BorderRadius.circular(
                                    context.resources.dimension.mediumMargin),
                                color:
                                    Theme.of(context).colorScheme.scaffoldColor,
                                border: Border.all(
                                    color: _chosedColorIndexCubit.state + 1 ==
                                            itemIndex
                                        ? Theme.of(context)
                                            .colorScheme
                                            .lamisColor
                                        : Theme.of(context)
                                            .colorScheme
                                            .colorForBubbles,
                                    width: _chosedIndexCubit.state == itemIndex
                                        ? 3
                                        : 1),
                                shape: BoxShape.rectangle,
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(context
                                      .resources.dimension.defaultMargin),
                                  child:
                                      /*Image.asset(
                                          singleProduct.product_images[index])*/
                                      FadeInImage.memoryNetwork(
                                    fadeInDuration:
                                        const Duration(milliseconds: 10),
                                    placeholder: kTransparentImage,
                                    image: _productImageList[index],
                                    fit: BoxFit.contain,
                                    imageErrorBuilder:
                                        (context, object, stacktrace) {
                                      return Container(
                                          height: context
                                              .resources.dimension.bigMargin,
                                          width: context
                                              .resources.dimension.bigMargin,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .lamisColor);
                                    },
                                  )),
                            ),
                          ),
                        );
                      }),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 2.5,
          width: MediaQuery.of(context).size.width - 150,
          child: Stack(
            children: [
              InkWell(
                onTap: () {
                  openPhotoDialog(
                      context, _productImageList[_chosedIndexCubit.state]);
                },
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 2.5,
                  width: MediaQuery.of(context).size.width - 150,
                  child: BlocBuilder(
                    bloc: _chosedIndexCubit,
                    builder: (context, state) {
                      return FadeInImage.memoryNetwork(
                        fadeInDuration: const Duration(milliseconds: 10),
                        placeholder: kTransparentImage,
                        image: _productImageList.isNotEmpty
                            ? _productImageList[_chosedIndexCubit.state]
                            : "",
                        fit: BoxFit.fitHeight,
                        imageErrorBuilder: (context, object, stacktrace) {
                          return Container(
                            height: context.resources.dimension.bigMargin,
                            width: context.resources.dimension.bigMargin,
                            color: Theme.of(context).colorScheme.shadow400,
                            child: Icon(
                              Icons.image_outlined,
                              size: 100,
                              color: Theme.of(context).colorScheme.shadow200,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Align(
                alignment: context.read<LocalizationCubit>().state ==
                        const Locale('ar', '')
                    ? Alignment.bottomLeft
                    : Alignment.bottomRight,
                child: BlocListener(
                  bloc: _removeFromWishListCubit,
                  listener: (context, state) {
                    if (state is RemoveFromWishListDone) {
                      _isInWishListCubit.save(state.response.isInWishList!);
                    }
                  },
                  child: BlocListener(
                    bloc: _addToWishListCubit,
                    listener: (context, state) {
                      if (state is AddToWishListDone) {
                        _isInWishListCubit.save(state.response.isInWishList!);
                      }
                    },
                    child: BlocBuilder(
                      bloc: _isInWishListCubit,
                      builder: (context, state) {
                        return InkWell(
                          focusColor: Colors.transparent,
                          onTap: () {
                            fToast.showToast(
                                child: ToastBody(
                              bgColor:
                                  Theme.of(context).colorScheme.toastBackGround,
                              text: context.resources.strings.loading,
                            ));
                            onWishTap();
                          },
                          child: NeumorphismContainer(
                            active: _isInWishListCubit.state,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                _isInWishListCubit.state
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                // FontAwesome.heart_o,
                                color: Theme.of(context).colorScheme.redColor,
                                size: context
                                    .resources.dimension.extraHighElevation,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showRatingBottomSheet() {
    BottomSheets.showModal(context,
        hasOpacity: true,
        type: BottomSheetType.small,
        child: ReviewModalSheet(
          productId: widget.id,
        ));
  }
}

class BrandImage extends StatelessWidget {
  const BrandImage({
    Key? key,
    // required this.boxShadowDetails,
    required productDetails,
  })  : _productDetails = productDetails,
        super(key: key);

  // final List<BoxShadow> boxShadowDetails;
  // ignore: prefer_typing_uninitialized_variables
  final dynamic _productDetails;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return BrandProducts(
            id: _productDetails.brand.id,
            brandName: _productDetails.brand.name,
          );
        }));
      },
      child: Container(
        padding: EdgeInsets.all(context.resources.dimension.lightElevation),
        width: context.resources.dimension.extraHighElevation,
        height: context.resources.dimension.extraHighElevation,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
                context.resources.dimension.verySmallMargin),
            // boxShadow: boxShadowDetails,
            color: Theme.of(context).colorScheme.scaffoldColor,
            border: Border.all(color: Theme.of(context).colorScheme.lamisColor)
            //shape: BoxShape.rectangle,
            ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(
                context.resources.dimension.defaultMargin),
            child: FadeInImage.memoryNetwork(
              fadeInDuration: const Duration(milliseconds: 10),
              placeholder: kTransparentImage,
              image: _productDetails.brand.logo,
              fit: BoxFit.contain,
              imageErrorBuilder: (context, object, stacktrace) {
                return SizedBox(
                  width: context.resources.dimension.extraHighElevation,
                  height: context.resources.dimension.extraHighElevation,
                  child: Image(
                    image: AssetImage(
                      context.resources.images.orderPlacedIcon,
                    ),
                    fit: BoxFit.fitWidth,
                  ),
                );
              },
            )),
      ),
    );
  }
}

class ProductCartShimmer extends StatelessWidget {
  const ProductCartShimmer({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final ProductDetails widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 100,
        ),
        Row(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2.5,
              width: 110,
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(5.0),
                  itemCount: 4,
                  itemBuilder: (BuildContext context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                context.resources.dimension.bigMargin),
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      Theme.of(context).colorScheme.shadow400,
                                  offset: const Offset(4, 4),
                                  blurRadius: 10,
                                  spreadRadius: 1),
                              BoxShadow(
                                  color:
                                      Theme.of(context).colorScheme.shadow200,
                                  offset: const Offset(3, 3),
                                  blurRadius: 10,
                                  spreadRadius: 1),
                              BoxShadow(
                                  color:
                                      Theme.of(context).colorScheme.shadow100,
                                  offset: const Offset(-4, -4),
                                  blurRadius: 10,
                                  spreadRadius: 1),
                            ]),
                      ),
                    );
                  }),
            ),
            Stack(
              children: [
                Center(
                  child: Hero(
                    tag: "product-image",
                    child: ClipRRect(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                            bottom: Radius.circular(16)),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                end: Alignment.bottomLeft,
                                begin: Alignment.topRight,
                                colors: Theme.of(context)
                                    .colorScheme
                                    .blueShadeLiner),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              ShimmerContainer(),
              ShimmerContainer(),
              ShimmerContainer(),
              ShimmerContainer(),
              ShimmerContainer(),
              ShimmerContainer(),
              ShimmerContainer()
            ],
          ).customMargins(),
        ),
      ],
    );
  }
}

class ReviewModalSheet extends StatefulWidget {
  const ReviewModalSheet({Key? key, required this.productId}) : super(key: key);
  final int productId;

  @override
  State<ReviewModalSheet> createState() => _ReviewModalSheetState();
}

class _ReviewModalSheetState extends State<ReviewModalSheet> {
  final ProductReviewCubit _productReviewCubit = ProductReviewCubit();

  TextEditingController productReviewController = TextEditingController();
  FToast fToast = FToast();
  double reviewRating = 0.0;

  @override
  void initState() {
    super.initState();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductReviewCubit, ProductReviewState>(
      bloc: _productReviewCubit,
      listener: (context, state) {
        if (state is ProductReviewDone) {
          Navigator.of(context).maybePop(true);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ReviewsScreen(
              productId: widget.productId,
            );
          }));
        }
        if (state is ProductReviewError) {
          fToast.showToast(
            child: ToastBody(
              text: state.message,
              iconColor: Theme.of(context).colorScheme.redColor,
              bgColor: Theme.of(context).colorScheme.toastBackGround,
            ),
            gravity: ToastGravity.CENTER,
            toastDuration: const Duration(seconds: 2),
          );
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: context.resources.dimension.bigMargin),
              child: RatingBar(
                itemSize: context.resources.dimension.extraHighElevation,
                ignoreGestures: (state is ProductReviewLoading) ? true : false,
                initialRating: 0.0,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                ratingWidget: RatingWidget(
                    full: Icon(Icons.star,
                        color: Theme.of(context).colorScheme.yellowColor),
                    empty: Icon(Icons.star_border,
                        color: Theme.of(context).colorScheme.yellowColor),
                    half: Icon(Icons.star_half,
                        color: Theme.of(context).colorScheme.yellowColor)),
                itemPadding: EdgeInsets.only(
                    right: context.resources.dimension.selectedBorder),
                onRatingUpdate: (rating) {
                  reviewRating = rating;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: context.resources.dimension.defaultMargin,
                  right: context.resources.dimension.defaultMargin,
                  left: context.resources.dimension.defaultMargin),
              child: SizedBox(
                height: context.resources.dimension.textFieldHeight + 8,
                child: CustomTextField(
                  titleState: false,
                  hint: context.resources.strings.comment,
                  onChange: (value) {
                    productReviewController.text = value;
                  },
                  label: '',
                  enabled: (state is ProductReviewLoading) ? false : true,
                ),
              ),
            ),
            (state is ProductReviewLoading)
                ? CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.lamisColor,
                  )
                : CustomButton(
                    onPress: () {
                      _productReviewCubit.submitReview(
                          comment: productReviewController.text,
                          rating: reviewRating,
                          productId: widget.productId);
                    },
                    content: context.resources.strings.add,
                  ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    fToast.removeCustomToast();
    fToast.removeQueuedCustomToasts();
    super.dispose();
  }
}

class Indicator extends StatelessWidget {
  const Indicator({Key? key, required this.link, required this.offset})
      : super(key: key);

  final LayerLink link;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformFollower(
      offset: offset,
      link: link,
      child: Container(
        color: Colors.green,
      ),
    );
  }
}
