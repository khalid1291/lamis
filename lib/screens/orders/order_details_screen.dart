import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../cubits/cubits.dart';
import '../../models/models.dart';
import '../../repos/user/user_repo.dart';
import '../../res/resources_export.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int id;
  final bool fromNotification;
  final bool goBack;

  const OrderDetailsScreen(
      {Key? key,
      required this.id,
      this.fromNotification = false,
      this.goBack = true})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final ScrollController _mainScrollController = ScrollController();
  final _steps = ['pending', 'confirmed', 'on_delivery', 'delivered'];

  // final TextEditingController _refundReasonController = TextEditingController();
  // bool _showReasonWarning = false;

  //init
  int _stepIndex = 0;
  // ignore: prefer_typing_uninitialized_variables
  var _orderDetails;
  //List<dynamic> _orderedItemList = [];
  OrderHistoryItemCubit orderHistoryItemCubit = OrderHistoryItemCubit();
  OrderHistoryDetailsCubit orderHistoryDetailsCubit =
      OrderHistoryDetailsCubit();
  late ReorderTheOrderCubit _reorderTheOrderCubit;
  @override
  void initState() {
    _reorderTheOrderCubit = ReorderTheOrderCubit(false);
    fetchAll();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  fetchAll() {
    fetchOrderDetails();
    //fetchOrderedItems();
  }

  fetchOrderDetails() async {
    orderHistoryDetailsCubit.getOrdersData(orderId: widget.id);
  }

  fetchOrderedItems() async {
    orderHistoryItemCubit.getOrdersDataItem(orderId: widget.id);
  }

  reset() {
    _stepIndex = 0;
    _orderDetails = null;
    //_orderedItemList.clear();
  }

  // Future<void> _onPageRefresh() async {
  //   // reset();
  //   // fetchAll();
  // }

  onPressOfflinePaymentButton() {
    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return Checkout(
    //     order_id: widget.id,
    //     list: "offline",
    //     manual_payment_from_order_details: true,
    //   );
    // })).then((value) {
    //   onPopped(value);
    // });
  }

  onPopped(value) async {
    reset();
    fetchAll();
  }

  int combinedId = -1;
  String paymentType = "";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromNotification || widget.goBack == false) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const OrderList();
          }));
        }
        return true;
      },
      child: Directionality(
        textDirection:
            context.read<LocalizationCubit>().state == const Locale('ar', '')
                ? TextDirection.rtl
                : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
          appBar: CustomAppBar(
            title: context.resources.strings.orderDetails,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Center(
                //   child: CustomText(
                //     content: context.resources.strings.orderDetails,
                //     color: Theme.of(context).colorScheme.primaryTextColor,
                //     titletype: TitleType.subtitle,
                //   ),
                // ),
                Padding(
                    padding: EdgeInsets.all(
                        context.resources.dimension.defaultMargin),
                    child: BlocBuilder(
                      bloc: orderHistoryDetailsCubit,
                      builder: (context, state) {
                        if (state is OrderHistoryDetailsDone) {
                          if (state.orderDetailResponse.detailedOrders![0]
                                  .paymentStatus!
                                  .toLowerCase() ==
                              "unpaid") {
                            _reorderTheOrderCubit.save(true);
                          }
                          _orderDetails =
                              state.orderDetailResponse.detailedOrders![0];
                          combinedId = state.orderDetailResponse
                              .detailedOrders![0].combinedOrderId!;
                          paymentType = state.orderDetailResponse
                              .detailedOrders![0].paymentType!;
                          fetchOrderedItems();

                          return buildTimeLineTiles();
                        } else if (state is OrderHistoryDetailsError) {
                          return Center(
                            child: Column(
                              children: [
                                const FixedHieght(
                                  extra: true,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: context.resources.dimension
                                          .middleContainerSize),
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
                                const FixedHieght(),
                                CustomErrorWidget(
                                  onTap: () {
                                    orderHistoryDetailsCubit.getOrdersData(
                                        orderId: widget.id);
                                  },
                                )
                              ],
                            ),
                          );
                        } else {
                          return const FirstLoadingShimmer();
                        }
                      },
                    )),
                BlocBuilder(
                  bloc: orderHistoryItemCubit,
                  builder: (context, state) {
                    if (state is OrderHistoryItemDone) {
                      return Column(children: [
                        buildOrderDetailsTopCard(),
                        const FixedHieght(
                          extra: true,
                        ),
                        Center(
                          child: CustomText(
                            content: context.resources.strings.orderedProduct,
                            color: Theme.of(context).primaryColor,
                            titletype: TitleType.subtitle,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.all(
                                context.resources.dimension.defaultMargin),
                            child:
                                (state.orderItemResponse.orderedItems.isNotEmpty
                                    ? buildOrderdProductList(
                                        state.orderItemResponse)
                                    : const SizedBox(
                                        height: 100,
                                      ))),
                        Padding(
                          padding: EdgeInsets.all(
                              context.resources.dimension.defaultMargin),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [buildBottomSection()],
                          ),
                        ),
                        buildPaymentButtonSection(),
                      ]);
                      //return Container();
                    } else if (state is OrderHistoryItemInitial) {
                      return Container();
                    } else {
                      return Container(
                        color: Theme.of(context)
                            .colorScheme
                            .lamisColor
                            .withOpacity(0.3),
                        height: 200,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          // body: CustomScrollView(
          //   controller: _mainScrollController,
          //   physics: const BouncingScrollPhysics(
          //       parent: AlwaysScrollableScrollPhysics()),
          //   slivers: [
          //     SliverToBoxAdapter(
          //       child: Padding(
          //           padding: EdgeInsets.all(
          //               context.resources.dimension.defaultMargin),
          //           child: BlocBuilder(
          //             bloc: orderHistoryDetailsCubit,
          //             builder: (context, state) {
          //               if (state is OrderHistoryDetailsDone) {
          //                 if (state.orderDetailResponse.detailedOrders![0]
          //                         .paymentStatus!
          //                         .toLowerCase() ==
          //                     "unpaid") {
          //                   _reorderTheOrderCubit.save(true);
          //                 }
          //                 _orderDetails =
          //                     state.orderDetailResponse.detailedOrders![0];
          //                 combinedId = state.orderDetailResponse
          //                     .detailedOrders![0].combinedOrderId!;
          //                 paymentType = state.orderDetailResponse
          //                     .detailedOrders![0].paymentType!;
          //                 fetchOrderedItems();
          //                 //  setStepIndex(_orderDetails.delivery_status);
          //                 // }
          //
          //                 return buildTimeLineTiles();
          //               } else if (state is OrderHistoryDetailsError) {
          //                 return Center(
          //                   child: Column(
          //                     children: [
          //                       Container(
          //                         margin: EdgeInsets.only(
          //                             top: context.resources.dimension
          //                                 .middleContainerSize),
          //                         height: context
          //                             .resources.dimension.largeContainerSize,
          //                         width: context
          //                             .resources.dimension.largeContainerSize,
          //                         child: const Image(
          //                           image: AssetImage(
          //                             "assets/images/offline.png",
          //                           ),
          //                           fit: BoxFit.fitWidth,
          //                         ),
          //                       ),
          //                       Center(
          //                         child: CustomText(
          //                           content:
          //                               context.resources.strings.pleaseReload,
          //                           color: Theme.of(context)
          //                               .colorScheme
          //                               .lamisColor,
          //                           titletype: TitleType.headline,
          //                           language: Language.center,
          //                         ),
          //                       )
          //                     ],
          //                   ),
          //                 );
          //               } else {
          //                 return const FirstLoadingShimmer();
          //               }
          //             },
          //           )),
          //     ),
          //     SliverList(
          //         delegate: SliverChildListDelegate([
          //       Padding(
          //           padding: EdgeInsets.all(
          //               context.resources.dimension.defaultMargin),
          //           child: BlocBuilder(
          //             bloc: orderHistoryItemCubit,
          //             builder: (context, state) {
          //               if (state is OrderHistoryItemDone) {
          //                 return Column(children: [
          //                   buildOrderDetailsTopCard(),
          //                   Center(
          //                     child: CustomText(
          //                       content:
          //                           context.resources.strings.orderedProduct,
          //                       color: Theme.of(context).primaryColor,
          //                       titletype: TitleType.subtitle,
          //                       language: Language.center,
          //                     ),
          //                   ),
          //                   Padding(
          //                       padding: EdgeInsets.all(
          //                           context.resources.dimension.defaultMargin),
          //                       child: (state.orderItemResponse.orderedItems
          //                               .isNotEmpty
          //                           ? buildOrderdProductList(
          //                               state.orderItemResponse)
          //                           : const SizedBox(
          //                               height: 100,
          //                             ))),
          //                   Padding(
          //                     padding: EdgeInsets.all(
          //                         context.resources.dimension.defaultMargin),
          //                     child: Row(
          //                       mainAxisSize: MainAxisSize.min,
          //                       children: [buildBottomSection()],
          //                     ),
          //                   ),
          //                   buildPaymentButtonSection(),
          //                 ]);
          //                 //return Container();
          //               } else if (state is OrderHistoryItemInitial) {
          //                 return Container();
          //               } else {
          //                 return Container(
          //                   color: Theme.of(context)
          //                       .colorScheme
          //                       .lamisColor
          //                       .withOpacity(0.3),
          //                   height: 200,
          //                 );
          //               }
          //             },
          //           )),
          //     ])),
          //     SliverToBoxAdapter(
          //         child: BlocBuilder(
          //       bloc: _reorderTheOrderCubit,
          //       builder: (context, state) {
          //         if (state == true) {
          //           return AppButton(
          //             onTap: () {
          //               Navigator.push(context,
          //                   MaterialPageRoute(builder: (context) {
          //                 return WebViewScreen(
          //                     orderId: combinedId,
          //                     paymentType: paymentType,
          //                     userId: UserRepo().user.id);
          //               }));
          //             },
          //             buttonText: context.resources.strings.repay,
          //           ).customMargins();
          //         }
          //         return Container();
          //       },
          //     )),
          //     const SliverToBoxAdapter(
          //         child: SizedBox(
          //       height: 40,
          //     )),
          //   ],
          // ),
        ),
      ),
    );
  }

  buildBottomSection() {
    return Expanded(
        child: Directionality(
      textDirection:
          context.read<LocalizationCubit>().state == const Locale('ar', '')
              ? TextDirection.rtl
              : TextDirection.ltr,
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(
                  bottom: context.resources.dimension.smallMargin),
              child: Row(
                children: [
                  SizedBox(
                    // width: 120,
                    // child: CustomText(content: context.resources.strings.subTotal,color: Theme.of(context).primaryColor,titletype: TitleType.subtitle,),
                    child: CustomText(
                      content: context.resources.strings.subTotal,
                      color: Theme.of(context).colorScheme.primaryTextColor,
                      language: context.read<LocalizationCubit>().state ==
                              const Locale('ar', '')
                          ? Language.rtl
                          : Language.ltr,
                      titletype: TitleType.body,
                    ),
                  ),
                  const Spacer(),
                  CustomText(
                    content: _orderDetails.subtotal,
                    language: context.read<LocalizationCubit>().state ==
                            const Locale('ar', '')
                        ? Language.rtl
                        : Language.ltr,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                    titletype: TitleType.body,
                  ),
                ],
              )),
          Padding(
              padding: EdgeInsets.only(
                  bottom: context.resources.dimension.smallMargin),
              child: Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: CustomText(
                      content: context.resources.strings.tax,
                      titletype: TitleType.body,
                      color: Theme.of(context).colorScheme.primaryTextColor,
                      language: context.read<LocalizationCubit>().state ==
                              const Locale('ar', '')
                          ? Language.rtl
                          : Language.ltr,
                    ),
                  ),
                  const Spacer(),
                  CustomText(
                    content: _orderDetails.tax,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                    titletype: TitleType.body,
                    language: context.read<LocalizationCubit>().state ==
                            const Locale('ar', '')
                        ? Language.rtl
                        : Language.ltr,
                  ),
                ],
              )),
          Padding(
              padding: EdgeInsets.only(
                  bottom: context.resources.dimension.smallMargin),
              child: Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: CustomText(
                      content: context.resources.strings.shippingCost,
                      language: context.read<LocalizationCubit>().state ==
                              const Locale('ar', '')
                          ? Language.rtl
                          : Language.ltr,
                      color: Theme.of(context).colorScheme.primaryTextColor,
                      titletype: TitleType.body,
                    ),
                  ),
                  const Spacer(),
                  CustomText(
                    content: _orderDetails.shippingCost,
                    language: context.read<LocalizationCubit>().state ==
                            const Locale('ar', '')
                        ? Language.rtl
                        : Language.ltr,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                    titletype: TitleType.body,
                  ),
                ],
              )),
          Padding(
              padding: EdgeInsets.only(
                  bottom: context.resources.dimension.smallMargin),
              child: Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: CustomText(
                      content: context.resources.strings.discount,
                      language: context.read<LocalizationCubit>().state ==
                              const Locale('ar', '')
                          ? Language.rtl
                          : Language.ltr,
                      color: Theme.of(context).colorScheme.primaryTextColor,
                      titletype: TitleType.body,
                    ),
                  ),
                  const Spacer(),
                  CustomText(
                    content: _orderDetails.couponDiscount,
                    language: context.read<LocalizationCubit>().state ==
                            const Locale('ar', '')
                        ? Language.rtl
                        : Language.ltr,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                    titletype: TitleType.body,
                  ),
                ],
              )),
          Padding(
              padding: EdgeInsets.only(
                  bottom: context.resources.dimension.smallMargin),
              child: Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: CustomText(
                      content: context.resources.strings.deliveryPrice,
                      language: context.read<LocalizationCubit>().state ==
                              const Locale('ar', '')
                          ? Language.rtl
                          : Language.ltr,
                      color: Theme.of(context).colorScheme.primaryTextColor,
                      titletype: TitleType.body,
                    ),
                  ),
                  const Spacer(),
                  CustomText(
                    content: _orderDetails.deliveryMethodPrice,
                    language: context.read<LocalizationCubit>().state ==
                            const Locale('ar', '')
                        ? Language.rtl
                        : Language.ltr,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                    titletype: TitleType.body,
                  ),
                ],
              )),
          SizedBox(
            width: 120,
            child: Divider(
              color: Theme.of(context).colorScheme.lamisColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: context.resources.dimension.smallMargin),
            child: Row(
              children: [
                SizedBox(
                  width: 120,
                  child: CustomText(
                    content: context.resources.strings.grandTotal,
                    language: context.read<LocalizationCubit>().state ==
                            const Locale('ar', '')
                        ? Language.rtl
                        : Language.ltr,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                    titletype: TitleType.body,
                  ),
                ),
                const Spacer(),
                CustomText(
                  content: _orderDetails.grandTotal,
                  language: context.read<LocalizationCubit>().state ==
                          const Locale('ar', '')
                      ? Language.rtl
                      : Language.ltr,
                  color: Theme.of(context).colorScheme.primaryTextColor,
                  titletype: TitleType.body,
                ),
              ],
            ),
          ),
          if (_orderDetails.note != null)
            Row(
              children: [
                SizedBox(
                  width: 130,
                  child: CustomText(
                    content: context.resources.strings.note,
                    language: context.read<LocalizationCubit>().state ==
                            const Locale('ar', '')
                        ? Language.rtl
                        : Language.ltr,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                    titletype: TitleType.bottoms,
                  ),
                ),
                Expanded(
                  child: CustomText(
                    content: _orderDetails.note,
                    language: context.read<LocalizationCubit>().state ==
                            const Locale('ar', '')
                        ? Language.rtl
                        : Language.ltr,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                    titletype: TitleType.body,
                    maxlines: 3,
                  ),
                ),
              ],
            ),
          const FixedHieght(),
          paymentType == "Wallet" || paymentType == "Cash On Delivery"
              ? Container()
              : BlocBuilder(
                  bloc: _reorderTheOrderCubit,
                  builder: (context, state) {
                    if (state == true) {
                      return CustomButton(
                              onPress: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return WebViewScreen(
                                      orderId: combinedId,
                                      paymentType: paymentType,
                                      userId: UserRepo().user.id);
                                }));
                              },
                              content: context.resources.strings.repay)
                          .customMargins();
                    }
                    return Container();
                  },
                )
        ],
      ).customMargins(),
    ));
  }

  // buildTimeLineShimmer() {
  //   return Column(
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Padding(
  //             padding: EdgeInsets.all(context.resources.dimension.smallMargin),
  //             child: ShimmerHelper()
  //                 .buildBasicShimmer(height: 40, width: 40.0, context: context),
  //           ),
  //           Padding(
  //             padding: EdgeInsets.all(context.resources.dimension.smallMargin),
  //             child: ShimmerHelper()
  //                 .buildBasicShimmer(height: 40, width: 40.0, context: context),
  //           ),
  //           Padding(
  //             padding: EdgeInsets.all(context.resources.dimension.smallMargin),
  //             child: ShimmerHelper()
  //                 .buildBasicShimmer(height: 40, width: 40.0, context: context),
  //           ),
  //           Padding(
  //             padding: EdgeInsets.all(context.resources.dimension.smallMargin),
  //             child: ShimmerHelper()
  //                 .buildBasicShimmer(height: 40, width: 40.0, context: context),
  //           )
  //         ],
  //       ),
  //       Padding(
  //         padding: EdgeInsets.all(context.resources.dimension.smallMargin),
  //         child: ShimmerHelper()
  //             .buildBasicShimmer(height: 20, width: 250.0, context: context),
  //       )
  //     ],
  //   );
  // }

  buildTimeLineTiles() {
    return SizedBox(
      height: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomColumn(
                  deliveryStatus: _orderDetails.deliveryStatus,
                  state: "pending",
                  content: context.resources.strings.pending,
                  image: context.resources.images.orderPlacedIcon,
                ),
                CustomColumn(
                  deliveryStatus: _orderDetails.deliveryStatus,
                  state: "confirmed",
                  content: context.resources.strings.confirmed,
                  image: context.resources.images.confirmedIcon,
                ),
                CustomColumn(
                  deliveryStatus: _orderDetails.deliveryStatus,
                  state: "on_the_way",
                  content: context.resources.strings.onTheWay,
                  image: "",
                  isIcon: true,
                  icon: Icons.local_shipping_outlined,
                ),
                CustomColumn(
                  deliveryStatus: _orderDetails.deliveryStatus,
                  state: "delivered",
                  content: context.resources.strings.delivered,
                  image: "",
                  isIcon: true,
                  isLast: true,
                  icon: Icons.done_all,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column buildOrderDetailsTopCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText(
              content: context.resources.strings.orderCode,
              color: Theme.of(context).colorScheme.primaryTextColor,
              titletype: TitleType.subtitle,
            ),
            const Spacer(),
            CustomText(
              content: _orderDetails.code,
              color: Theme.of(context).colorScheme.primaryTextColor,
              titletype: TitleType.body,
            ),
          ],
        ).customMargins(),
        const FixedHieght(),
        Container(
          padding: EdgeInsets.all(context.resources.dimension.mediumMargin),
          margin: EdgeInsets.only(
              left: context.resources.dimension.mediumMargin,
              right: context.resources.dimension.mediumMargin),
          height: context.resources.dimension.smallContainerSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.lamisColor.withOpacity(0.1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  CustomText(
                    content: context.resources.strings.orderDate,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                    titletype: TitleType.subtitle,
                  ),
                  const Spacer(),
                  CustomText(
                    content: context.resources.strings.paymentMethod,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                    titletype: TitleType.subtitle,
                  ),
                ],
              ),
              Row(
                children: [
                  CustomText(
                    content: _orderDetails.date,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                    titletype: TitleType.body,
                  ),
                  const Spacer(),
                  CustomText(
                    content: _orderDetails.paymentType,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                    titletype: TitleType.body,
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(context.resources.dimension.mediumMargin),
          margin: EdgeInsets.only(
              left: context.resources.dimension.mediumMargin,
              right: context.resources.dimension.mediumMargin),
          height: context.resources.dimension.smallContainerSize,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  CustomText(
                    content: "${context.resources.strings.paymentStatus} ",
                    color: Theme.of(context).colorScheme.primaryTextColor,
                    titletype: TitleType.subtitle,
                  ),
                  const Spacer(),
                  CustomText(
                    content: context.resources.strings.deliveryStatus,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                    titletype: TitleType.subtitle,
                  ),
                ],
              ),
              // const FixedHieght(),
              Row(
                children: [
                  CustomText(
                    content: _orderDetails.paymentStatusString + " ",
                    color: Theme.of(context).colorScheme.primaryTextColor,
                    titletype: TitleType.body,
                  ),
                  const Spacer(),
                  CustomText(
                    content: _orderDetails.deliveryStatusString,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                    titletype: TitleType.body,
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            CustomText(
              content: "${context.resources.strings.deliveryMethod} ",
              color: Theme.of(context).colorScheme.primaryTextColor,
              titletype: TitleType.subtitle,
            ),
            const Spacer(),
            CustomText(
              content: _orderDetails.deliveryMethod,
              color: Theme.of(context).colorScheme.primaryTextColor,
              titletype: TitleType.body,
            ),
          ],
        ).customMargins(),
        //const Spacer(),
        const FixedHieght(),
        _orderDetails.deliveryDate != null
            ? Column(
                children: [
                  Row(
                    children: [
                      CustomText(
                        content: "${context.resources.strings.deliveryDate} ",
                        color: Theme.of(context).colorScheme.primaryTextColor,
                        titletype: TitleType.subtitle,
                      ),
                      const Spacer(),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: CustomText(
                          content: _orderDetails.deliveryDate,
                          color: Theme.of(context).colorScheme.primaryTextColor,
                          titletype: TitleType.body,
                          language: Language.rtl,
                        ),
                      ),
                    ],
                  ).customMargins(),
                  const FixedHieght(),
                ],
              )
            : Container(),
        //const Spacer(),
        Row(
          children: [
            CustomText(
              content: context.resources.strings.totalAmount,
              color: Theme.of(context).colorScheme.primaryTextColor,
              titletype: TitleType.subtitle,
            ),
            const Spacer(),
            CustomText(
              content: _orderDetails.grandTotal,
              color: Theme.of(context).colorScheme.primaryTextColor,
              titletype: TitleType.body,
            ),
          ],
        ).customMargins(),
        const FixedHieght(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding:
                    EdgeInsets.all(context.resources.dimension.mediumMargin),
                margin: EdgeInsets.only(
                    left: context.resources.dimension.mediumMargin,
                    right: context.resources.dimension.mediumMargin),
                height: context.resources.dimension.textFieldHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:
                      Theme.of(context).colorScheme.lamisColor.withOpacity(0.1),
                ),
                child: Center(
                  child: CustomText(
                    content: context.resources.strings.shippingAddress,
                    titletype: TitleType.subtitle,
                  ),
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FixedHieght(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(content: context.resources.strings.name),
                    CustomText(
                        content: _orderDetails.shippingAddress?.name ?? ""),
                  ],
                ),
                const FixedHieght(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(content: context.resources.strings.addressTitle),
                    CustomText(
                        content: _orderDetails.shippingAddress.address ?? ""),
                  ],
                ),
                const FixedHieght(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(content: context.resources.strings.country),
                    CustomText(content: _orderDetails.shippingAddress.country),
                  ],
                ),
                const FixedHieght(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(content: context.resources.strings.state),
                    CustomText(content: _orderDetails.shippingAddress.state),
                  ],
                ),
                const FixedHieght(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(content: context.resources.strings.phoneNumber),
                    CustomText(
                        content: _orderDetails.shippingAddress?.phone ?? ''),
                  ],
                ),
                const FixedHieght(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                        content: context.resources.strings.addressDetails),
                    CustomText(
                        content:
                            _orderDetails.shippingAddress?.postalCode ?? ""),
                  ],
                ),
              ],
            ).customMargins(),
          ],
        ),
      ],
    );
  }

  Card buildOrderedProductItemsCard(index, OrderItemResponse state) {
    return Card(
      color: Theme.of(context).colorScheme.lamisColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        // side: BorderSide(
        //     color: Theme.of(context).colorScheme.border,
        //     width: context.resources.dimension.selectedBorder),
        borderRadius:
            BorderRadius.circular(context.resources.dimension.smallMargin),
      ),
      elevation: context.resources.dimension.zeroElevation,
      child: Padding(
        padding: EdgeInsets.all(context.resources.dimension.defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      bottom: context.resources.dimension.smallMargin),
                  child: CustomText(
                    content: state.orderedItems[index].productName,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                    language: context.read<LocalizationCubit>().state ==
                            const Locale('ar', '')
                        ? Language.rtl
                        : Language.ltr,
                    titletype: TitleType.bottoms,
                  ),
                ),
                CustomText(
                  content: state.orderedItems[index].price,
                  color: Theme.of(context).colorScheme.primaryTextColor,
                  language: context.read<LocalizationCubit>().state ==
                          const Locale('ar', '')
                      ? Language.rtl
                      : Language.ltr,
                  titletype: TitleType.body,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: context.resources.dimension.smallMargin),
              child: Row(
                children: [
                  CustomText(
                    content: "${state.orderedItems[index].quantity} x ",
                    color: Theme.of(context).colorScheme.primaryTextColor,
                    language: context.read<LocalizationCubit>().state ==
                            const Locale('ar', '')
                        ? Language.rtl
                        : Language.ltr,
                    titletype: TitleType.body,
                  ),
                  state.orderedItems[index].variation != "" &&
                          state.orderedItems[index].variation != null
                      ? CustomText(
                          content: state.orderedItems[index].variation ?? "",
                          color: Theme.of(context).colorScheme.primaryTextColor,
                          language: context.read<LocalizationCubit>().state ==
                                  const Locale('ar', '')
                              ? Language.rtl
                              : Language.ltr,
                          titletype: TitleType.body,
                        )
                      : CustomText(
                          content: context.resources.strings.item,
                          color: Theme.of(context).colorScheme.primaryTextColor,
                          language: context.read<LocalizationCubit>().state ==
                                  const Locale('ar', '')
                              ? Language.rtl
                              : Language.ltr,
                          titletype: TitleType.body,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getRefundRequestLabelColor(status) {
    if (status == 0) {
      return Colors.blue;
    } else if (status == 2) {
      return Colors.orange;
    } else if (status == 1) {
      return Colors.green;
    } else {
      return Theme.of(context).colorScheme.shadowColor;
    }
  }

  buildOrderdProductList(OrderItemResponse state) {
    return SingleChildScrollView(
      child: ListView.builder(
        itemCount: state.orderedItems.length,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: context.resources.dimension.verySmallMargin),
            child: buildOrderedProductItemsCard(index, state),
          );
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).colorScheme.border),
            onPressed: () {
              if (widget.fromNotification || widget.goBack == false) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const OrderList();
                }));
              } else {
                return Navigator.of(context).pop();
              }
            }),
      ),
      title: CustomText(
          content: context.resources.strings.orderDetails,
          language:
              context.read<LocalizationCubit>().state == const Locale('ar', '')
                  ? Language.rtl
                  : Language.ltr,
          titletype: TitleType.subtitle,
          color: Theme.of(context).colorScheme.subText),
      elevation: context.resources.dimension.zeroElevation,
      titleSpacing: 0,
    );
  }

  buildPaymentButtonSection() {
    return Padding(
      padding: EdgeInsets.all(context.resources.dimension.defaultMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _orderDetails != null && _orderDetails.manuallyPayable
              ? TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.subText),
                  child: CustomText(
                    content: "Make Offline Payment",
                    color: Theme.of(context).colorScheme.shadowColor,
                    language: context.read<LocalizationCubit>().state ==
                            const Locale('ar', '')
                        ? Language.rtl
                        : Language.ltr,
                    titletype: TitleType.subtitle,
                  ),
                  onPressed: () {
                    onPressOfflinePaymentButton();
                  },
                )
              : Container(),
        ],
      ),
    );
  }

  Container buildPaymentStatusCheckContainer(String paymentStatus) {
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(context.resources.dimension.defaultMargin),
          color: paymentStatus == "paid"
              ? Colors.green
              : Theme.of(context).colorScheme.redColor),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Icon(
            paymentStatus == "paid"
                ? FontAwesomeIcons.check
                : FontAwesomeIcons.times,
            color: Theme.of(context).colorScheme.background,
            size: 10),
      ),
    );
  }
}

