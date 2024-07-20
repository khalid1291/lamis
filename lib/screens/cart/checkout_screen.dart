import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lamis/cubits/cart/cart_summary/cart_summary_cubit.dart';
import 'package:lamis/cubits/cart/show_loader_cubit.dart';
import 'package:lamis/cubits/cubits.dart';
import 'package:lamis/models/models.dart';
import 'package:lamis/repos/repos.dart';
import 'package:lamis/res/resources_export.dart';
import 'package:lamis/screens/screens.dart';
import 'package:lamis/widgets/widgets.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key, required this.postSelectedAddresCubit})
      : super(key: key);
  final PostSelectedAddresCubit postSelectedAddresCubit;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with SingleTickerProviderStateMixin {
  late CheckOutCartCubit _checkOutCartCubit;
  late SelectedPaymentMethodCubit _choosedPaymentMethodCubit;
  late GetPaymentTypesCubit _getPaymentTypesCubit;
  late CartSummaryCubit _cartSummaryCubit;
  late ShowLoaderCubit _showLoaderCubit;
  // late GetUserAddressesCubit _getUserAddressesCubit;
  // late PostSelectedAddresCubit _postSelectedAddresCubit;

  late TextEditingController _couponController;
  late TextEditingController _noteController;
  FToast fToast = FToast();

  late AnimationController _controller;
  late List<Bubble> bubbles;
  final int numberOfBubbles = 75;
  final Color color = const Color(0xFF8EC3DF);
  final double maxBubbleSize = 75.0;

  void updateBubblePosition() {
    for (var it in bubbles) {
      it.updatePosition();
    }
    setState(() {});
  }

  @override
  void initState() {
    _getPaymentTypesCubit = GetPaymentTypesCubit()..getPaymentTypes();
    _choosedPaymentMethodCubit = SelectedPaymentMethodCubit("");
    _checkOutCartCubit = CheckOutCartCubit();
    _cartSummaryCubit = CartSummaryCubit()..getCartSummary();
    _couponController = TextEditingController();
    _noteController = TextEditingController();
    _showLoaderCubit = ShowLoaderCubit(false);
    // _getUserAddressesCubit = GetUserAddressesCubit()..getAddresses();
    // _postSelectedAddresCubit = PostSelectedAddresCubit();
    fToast.init(context);
    bubbles = [];
    int i = numberOfBubbles;
    while (i > 0) {
      bubbles.add(Bubble(color, maxBubbleSize));
      i--;
    }

    // Init animation controller

    super.initState();
  }

  Future<bool> _willPopCallback() async {
    Navigator.pop(context, true);
    return Future.value(false);
  }

  double myWalletBallance = 0.0;
  double grandTotalValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: CustomAppBar(
          title: context.resources.strings.checkout,
        ),
        resizeToAvoidBottomInset: true,
        body: BlocListener(
          bloc: _showLoaderCubit,
          listener: (context, state) {},
          child: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  children: [
                    // const FixedHieght(),
                    // the container in background with primary color
                    // addresses(),
                    const FixedHieght(
                      extra: true,
                    ),
                    Center(
                      child: CustomText(
                        content: context.resources.strings.totalSummery,
                        color: Theme.of(context).colorScheme.lamisColor,
                        titletype: TitleType.subtitle,
                      ),
                    ),

                    const FixedHieght(),
                    summary(),
                    const FixedHieght(
                      extra: true,
                    ),
                    // the main content of the page
                    SizedBox(
                        height: 150,
                        child: BlocBuilder<GetPaymentTypesCubit,
                            GetPaymentTypesState>(
                          bloc: _getPaymentTypesCubit,
                          builder: (context, state) {
                            if (state is GetPaymentTypesLoading) {
                              return const CardTypShimmer();
                            }
                            if (state is GetPaymentTypesDone) {
                              return Column(
                                children: [
                                  CustomText(
                                    content:
                                        context.resources.strings.paymentMethod,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .lamisColor,
                                    titletype: TitleType.subtitle,
                                  ),
                                  SizedBox(
                                    height: 120,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: state.paymentsTypes.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              HapticFeedback.heavyImpact();
                                              _choosedPaymentMethodCubit.save(
                                                  state.paymentsTypes[index]
                                                      .paymentTypeKey!);
                                            },
                                            child: _PaymentCard(
                                              index: index,
                                              paymentTypeResponse:
                                                  state.paymentsTypes[index],
                                              selected:
                                                  _choosedPaymentMethodCubit,
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              );
                            }
                            if (state is GetPaymentTypesError) {
                              return CustomErrorWidget(
                                onTap: () {
                                  _getPaymentTypesCubit.getPaymentTypes();
                                },
                              );
                            }
                            return const CardTypShimmer();
                          },
                        )),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          content: context.resources.strings.addNote,
                          titletype: TitleType.subtitle,
                          color: Theme.of(context).colorScheme.lamisColor,
                        ),
                        CustomTextField(
                            controller: _noteController,
                            label: context.resources.strings.note,
                            onChange: (val) {}),
                      ],
                    ).customMargins(),

                    // the listener for sending requests on app button and the app button
                    const SizedBox(
                      height: 60,
                    ),
                    BlocListener<CheckOutCartCubit, CheckOutCartState>(
                      bloc: _checkOutCartCubit,
                      listener: (context, state) {
                        if (state is CheckOutCartLoading) {
                          if (_choosedPaymentMethodCubit.state ==
                              "cash_on_delivery") {
                            _controller = AnimationController(
                                duration: const Duration(seconds: 1000),
                                vsync: this);
                            _controller.addListener(() {
                              updateBubblePosition();
                            });
                            _controller.forward();
                            _showLoaderCubit.save(true);
                          }
                          if (_choosedPaymentMethodCubit.state == "wallet") {
                            _controller = AnimationController(
                                duration: const Duration(seconds: 1000),
                                vsync: this);
                            _controller.addListener(() {
                              updateBubblePosition();
                            });
                            _controller.forward();
                            _showLoaderCubit.save(true);
                          }
                          fToast.showToast(
                              child: ToastBody(
                            text: context.resources.strings.loading,
                            bgColor:
                                Theme.of(context).colorScheme.toastBackGround,
                            textColor: Theme.of(context).colorScheme.subText,
                            icon: Icons.loop,
                          ));
                        }
                        if (state is CheckOutCartDone) {
                          _showLoaderCubit.save(false);

                          if (_choosedPaymentMethodCubit.state ==
                              "cash_on_delivery") {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) {
                              return const OrderList(
                                fromCheckout: true,
                              );
                            }), (route) => route.isFirst);
                          } else if (_choosedPaymentMethodCubit.state ==
                              "wallet") {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) {
                              return const OrderList(
                                fromCheckout: true,
                              );
                            }), (route) => route.isFirst);
                          } else {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return WebViewScreen(
                                  orderId: state.res.combinedOrderId!,
                                  paymentType: _choosedPaymentMethodCubit.state,
                                  userId: UserRepo().user.id);
                            }));
                          }
                          context.read<MainPageCartCubit>().fetchRemoteData();
                        }
                        if (state is CheckOutCartError) {
                          _showLoaderCubit.save(false);
                          fToast.showToast(
                              child: ToastBody(
                            text: state.message,
                            bgColor:
                                Theme.of(context).colorScheme.toastBackGround,
                            textColor:
                                Theme.of(context).colorScheme.primaryTextColor,
                            icon: Icons.error_outline,
                            iconColor: Theme.of(context).colorScheme.redColor,
                          ));
                          Navigator.popUntil(context, (route) => route.isFirst);
                        }
                      },
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.heavyImpact();
                          if (_choosedPaymentMethodCubit.state == "") {
                            fToast.showToast(
                                child: ToastBody(
                                  text: context.resources.strings.choosePayment,
                                  bgColor: Theme.of(context)
                                      .colorScheme
                                      .toastBackGround,
                                  textColor: Theme.of(context)
                                      .colorScheme
                                      .primaryTextColor,
                                  iconColor:
                                      Theme.of(context).colorScheme.redColor,
                                ),
                                gravity: ToastGravity.BOTTOM);
                          } else {
                            if (_choosedPaymentMethodCubit.state ==
                                "cash_on_delivery") {
                              _checkOutCartCubit.cashOnDelivery(
                                  _choosedPaymentMethodCubit.state,
                                  _noteController.text);
                            } else if (_choosedPaymentMethodCubit.state ==
                                "wallet") {
                              if (myWalletBallance < grandTotalValue) {
                                fToast.showToast(
                                    child: ToastBody(
                                        text: context
                                            .resources.strings.enoughBalance,
                                        bgColor: Theme.of(context)
                                            .colorScheme
                                            .toastBackGround));
                              } else {
                                _checkOutCartCubit.walletCash(
                                    _choosedPaymentMethodCubit.state,
                                    _noteController.text);
                              }
                            } else {
                              _checkOutCartCubit.checkout(
                                  _choosedPaymentMethodCubit.state,
                                  _noteController.text);
                            }
                          }
                          // else if (_selectedAddressCubit.state != -1) {
                          //   _postSelectedAddresCubit
                          //       .addAddress(_selectedAddressCubit.state);
                          // } else {
                          //   fToast.showToast(
                          //       child: ToastBody(
                          //         text:
                          //             context.resources.strings.chooseAddress,
                          //         bgColor: Theme.of(context)
                          //             .colorScheme
                          //             .toastBackGround,
                          //         textColor: Theme.of(context)
                          //             .colorScheme
                          //             .primaryTextColor,
                          //         iconColor:
                          //             Theme.of(context).colorScheme.redColor,
                          //       ),
                          //       gravity: ToastGravity.BOTTOM);
                          // }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: context
                                  .resources.dimension.extraHighElevation),
                          child: SizedBox(
                            height: 65,
                            width: MediaQuery.of(context).size.width * 0.66,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(context
                                      .resources.dimension.defaultMargin),
                                  color:
                                      Theme.of(context).colorScheme.lamisColor),
                              child: Center(
                                child: CustomText(
                                  content:
                                      context.resources.strings.confirmAndPay,
                                  titletype: TitleType.bottoms,
                                  color: context.resources.color.colorWhite,
                                  language: Language.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const FixedHieght(),
                  ],
                ),
              ),
              if (_showLoaderCubit.state)
                Container(
                  color: Theme.of(context)
                      .colorScheme
                      .scaffoldColor
                      .withOpacity(0.5),
                  child: CustomPaint(
                    foregroundPainter: BubblePainter(
                        bubbles: bubbles, controller: _controller),
                    size: Size(MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    fToast.removeCustomToast();
    fToast.removeQueuedCustomToasts();

    super.dispose();
  }

  // Widget addresses() {
  //   return BlocBuilder<GetUserAddressesCubit, GetUserAddressesState>(
  //     bloc: _getUserAddressesCubit,
  //     builder: (context, state) {
  //       if (state is GetUserAddressesLoading) {
  //         return SizedBox(
  //           height: 200,
  //           child: ListView.builder(
  //               scrollDirection: Axis.horizontal,
  //               physics: const NeverScrollableScrollPhysics(),
  //               shrinkWrap: true,
  //               itemCount: 2,
  //               itemBuilder: (context, index) {
  //                 return DelayedAnimation(
  //                     delay: index * 150,
  //                     child: const AddressCardShimmer().customMargins());
  //               }),
  //         );
  //       }
  //       if (state is GetUserAddressesDone) {
  //         if (state.addressResponse.addresses!.isEmpty) {
  //           return Row(
  //             children: [
  //               PlusButton(
  //                 onPressed: () async {
  //                   var res = await BottomSheets.showModal(context,
  //                       type: BottomSheetType.big,
  //                       hasBorderMargin: true,
  //                       child: const UserInformationScreen());
  //                   if (res != null && res[0]) {
  //                     _getUserAddressesCubit.getAddresses();
  //                   }
  //                 },
  //               ),
  //               const SizedBox(
  //                 width: 40,
  //               ),
  //               Center(
  //                 child: Column(
  //                   children: [
  //                     CustomText(
  //                       content: context.resources.strings.noAddressPleaseAdd,
  //                       color: Theme.of(context).colorScheme.primaryTextColor,
  //                       titletype: TitleType.bottoms,
  //                       language: Language.center,
  //                     ),
  //                     Icon(
  //                       Icons.arrow_back,
  //                       size: 40,
  //                       // AssetImage(context.resources.images.leftArrow),
  //                       color: Theme.of(context).colorScheme.lamisColor,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           );
  //         } else {
  //           return Row(
  //             children: [
  //               PlusButton(
  //                 onPressed: () async {
  //                   var res = await BottomSheets.showModal(context,
  //                       type: BottomSheetType.big,
  //                       hasBorderMargin: true,
  //                       child: const UserInformationScreen());
  //                   if (res != null && res[0]) {
  //                     _getUserAddressesCubit.getAddresses();
  //                   }
  //                 },
  //               ),
  //               SizedBox(
  //                 height: 210,
  //                 width: MediaQuery.of(context).size.width - 60,
  //                 child: ListView.builder(
  //                     scrollDirection: Axis.horizontal,
  //                     shrinkWrap: true,
  //                     itemCount: state.addressResponse.addresses!.length,
  //                     itemBuilder: (context, index) {
  //                       return GestureDetector(
  //                         onTap: () {
  //                           HapticFeedback.heavyImpact();
  //                           _selectedAddressCubit.save(
  //                               state.addressResponse.addresses![index].id!);
  //                         },
  //                         child: DelayedAnimation(
  //                           delay: index * 150,
  //                           fromSide: FromSide.right,
  //                           child: BlocBuilder(
  //                             bloc: _selectedAddressCubit,
  //                             builder: (context, substate) {
  //                               return AddressCard(
  //                                 willPop: () {
  //                                   _getUserAddressesCubit.getAddresses();
  //                                 },
  //                                 address:
  //                                     state.addressResponse.addresses![index],
  //                                 selected: state.addressResponse
  //                                         .addresses![index].id ==
  //                                     _selectedAddressCubit.state,
  //                                 small: true,
  //                               );
  //                             },
  //                           ).customMargins(),
  //                         ),
  //                       );
  //                     }),
  //               ),
  //             ],
  //           );
  //         }
  //       }
  //       if (state is GetUserAddressesError) {
  //         return CustomErrorWidget(
  //           onTap: () {
  //             _getUserAddressesCubit.getAddresses();
  //           },
  //         );
  //       }
  //       return ListView.builder(
  //           physics: const NeverScrollableScrollPhysics(),
  //           shrinkWrap: true,
  //           itemCount: 3,
  //           itemBuilder: (context, index) {
  //             return const AddressCardShimmer().customMargins();
  //           });
  //     },
  //   );
  // }

  Widget summary() {
    return BlocBuilder<CartSummaryCubit, CartSummaryState>(
      bloc: _cartSummaryCubit,
      builder: (context, state) {
        if (state is CartSummaryLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CartSummaryDone) {
          myWalletBallance = state.response.balance ?? 0.0;
          grandTotalValue = state.response.grandTotalValue!;

          if (state.message != "") {
            Fluttertoast.showToast(msg: state.message!);
          }

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    content: context.resources.strings.subTotal,
                    color: Theme.of(context).colorScheme.darkBlue,
                    titletype: TitleType.bottoms,
                  ),
                  CustomText(
                    content: state.response.subTotal ?? '',
                    color: Theme.of(context).colorScheme.darkBlue,
                    titletype: TitleType.bottoms,
                  ),
                ],
              ),

              ///discount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    content: context.resources.strings.discount,
                    color: Theme.of(context).colorScheme.darkBlue,
                    titletype: TitleType.bottoms,
                  ),
                  CustomText(
                    content: state.response.discount ?? '',
                    color: Theme.of(context).colorScheme.darkBlue,
                    titletype: TitleType.bottoms,
                  ),
                ],
              ),

              /// tax
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    content: context.resources.strings.tax,
                    color: Theme.of(context).colorScheme.darkBlue,
                    titletype: TitleType.bottoms,
                  ),
                  CustomText(
                    content: state.response.tax ?? '',
                    color: Theme.of(context).colorScheme.darkBlue,
                    titletype: TitleType.bottoms,
                  ),
                ],
              ),

              /// shipping cost
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    content: context.resources.strings.shippingCost,
                    color: Theme.of(context).colorScheme.darkBlue,
                    titletype: TitleType.bottoms,
                  ),
                  CustomText(
                    content: state.response.shippingCost ?? '',
                    color: Theme.of(context).colorScheme.darkBlue,
                    titletype: TitleType.bottoms,
                  ),
                ],
              ),

              ///delivery price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    content: context.resources.strings.deliveryPrice,
                    color: Theme.of(context).colorScheme.darkBlue,
                    titletype: TitleType.bottoms,
                  ),
                  CustomText(
                    content: state.response.deliveryPrice ?? '',
                    color: Theme.of(context).colorScheme.darkBlue,
                    titletype: TitleType.bottoms,
                  ),
                ],
              ),

              ///grand total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    content: context.resources.strings.grandTotal,
                    color: Theme.of(context).colorScheme.darkBlue,
                    titletype: TitleType.bottoms,
                  ),
                  CustomText(
                    content: state.response.grandTotal ?? '',
                    color: Theme.of(context).colorScheme.darkBlue,
                    titletype: TitleType.bottoms,
                  ),
                ],
              ),
              state.response.couponApplied
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          content: context.resources.strings.coupon,
                          color: Theme.of(context).colorScheme.darkBlue,
                          titletype: TitleType.bottoms,
                        ),
                        CustomText(
                          content: state.response.couponCode ?? '',
                          color: Theme.of(context).colorScheme.darkBlue,
                          titletype: TitleType.bottoms,
                        ),
                      ],
                    )
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    content: context.resources.strings.myWallet,
                    color: Theme.of(context).colorScheme.darkBlue,
                    titletype: TitleType.bottoms,
                  ),
                  CustomText(
                    content: state.response.balanceString ?? '',
                    color: Theme.of(context).colorScheme.darkBlue,
                    titletype: TitleType.bottoms,
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 80,
                child: Stack(
                  children: [
                    // Center(
                    //   child: Container(
                    //     height: context.resources.dimension.textFieldHeight,
                    //     width: 170,
                    //     color: Theme.of(context).colorScheme.cardColor,
                    //   ),
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomTextField(
                              isCheckout: true,
                              controller: _couponController,
                              label: context.resources.strings.coupon,
                              onChange: (val) {}),
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                HapticFeedback.heavyImpact();
                                if (_couponController.text.trim().isNotEmpty) {
                                  if (state.response.couponApplied) {
                                    _couponController.clear();
                                    _cartSummaryCubit.removeCoupon();
                                  } else {
                                    _cartSummaryCubit.addCoupon(
                                        _couponController.text.trim());
                                  }
                                } else {
                                  if (state.response.couponApplied) {
                                    _cartSummaryCubit.removeCoupon();
                                  } else {
                                    fToast.showToast(
                                        child: ToastBody(
                                          text: context
                                              .resources.strings.chooseCoupon,
                                          bgColor: Theme.of(context)
                                              .colorScheme
                                              .toastBackGround,
                                          textColor: Theme.of(context)
                                              .colorScheme
                                              .primaryTextColor,
                                          iconColor: Theme.of(context)
                                              .colorScheme
                                              .redColor,
                                        ),
                                        gravity: ToastGravity.BOTTOM);
                                  }
                                }
                              },
                              child: Container(
                                width: 120,
                                height:
                                    context.resources.dimension.textFieldHeight,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      context.resources.dimension.mediumMargin),
                                  gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: Theme.of(context)
                                          .colorScheme
                                          .blueLiner),
                                ),
                                child: Center(
                                  child: CustomText(
                                    content: state.response.couponApplied
                                        ? context.resources.strings.changeCoupon
                                        : context.resources.strings.applyCoupon,
                                    color: context.resources.color.colorWhite,
                                    titletype: TitleType.bottoms,
                                  ),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ).customMargins();
        }

        if (state is CartSummaryError) {
          Fluttertoast.showToast(msg: state.message);
          return CustomErrorWidget(
            onTap: () {
              _cartSummaryCubit.getCartSummary();
            },
          );
        }
        return Container();
      },
    ).customMargins();
  }
}

