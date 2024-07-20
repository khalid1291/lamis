import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lamis/res/resources_export.dart';

import '../../cubits/cubits.dart';
import '../../models/models.dart';
import '../../repos/repos.dart' show UserRepo;
import '../../widgets/widgets.dart';
import '../screens.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartLocalDataCubit _cartLocalDataCubit;
  late CartTotalPriceCubit _cartTotalPriceCubit;
  late CartCheckoutAvailableCubit _cartCheckoutAvailableCubit;
  late CartProcessCubit _cartProcessCubit;
  FToast fToast = FToast();

  @override
  void initState() {
    _cartLocalDataCubit = CartLocalDataCubit();
    if (context.read<IsLoggedInCubit>().state) {
      _cartLocalDataCubit.fetchRemoteData();
    }
    _cartTotalPriceCubit = CartTotalPriceCubit(0);
    _cartCheckoutAvailableCubit = CartCheckoutAvailableCubit(false);
    _cartProcessCubit = CartProcessCubit();
    fToast.init(context);

    super.initState();
  }

  void countPrice(List<CartItem> items) {
    double sum = 0;
    for (int i = 0; i < items.length; i++) {
      double n = items[i].price! * items[i].quantity!.toDouble();
      sum += n;
    }
    _cartTotalPriceCubit.save(sum);
  }

  List cartItems = [];
  List cartQuantities = [];
  String cartItemsString = "";
  String cartQuantitiesString = "";

  void fillLists(List cart) {
    cartItems.clear();
    cartQuantities.clear();
    for (CartItem element in cart) {
      cartItems.add(element.id);
      cartQuantities.add(element.quantity);
    }
  }

  void makeStrings() {
    cartItemsString = cartItems.join(',').toString();
    cartQuantitiesString = cartQuantities.join(',').toString();
  }

  fetchAll() {
    // _cartLocalDataCubit.emit(CartLocalDataInitial());
    _cartTotalPriceCubit.save(0);
    _cartProcessCubit.save(CartProcessInitial());
    if (context.read<IsLoggedInCubit>().state) {
      _cartLocalDataCubit.fetchRemoteData();
    }

    context.read<MainPageCartCubit>().fetchRemoteData();

    fToast.init(context);
  }

  int itemCount = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: fetchAll(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        appBar: CustomAppBar(
          title: context.resources.strings.cart,
        ),
        body: Directionality(
          textDirection:
              context.read<LocalizationCubit>().state == const Locale('ar', '')
                  ? TextDirection.rtl
                  : TextDirection.ltr,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FixedHieght(),
                context.watch<IsLoggedInCubit>().state
                    ? SingleChildScrollView(
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height - 230,
                              child: BlocListener(
                                bloc: context.watch<IsLoggedInCubit>(),
                                listener: (context, state) {
                                  if (state == true) {
                                    _cartLocalDataCubit.fetchRemoteData();
                                  }
                                },
                                child: BlocListener(
                                  bloc: _cartProcessCubit,
                                  listener: (context, state) async {
                                    if (state is CartProcessLoading) {
                                      fToast.showToast(
                                          child: ToastBody(
                                        text: context.resources.strings.loading,
                                        bgColor: Theme.of(context)
                                            .colorScheme
                                            .toastBackGround,
                                        textColor: Theme.of(context)
                                            .colorScheme
                                            .primaryTextColor,
                                        icon: Icons.loop,
                                      ));
                                    }
                                    if (state is CartProcessDone) {
                                      var res = await Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return const SelectAddressScreen();
                                      }));
                                      // ignore: unnecessary_null_comparison
                                      if (res != null) {
                                        fetchAll();
                                      }
                                    }
                                    if (state is CartProcessError) {
                                      fToast.showToast(
                                          child: ToastBody(
                                        text: state.message,
                                        // ignore: use_build_context_synchronously
                                        bgColor: Theme.of(context)
                                            .colorScheme
                                            .toastBackGround,
                                        // ignore: use_build_context_synchronously
                                        iconColor: Theme.of(context)
                                            .colorScheme
                                            .redColor,
                                      ));
                                    }
                                  },
                                  child: BlocBuilder<CartLocalDataCubit,
                                      CartLocalDataState>(
                                    bloc: _cartLocalDataCubit,
                                    builder: (context, state) {
                                      if (state is CartLocalDataInitial) {
                                        return const MustLogin()
                                            .customMargins();
                                      }
                                      if (state is CartLocalDataLoading) {
                                        return RefreshIndicator(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .lamisColor,
                                          onRefresh: () {
                                            return fetchAll();
                                          },
                                          child: ListView.builder(
                                              itemCount: 3,
                                              shrinkWrap: true,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return DelayedAnimation(
                                                  delay: index * 5,
                                                  child: const _CartShimmer(),
                                                );
                                              }),
                                        );
                                      }
                                      if (state is CartLocalDataDone) {
                                        if (state.message != null) {
                                          fToast.showToast(
                                              child: ToastBody(
                                            text: state.message!,
                                            bgColor: Theme.of(context)
                                                .colorScheme
                                                .toastBackGround,
                                            icon: Icons.details,
                                          ));
                                        }
                                        context
                                            .read<MainPageCartCubit>()
                                            .fetchRemoteData();
                                        countPrice(state.items);
                                        if (state.items.isEmpty) {
                                          _cartCheckoutAvailableCubit
                                              .save(false);
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image(
                                                image: AssetImage(
                                                  context.resources.images
                                                      .emptyCartImage,
                                                ),
                                                fit: BoxFit.fitWidth,
                                              ),
                                              const FixedHieght(
                                                extra: true,
                                              ),
                                              CustomText(
                                                content: context.resources
                                                    .strings.cartIsEmpty,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .darkBlue,
                                                titletype: TitleType.bottoms,
                                              )
                                            ],
                                          );
                                        } else {
                                          _cartCheckoutAvailableCubit
                                              .save(true);
                                          fillLists(state.items);
                                          return RefreshIndicator(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .lamisColor,
                                            onRefresh: () async {
                                              return fetchAll();
                                            },
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height -
                                                      270,
                                                  child: ListView.builder(
                                                      shrinkWrap: false,
                                                      itemCount:
                                                          state.items.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return DelayedAnimation(
                                                          delay: index * 100,
                                                          child: CartItemCard(
                                                            symbol: state
                                                                .items[index]
                                                                .currencySymbol!,
                                                            stock: state
                                                                .items[index]
                                                                .upperLimit!,
                                                            reload: () {
                                                              _cartLocalDataCubit
                                                                  .fetchRemoteDataForUpdate();
                                                            },
                                                            isfav: state
                                                                .items[index]
                                                                .isFavourite,
                                                            productId: state
                                                                .items[index]
                                                                .productId!,
                                                            image: state
                                                                    .items[
                                                                        index]
                                                                    .productThumbnailImage ??
                                                                "",
                                                            productName: state
                                                                    .items[
                                                                        index]
                                                                    .productName ??
                                                                "",
                                                            quantity: state
                                                                .items[index]
                                                                .quantity,
                                                            price: state
                                                                    .items[
                                                                        index]
                                                                    .price ??
                                                                0,
                                                            variant: state
                                                                    .items[
                                                                        index]
                                                                    .variation ??
                                                                "",
                                                            increase: () {
                                                              fToast.showToast(
                                                                  child:
                                                                      ToastBody(
                                                                bgColor: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .toastBackGround,
                                                                icon:
                                                                    Icons.loop,
                                                                text: context
                                                                    .resources
                                                                    .strings
                                                                    .loading,
                                                              ));
                                                              CartItem item =
                                                                  state.items[
                                                                      index];
                                                              if (item.quantity! ==
                                                                  item.upperLimit) {
                                                                fToast.showToast(
                                                                    child: ToastBody(
                                                                  bgColor: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .toastBackGround,
                                                                  text: context
                                                                          .resources
                                                                          .strings
                                                                          .availableStockQuantity +
                                                                      state
                                                                          .items[
                                                                              index]
                                                                          .upperLimit
                                                                          .toString(),
                                                                  iconColor: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .redColor,
                                                                ));
                                                              } else {
                                                                _cartLocalDataCubit
                                                                    .updateRemoteObject(
                                                                  item.id,
                                                                  item.quantity! +
                                                                      1,
                                                                  UserRepo()
                                                                      .user
                                                                      .id,
                                                                );
                                                              }
                                                            },
                                                            decrease: () {
                                                              CartItem item =
                                                                  state.items[
                                                                      index];
                                                              if (item.quantity! ==
                                                                  1) {
                                                                fToast.showToast(
                                                                    child: ToastBody(
                                                                  text: context
                                                                      .resources
                                                                      .strings
                                                                      .noMoreMinus,
                                                                  bgColor: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .toastBackGround,
                                                                  textColor: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primaryTextColor,
                                                                  iconColor: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .redColor,
                                                                ));
                                                              } else {
                                                                fToast.showToast(
                                                                    child: ToastBody(
                                                                  bgColor: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .toastBackGround,
                                                                  icon: Icons
                                                                      .loop,
                                                                  text: context
                                                                      .resources
                                                                      .strings
                                                                      .loading,
                                                                ));
                                                                if (item.quantity! >
                                                                    item.upperLimit!) {
                                                                  _cartLocalDataCubit.updateRemoteObject(
                                                                      item.id,
                                                                      item
                                                                          .upperLimit!,
                                                                      UserRepo()
                                                                          .user
                                                                          .id);
                                                                } else {
                                                                  _cartLocalDataCubit.updateRemoteObject(
                                                                      item.id,
                                                                      item.quantity! -
                                                                          1,
                                                                      UserRepo()
                                                                          .user
                                                                          .id);
                                                                }
                                                              }
                                                            },
                                                            delete: () {
                                                              _cartLocalDataCubit
                                                                  .deleteRemoteItem(
                                                                      state
                                                                          .items[
                                                                              index]
                                                                          .id,
                                                                      UserRepo()
                                                                          .user
                                                                          .id);
                                                            },
                                                            dismiss: () {
                                                              _cartLocalDataCubit
                                                                  .deleteRemoteItem(
                                                                      state
                                                                          .items[
                                                                              index]
                                                                          .id,
                                                                      UserRepo()
                                                                          .user
                                                                          .id);
                                                            },
                                                          ),
                                                        );
                                                      }),
                                                ),
                                                _TotalWidget(
                                                    symbol: state.items[0]
                                                        .currencySymbol!,
                                                    cartTotalPriceCubit:
                                                        _cartTotalPriceCubit)
                                              ],
                                            ),
                                          );
                                        }
                                      }
                                      if (state is CartLocalDataError) {
                                        return CustomErrorWidget(onTap: () {
                                          _cartLocalDataCubit.fetchRemoteData();
                                        });
                                      }
                                      return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: 3,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return CartItemCard(
                                              stock: 0,
                                              reload: () {},
                                              isfav: false,
                                              productId: -1,
                                              image: "",
                                              symbol: "\$",
                                              productName: "",
                                              increase: () {},
                                              decrease: () {},
                                              delete: () {},
                                              dismiss: () {},
                                            );
                                          });
                                    },
                                  ),
                                ),
                              ).customMargins(),
                            ),
                            SizedBox(
                              height: context.resources.dimension.mediumMargin,
                            ),
                            BlocBuilder(
                              bloc: _cartCheckoutAvailableCubit,
                              builder: (context, state) {
                                if (state == true) {
                                  return CustomButton(
                                    content: context.resources.strings.checkout,
                                    onPress: () {
                                      makeStrings();
                                      _cartProcessCubit.cartProcess(
                                          cartItemsString,
                                          cartQuantitiesString);
                                    },
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                            SizedBox(
                              height: context
                                  .resources.dimension.extraHighElevation,
                            ),
                          ],
                        ),
                      )
                    : const MustLogin().customMargins(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    fToast.removeCustomToast();
    fToast.removeQueuedCustomToasts();
    super.dispose();
  }
}