class FirstLoadingShimmer extends StatelessWidget {
  const FirstLoadingShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 30,
            color: Theme.of(context).colorScheme.lamisColor.withOpacity(0.3),
          ),
          Container(
            height: 30,
            color: Theme.of(context).colorScheme.lamisColor.withOpacity(0.3),
          ),
          Container(
            height: 30,
            color: Theme.of(context).colorScheme.lamisColor.withOpacity(0.3),
          ),
          Container(
            height: 30,
            color: Theme.of(context).colorScheme.lamisColor.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}

class CustomColumn extends StatelessWidget {
  final String deliveryStatus;
  final String state;
  final String content;
  final String image;
  final bool isIcon;
  final IconData icon;
  final bool isLast;

  const CustomColumn(
      {Key? key,
      required this.deliveryStatus,
      required this.state,
      this.icon = Icons.local_shipping_outlined,
      this.isIcon = false,
      this.isLast = false,
      required this.content,
      required this.image})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: deliveryStatus == state ? 40 : 35,
              height: deliveryStatus == state ? 40 : 35,
              child: isIcon
                  ? Icon(
                      icon,
                      color: deliveryStatus == state
                          ? Theme.of(context).colorScheme.lamisColor
                          : Theme.of(context).primaryColor,
                      size: 25,
                    )
                  : ImageIcon(
                      AssetImage(image),
                      color: deliveryStatus == state
                          ? Theme.of(context).colorScheme.lamisColor
                          : Theme.of(context).primaryColor,
                      size: 25,
                    ),
            ),
            isLast
                ? Container()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                        height: 1.0,
                        width: MediaQuery.of(context).size.width * .12,
                        color: Theme.of(context).primaryColor),
                  ),
          ],
        ),
        Expanded(
            child: CustomText(
          content: content,
          titletype: TitleType.time,
        ))
      ],
    );
  }
}