//
// class PlusButton extends StatelessWidget {
//   const PlusButton({
//     Key? key,
//     required this.onPressed,
//   }) : super(key: key);
//
//   final Function onPressed;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         HapticFeedback.heavyImpact();
//         onPressed();
//       },
//       child: Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(
//               Radius.circular(context.resources.dimension.mediumMargin),
//             ),
//             boxShadow: [
//               BoxShadow(
//                   color: Theme.of(context).colorScheme.shadow400,
//                   offset: const Offset(4, 4),
//                   blurRadius: 5,
//                   spreadRadius: 1),
//               BoxShadow(
//                   color: Theme.of(context).colorScheme.shadow200,
//                   offset: const Offset(3, 3),
//                   blurRadius: 5,
//                   spreadRadius: 1),
//               BoxShadow(
//                   color: Theme.of(context).colorScheme.shadow200,
//                   offset: const Offset(-3, -3),
//                   blurRadius: 5,
//                   spreadRadius: 1),
//               BoxShadow(
//                   color: Theme.of(context).colorScheme.shadow100,
//                   offset: const Offset(-4, -4),
//                   blurRadius: 5,
//                   spreadRadius: 1),
//             ],
//             color: Theme.of(context).colorScheme.scaffoldColor),
//         width: 50,
//         height: 180,
//         child: Center(
//           child: Icon(
//             Icons.add,
//             color: Theme.of(context).colorScheme.lamisColor,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class CardTypShimmer extends StatelessWidget {
//   const CardTypShimmer({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: 2,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: EdgeInsets.all(context.resources.dimension.highElevation),
//             child: Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(
//                       context.resources.dimension.bigMargin),
//                   border: Border.all(
//                       color: Theme.of(context).colorScheme.cardColor)),
//               child: Column(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(
//                             context.resources.dimension.bigMargin),
//                         topRight: Radius.circular(
//                             context.resources.dimension.bigMargin),
//                       ),
//                       border: Border.all(
//                           color: Theme.of(context).colorScheme.cardColor),
//                       color: Theme.of(context).colorScheme.cardColor,
//                     ),
//                     height: context.resources.dimension.priceContainer,
//                     width: context.resources.dimension.middleContainerSize,
//                   ),
//                   CustomText(
//                     content: "",
//                     titletype: TitleType.subtitle,
//                     color: Theme.of(context).colorScheme.primaryTextColor,
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
// }
//
class _PaymentCard extends StatelessWidget {
  const _PaymentCard({
    Key? key,
    required this.index,
    required this.paymentTypeResponse,
    required this.selected,
  }) : super(key: key);
  final int index;
  final PaymentTypeResponse paymentTypeResponse;
  final SelectedPaymentMethodCubit selected;
  @override
  Widget build(BuildContext context) {
    return DelayedAnimation(
      delay: index * 150,
      fromSide: FromSide.right,
      child: Padding(
        padding: EdgeInsets.all(context.resources.dimension.highElevation),
        child: BlocBuilder(
          bloc: selected,
          builder: (context, state) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              padding:
                  EdgeInsets.all(context.resources.dimension.lightElevation),
              decoration: BoxDecoration(
                boxShadow: selected.state == paymentTypeResponse.paymentTypeKey
                    ? [
                        BoxShadow(
                            color: Theme.of(context).colorScheme.shadow400,
                            offset: const Offset(4, 4),
                            blurRadius: 10,
                            spreadRadius: 1),
                        BoxShadow(
                            color: Theme.of(context).colorScheme.shadow400,
                            offset: const Offset(3, 3),
                            blurRadius: 10,
                            spreadRadius: 1),
                        BoxShadow(
                            color: Theme.of(context).colorScheme.shadow200,
                            offset: const Offset(-3, -3),
                            blurRadius: 10,
                            spreadRadius: 1),
                        BoxShadow(
                            color: Theme.of(context).colorScheme.shadow100,
                            offset: const Offset(-4, -4),
                            blurRadius: 10,
                            spreadRadius: 1),
                      ]
                    : [],
                borderRadius: BorderRadius.circular(
                    context.resources.dimension.bigMargin),
              ),
              child: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  height: 100,
                  imageUrl: paymentTypeResponse.image ?? '',
                  fadeOutDuration: const Duration(seconds: 1),
                  fadeInDuration: const Duration(seconds: 3),
                  errorWidget: (context, url, error) => Image(
                    image: AssetImage(
                      context.resources.images.noProduct,
                    ),
                    height: 100,
                    width: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