class _TotalWidget extends StatelessWidget {
  const _TotalWidget({
    Key? key,
    required CartTotalPriceCubit cartTotalPriceCubit,
    required this.symbol,
  })  : _cartTotalPriceCubit = cartTotalPriceCubit,
        super(key: key);

  final CartTotalPriceCubit _cartTotalPriceCubit;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: context.resources.dimension.bigMargin),
      child: Container(
        height: context.resources.dimension.listImageSize,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.scaffoldColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(2),
              topRight: Radius.circular(6),
              bottomLeft: Radius.circular(6),
              bottomRight: Radius.circular(6)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: context.resources.dimension.smallMargin),
              child: CustomText(
                content: "${context.resources.strings.totalPrice}:",
                titletype: TitleType.subtitle,
                color: Theme.of(context).colorScheme.primaryTextColor,
                language: context.read<LocalizationCubit>().state ==
                        const Locale('ar', '')
                    ? Language.rtl
                    : Language.ltr,
              ),
            ),
            BlocBuilder(
              bloc: _cartTotalPriceCubit,
              builder: (context, state) {
                return CustomText(
                  content:
                      "${_cartTotalPriceCubit.state.toStringAsFixed(2)} $symbol",
                  titletype: TitleType.subtitle,
                  color: Theme.of(context).colorScheme.subText,
                  language: context.read<LocalizationCubit>().state ==
                          const Locale('ar', '')
                      ? Language.rtl
                      : Language.ltr,
                );
              },
            )
          ],
        ).customMargins(),
      ),
    );
  }
}

class _CartShimmer extends StatelessWidget {
  const _CartShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(3),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow100,
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(2, 7), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 120,
              width: 140,
              child: Container(
                color: Theme.of(context).colorScheme.cardColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CartItemCard extends StatefulWidget {
  const CartItemCard({
    Key? key,
    this.quantity = 1,
    required this.increase,
    required this.decrease,
    required this.productName,
    required this.image,
    required this.delete,
    this.price = 0,
    required this.dismiss,
    this.variant = "",
    required this.productId,
    required this.isfav,
    required this.reload,
    required this.stock,
    required this.symbol,
  }) : super(key: key);

  final int? quantity;
  final int productId;
  final bool isfav;
  final Function increase;
  final Function decrease;
  final Function delete;
  final String productName;
  final String image;
  final double price;
  final Function dismiss;
  final String variant;
  final Function reload;
  final int stock;
  final String symbol;

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  late DeleteCartItemCubit _deleteCartItemCubit;
  late DeleteItemCounterCubit _deleteItemCounterCubit;

  late AddToWishListCubit _addToWishListCubit;
  FToast fToast = FToast();
  @override
  void initState() {
    _deleteItemCounterCubit = DeleteItemCounterCubit(15);
    _deleteCartItemCubit = DeleteCartItemCubit(false);

    _addToWishListCubit = AddToWishListCubit();
    _timer = Timer(Duration.zero, () {});
    fToast.init(context);
    super.initState();
  }

  late Timer _timer;

  Timer startTimer() {
    var duration = const Duration(seconds: 1);
    return Timer.periodic(
        duration,
        (Timer t) =>
            _deleteItemCounterCubit.change(_deleteItemCounterCubit.state - 1));
  }

  _cancelTimer() {
    if (_timer.isActive) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.productName),
      background: Row(
        children: [
          // IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
          Container(
              height: 160,
              width: context.resources.dimension.priceContainer,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(context.resources.dimension.defaultMargin),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.shadow200,
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(2, 7), // changes position of shadow
                    ),
                  ],
                  color: Theme.of(context).colorScheme.yellowColor),
              child: Icon(
                widget.isfav ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).colorScheme.background,
              ))
        ],
      ),
      onDismissed: (direction) {
        // direction.index
        // dismiss();
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          _cancelTimer();
          _deleteCartItemCubit.save(true);
          _deleteItemCounterCubit.change(15);
          _timer = startTimer();
          return false;
        }
        if (direction == DismissDirection.startToEnd) {
          if (widget.isfav) {
            _addToWishListCubit.removeFromWishList(widget.productId);
          } else {
            _addToWishListCubit.addToWishList(widget.productId);
          }
          return false;
        } else {
          return false;
        }
      },
      secondaryBackground: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              // IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
              Container(
                height: 160,
                width: context.resources.dimension.priceContainer,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                          context.resources.dimension.defaultMargin),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow200,
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset:
                            const Offset(2, 7), // changes position of shadow
                      ),
                    ],
                    color: Colors.red),
                child: const Icon(
                  Icons.delete,
                ),
              )
            ],
          ),
        ],
      ),
      direction: DismissDirection.horizontal,
      // dismissThresholds: {DismissDirection.horizontal: true},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.all(
              Radius.circular(context.resources.dimension.defaultMargin),
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow200,
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(2, 7), // changes position of shadow
              ),
            ],
          ),
          child: Stack(children: [
            BlocListener(
              bloc: _addToWishListCubit,
              listener: (context, state) {
                if (state is AddToWishListError) {
                  fToast.showToast(
                      child: ToastBody(
                    bgColor: Theme.of(context).colorScheme.toastBackGround,
                    iconColor: Theme.of(context).colorScheme.redColor,
                    text: state.message,
                  ));
                }
                if (state is AddToWishListDone) {
                  widget.reload();
                  fToast.showToast(
                      child: ToastBody(
                    text: state.response.message!,
                    bgColor: Theme.of(context).colorScheme.toastBackGround,
                    icon: Icons.favorite,
                    iconColor: Theme.of(context).colorScheme.yellowColor,
                  ));
                }
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          color: Colors.transparent,
                          height: 140,
                          width: 100,
                          child: ClipRRect(
                            clipBehavior: Clip.hardEdge,
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                  context.resources.dimension.defaultMargin),
                            ),
                            child: CachedNetworkImage(
                                // imageUrl: "https://via.placeholder.com/350x200",
                                imageUrl: widget.image,
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
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.cardColor,
                          borderRadius: context
                                      .read<LocalizationCubit>()
                                      .state ==
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
                        height: 160,
                        width: MediaQuery.of(context).size.width - 160,
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
                                    padding: EdgeInsets.only(
                                        left: context
                                                    .read<LocalizationCubit>()
                                                    .state ==
                                                const Locale('ar', '')
                                            ? 0.0
                                            : 10.0,
                                        right: context
                                                    .read<LocalizationCubit>()
                                                    .state ==
                                                const Locale('ar', '')
                                            ? 10
                                            : 0.0),
                                    child: CustomText(
                                      content: widget.productName,
                                      typefont: Typefont.raleway,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryTextColor,
                                      titletype: TitleType.bottoms,
                                      language: context
                                                  .read<LocalizationCubit>()
                                                  .state ==
                                              const Locale('ar', '')
                                          ? Language.rtl
                                          : Language.ltr,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: 30,
                                      left: context
                                                  .read<LocalizationCubit>()
                                                  .state ==
                                              const Locale('ar', '')
                                          ? 0.0
                                          : 10.0,
                                      right: context
                                                  .read<LocalizationCubit>()
                                                  .state ==
                                              const Locale('ar', '')
                                          ? 10
                                          : 0.0),
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
                                                if (widget.isfav) {
                                                  _addToWishListCubit
                                                      .removeFromWishList(
                                                          widget.productId);
                                                } else {
                                                  _addToWishListCubit
                                                      .addToWishList(
                                                          widget.productId);
                                                }
                                              },
                                              icon: Icon(widget.isfav
                                                  ? Icons.favorite
                                                  : Icons.favorite_border),
                                            ),
                                          ))),
                                ),
                              ],
                            )),
                            Center(
                                child: Row(
                              // mainAxisAlignment:
                              //     MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: context
                                                    .read<LocalizationCubit>()
                                                    .state ==
                                                const Locale('ar', '')
                                            ? 0.0
                                            : 10.0,
                                        right: context
                                                    .read<LocalizationCubit>()
                                                    .state ==
                                                const Locale('ar', '')
                                            ? 10
                                            : 0.0),
                                    child: CustomText(
                                      content: widget.variant,
                                      typefont: Typefont.raleway,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryTextColor,
                                      titletype: TitleType.bottoms,
                                      language: context
                                                  .read<LocalizationCubit>()
                                                  .state ==
                                              const Locale('ar', '')
                                          ? Language.rtl
                                          : Language.ltr,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                            Center(
                                child: CustomText(
                              content: "",
                              titletype: TitleType.body,
                              color: Theme.of(context).colorScheme.subText,
                              typefont: Typefont.amiri,
                            )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomText(
                                  content:
                                      "${(widget.price * widget.quantity!).toStringAsFixed(2)} ${widget.symbol}",
                                  titletype: TitleType.bottoms,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.cardColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: context
                                                    .read<LocalizationCubit>()
                                                    .state ==
                                                const Locale('ar', '')
                                            ? const Radius.circular(2.0)
                                            : const Radius.circular(7.0),
                                        topRight: context
                                                    .read<LocalizationCubit>()
                                                    .state ==
                                                const Locale('ar', '')
                                            ? const Radius.circular(7.0)
                                            : const Radius.circular(2.0),
                                        bottomLeft: context
                                                    .read<LocalizationCubit>()
                                                    .state ==
                                                const Locale('ar', '')
                                            ? const Radius.circular(2.0)
                                            : const Radius.circular(7.0),
                                        bottomRight: context
                                                    .read<LocalizationCubit>()
                                                    .state ==
                                                const Locale('ar', '')
                                            ? const Radius.circular(7.0)
                                            : const Radius.circular(2.0)),
                                  ),
                                  height: 40,
                                  width: 40,
                                  child: Center(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      NeumorphismBrands(
                                          blueLiner: true,
                                          neumorphismType: NeumorphismType.icon,
                                          boxShape: BoxShape.circle,
                                          child: SizedBox(
                                            height: 30,
                                            child: IconButton(
                                              iconSize: 12,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryTextColor,
                                              onPressed: () {
                                                widget.decrease();
                                              },
                                              icon: const Icon(
                                                  Icons.remove_sharp),
                                            ),
                                          )),
                                      // SizedBox(
                                      //   height: 2,
                                      // )
                                    ],
                                  )),
                                ),
                                CustomText(
                                  content: "${widget.quantity}",
                                  titletype: TitleType.bottoms,
                                ),
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.cardColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: context
                                                    .read<LocalizationCubit>()
                                                    .state ==
                                                const Locale('ar', '')
                                            ? const Radius.circular(7.0)
                                            : const Radius.circular(2.0),
                                        topRight: context
                                                    .read<LocalizationCubit>()
                                                    .state ==
                                                const Locale('ar', '')
                                            ? const Radius.circular(2.0)
                                            : const Radius.circular(7.0),
                                        bottomLeft: context
                                                    .read<LocalizationCubit>()
                                                    .state ==
                                                const Locale('ar', '')
                                            ? const Radius.circular(7.0)
                                            : const Radius.circular(2.0),
                                        bottomRight: context
                                                    .read<LocalizationCubit>()
                                                    .state ==
                                                const Locale('ar', '')
                                            ? const Radius.circular(2.0)
                                            : const Radius.circular(7.0)),
                                  ),
                                  child: NeumorphismBrands(
                                      blueLiner: true,
                                      neumorphismType: NeumorphismType.icon,
                                      boxShape: BoxShape.circle,
                                      child: SizedBox(
                                        height: 30,
                                        child: IconButton(
                                          iconSize: 12,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryTextColor,
                                          onPressed: () {
                                            widget.increase();
                                          },
                                          icon: const Icon(Icons.add),
                                        ),
                                      )),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    widget.delete();
                                  },
                                  child: Center(
                                      child: ImageIcon(
                                    AssetImage(
                                        context.resources.images.deleteIcon),
                                    size: 30,
                                    // color: Theme.of(context)
                                    //     .colorScheme
                                    //     .iconColor,
                                  )),
                                ),
                              ],
                            ),
                            if (widget.quantity! > widget.stock)
                              SizedBox(
                                height: 15,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      content: context.resources.strings
                                          .availableStockQuantity,
                                      color:
                                          Theme.of(context).colorScheme.subText,
                                      titletype: TitleType.body,
                                      minTextSize: 6,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    CustomText(
                                      content: widget.stock.toString(),
                                      color:
                                          Theme.of(context).colorScheme.subText,
                                      titletype: TitleType.body,
                                      minTextSize: 6,
                                    )
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            BlocBuilder(
              bloc: _deleteCartItemCubit,
              builder: (context, state) {
                if (state == true) {
                  return Container(
                    height: 160,
                    color: Theme.of(context)
                        .colorScheme
                        .scaffoldColor
                        .withOpacity(0.9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _deleteCartItemCubit.save(false);
                              _deleteItemCounterCubit.change(15);
                            },
                            child: CustomText(
                              content: context.resources.strings.undoDelete,
                              language: Language.center,
                              titletype: TitleType.subtitle,
                            ),
                          ),
                        ),
                        BlocBuilder(
                          bloc: _deleteItemCounterCubit,
                          builder: (context, state) {
                            if (state == 0) {
                              widget.dismiss();
                              _deleteItemCounterCubit.change(15);
                              _deleteCartItemCubit.save(false);
                              return Container();
                            } else {
                              return CustomText(
                                content:
                                    _deleteItemCounterCubit.state.toString(),
                                language: Language.center,
                                titletype: TitleType.headline,
                                color: Theme.of(context).colorScheme.redColor,
                              );
                            }
                          },
                        ),
                      ],
                    ).customMargins(),
                  );
                } else {
                  return Container();
                }
              },
            )
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    fToast.removeCustomToast();
    fToast.removeQueuedCustomToasts();
    super.dispose();
  }
}
