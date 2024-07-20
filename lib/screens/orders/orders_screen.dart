import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/main.dart';

import '../../cubits/cubits.dart';
import '../../models/models.dart';
import '../../repos/repos.dart' show UserRepo;
import '../../res/resources_export.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class PaymentStatus {
  String optionKey;
  String name;

  PaymentStatus(this.optionKey, this.name);

  static List<PaymentStatus> getPaymentStatusList() {
    return <PaymentStatus>[
      PaymentStatus('', MyApp.context.resources.strings.all),
      PaymentStatus('paid', MyApp.context.resources.strings.paid),
      PaymentStatus('unpaid', MyApp.context.resources.strings.unpaid),
    ];
  }
}

class DeliveryStatus {
  String optionKey;
  String name;

  DeliveryStatus(this.optionKey, this.name);

  static List<DeliveryStatus> getDeliveryStatusList() {
    return <DeliveryStatus>[
      DeliveryStatus('', MyApp.context.resources.strings.all),
      DeliveryStatus('confirmed', MyApp.context.resources.strings.confirmed),
      // DeliveryStatus('on_delivery', MyApp.context.resources.strings.onDelivery),
      DeliveryStatus('delivered', MyApp.context.resources.strings.delivered),
      DeliveryStatus('pending', MyApp.context.resources.strings.pending),
      DeliveryStatus('picked_up', MyApp.context.resources.strings.pickedUp),
      DeliveryStatus('on_the_way', MyApp.context.resources.strings.onTheWay),
      DeliveryStatus('cancelled', MyApp.context.resources.strings.cancelled),
    ];
  }
}

class OrderList extends StatefulWidget {
  const OrderList({Key? key, this.fromCheckout = false}) : super(key: key);
  final bool fromCheckout;

  @override
  // ignore: library_private_types_in_public_api
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  final ScrollController _xcrollController = ScrollController();
  final List<PaymentStatus> _paymentStatusList =
      PaymentStatus.getPaymentStatusList();
  final List<DeliveryStatus> _deliveryStatusList =
      DeliveryStatus.getDeliveryStatusList();

  late PaymentStatus _selectedPaymentStatus;
  late DeliveryStatus _selectedDeliveryStatus;

  late List<DropdownMenuItem<PaymentStatus>> _dropdownPaymentStatusItems;
  late List<DropdownMenuItem<DeliveryStatus>> _dropdownDeliveryStatusItems;
  late OrderPaymentStatusCubit _orderPaymentStatusCubit;
  late OrderDeliveryStatusCubit _orderDeliveryStatusCubit;
  //------------------------------------
  // final List<Order> _orderList = [];
  List<Order> list = [];

  int _page = 1;
  String _defaultPaymentStatusKey = '';
  String _defaultDeliveryStatusKey = '';
  OrderCubit orderCubit = OrderCubit();
  @override
  void initState() {
    init();
    fetchData();
    _xcrollController.addListener(() {
      if (_xcrollController.position.pixels ==
          _xcrollController.position.maxScrollExtent) {
        // if (orderCubit.nextPage != null) {
        _page++;

        //_showLoadingContainer = true;
        fetchData();
        // }
      }
    });
    // controller.forward();
    if (widget.fromCheckout) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (mounted && context.read<RateAppCubit>().state.shouldOpenDialog) {
          // rateMyApp.callEvent(eventType)
          context.read<RateAppCubit>().state.showRateDialog(context);
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    _xcrollController.dispose();
    super.dispose();
  }

  init() {
    _orderDeliveryStatusCubit =
        OrderDeliveryStatusCubit(DeliveryStatus('', "All"));
    _orderPaymentStatusCubit =
        OrderPaymentStatusCubit(PaymentStatus('', "All"));
    _dropdownPaymentStatusItems =
        buildDropdownPaymentStatusItems(_paymentStatusList);

    _dropdownDeliveryStatusItems =
        buildDropdownDeliveryStatusItems(_deliveryStatusList);

    for (int x = 0; x < _dropdownPaymentStatusItems.length; x++) {
      if (_dropdownPaymentStatusItems[x].value?.optionKey ==
          _defaultPaymentStatusKey) {
        _selectedPaymentStatus = _dropdownPaymentStatusItems[x].value!;
      }
    }

    for (int x = 0; x < _dropdownDeliveryStatusItems.length; x++) {
      if (_dropdownDeliveryStatusItems[x].value?.optionKey ==
          _defaultDeliveryStatusKey) {
        _selectedDeliveryStatus = _dropdownDeliveryStatusItems[x].value!;
      }
    }
  }

  reset() {
    // _orderList.clear();
    list.clear();
    _page = 1;
  }

  resetFilterKeys() {
    _defaultPaymentStatusKey = '';
    _defaultDeliveryStatusKey = '';
    _orderDeliveryStatusCubit.save(DeliveryStatus('', "All"));
    _orderPaymentStatusCubit.save(PaymentStatus('', "All"));
  }

  // Future<void> _onRefresh() async {
  //   reset();
  //   resetFilterKeys();
  //   for (int x = 0; x < _dropdownPaymentStatusItems.length; x++) {
  //     if (_dropdownPaymentStatusItems[x].value?.optionKey ==
  //         _defaultPaymentStatusKey) {
  //       _selectedPaymentStatus = _dropdownPaymentStatusItems[x].value!;
  //     }
  //   }
  //
  //   for (int x = 0; x < _dropdownDeliveryStatusItems.length; x++) {
  //     if (_dropdownDeliveryStatusItems[x].value?.optionKey ==
  //         _defaultDeliveryStatusKey) {
  //       _selectedDeliveryStatus = _dropdownDeliveryStatusItems[x].value!;
  //     }
  //   }
  //   fetchData();
  // }

  fetchData() async {
    orderCubit.getOrdersData(
        userId: UserRepo().user.id,
        page: _page,
        paymentStatus: _orderPaymentStatusCubit.state.optionKey,
        deliveryStatus: _orderDeliveryStatusCubit.state.optionKey);

    // _orderList.addAll(list);
  }

  List<DropdownMenuItem<PaymentStatus>> buildDropdownPaymentStatusItems(
      List _paymentStatusList) {
    List<DropdownMenuItem<PaymentStatus>> items = [];
    for (PaymentStatus item in _paymentStatusList) {
      items.add(
        DropdownMenuItem(
          value: item,
          child: Text(item.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<DeliveryStatus>> buildDropdownDeliveryStatusItems(
      List _deliveryStatusList) {
    List<DropdownMenuItem<DeliveryStatus>> items = [];
    for (DeliveryStatus item in _deliveryStatusList) {
      items.add(
        DropdownMenuItem(
          value: item,
          child: Text(item.name),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          context.read<LocalizationCubit>().state == const Locale('ar', '')
              ? TextDirection.rtl
              : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        extendBodyBehindAppBar: false,
        appBar: buildAppBar(context),
        body: ListView(
          controller: _xcrollController,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: context.resources.dimension.defaultMargin),
              child: Column(
                children: [
                  BlocBuilder(
                    bloc: orderCubit,
                    builder: (context, state) {
                      if (state is OrderLoading) {
                        return SingleChildScrollView(
                            child: ListView.builder(
                          itemCount: 3,
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      context.resources.dimension.defaultMargin,
                                  vertical:
                                      context.resources.dimension.smallMargin),
                              child: Container(
                                height: context
                                    .resources.dimension.middleContainerSize,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .lamisColor
                                        .withOpacity(0.3),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(context.resources
                                            .dimension.imageBorderRadius))),
                              ),
                            );
                          },
                        ));
                      } else if (state is OrderDone ||
                          state is OrderPagination) {
                        if (state is OrderDone) {
                          list.addAll(state.orderMiniResponse.orders);
                        }
                        if (list.isEmpty) {
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
                        } else {
                          return buildOrderListList(list, context);
                        }
                      } else {
                        return CustomErrorWidget(
                          onTap: () {
                            orderCubit.getOrdersData(
                                userId: UserRepo().user.id,
                                page: _page,
                                paymentStatus: _selectedPaymentStatus.optionKey,
                                deliveryStatus:
                                    _selectedDeliveryStatus.optionKey);
                          },
                        );
                      }
                    },
                  ),
                  // Align(
                  //     alignment: Alignment.bottomCenter,
                  //     child: buildLoadingContainer())
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildLoadingContainer() {
    return Container(
      height: context.resources.dimension.extraHighElevation,
      width: double.infinity,
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: Text(list.isEmpty
            ? context.resources.strings.noMoreOrders
            : context.resources.strings.loadingMoreOrders),
      ),
    );
  }

  buildBottomAppBar(BuildContext context) {
    return Column(
      children: [
        const FixedHieght(),
        const FixedHieght(),
        // Center(
        //     child: CustomText(
        //   content: context.resources.strings.orders,
        //   titletype: TitleType.subtitle,
        //   language: Language.center,
        // )),
        const FixedHieght(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).colorScheme.lamisColor),
                  // color: Theme.of(context).colorScheme.dropDownColor,
                  borderRadius: BorderRadius.all(Radius.circular(
                      context.resources.dimension.dropDawnRadios)),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: context.resources.dimension.mediumMargin,
                    vertical: context.resources.dimension.verySmallMargin),
                height: 58,
                width: 145,
                child: Row(
                  children: [
                    Icon(
                      Icons.credit_card,
                      color: Theme.of(context).colorScheme.lamisColor,
                    ),
                    SizedBox(
                      width: context.resources.dimension.smallMargin,
                    ),
                    BlocBuilder(
                      bloc: orderCubit,
                      builder: (context, state) {
                        return Expanded(
                          child: DropdownButton<PaymentStatus>(
                            dropdownColor:
                                Theme.of(context).colorScheme.scaffoldColor,
                            isExpanded: true,
                            icon: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      context.resources.dimension.smallMargin),
                              child: Icon(Icons.expand_more,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryTextColor),
                            ),
                            hint: CustomText(
                              content: context.resources.strings.all,
                              titletype: TitleType.body,
                              color: Theme.of(context).colorScheme.subText,
                              language: Language.center,
                            ),
                            iconSize: 14,
                            underline: const SizedBox(),
                            value: _selectedPaymentStatus,
                            items: _dropdownPaymentStatusItems,
                            onChanged: (PaymentStatus? selectedFilter) {
                              _selectedPaymentStatus = selectedFilter!;
                              _orderPaymentStatusCubit.save(selectedFilter);
                              reset();
                              fetchData();
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(
                        context.resources.dimension.dropDawnRadios)),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.lamisColor)),
                padding: EdgeInsets.symmetric(
                    horizontal: context.resources.dimension.mediumMargin,
                    vertical: context.resources.dimension.verySmallMargin),
                height: 58,
                width: 160,
                child: Row(
                  children: [
                    Icon(
                      Icons.local_shipping_outlined,
                      color: Theme.of(context).colorScheme.lamisColor,
                    ),
                    SizedBox(
                      width: context.resources.dimension.smallMargin,
                    ),
                    Expanded(
                      child: BlocBuilder(
                        bloc: orderCubit,
                        builder: (context, state) {
                          return DropdownButton<DeliveryStatus>(
                            isExpanded: true,
                            icon: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              child: Icon(Icons.expand_more,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryTextColor),
                            ),
                            hint: CustomText(
                              content: context.resources.strings.all,
                              color: Theme.of(context).colorScheme.subText,
                            ),
                            iconSize: 14,
                            underline: const SizedBox(),
                            value: _selectedDeliveryStatus,
                            items: _dropdownDeliveryStatusItems,
                            onChanged: (DeliveryStatus? selectedFilter) {
                              _selectedDeliveryStatus = selectedFilter!;
                              _orderDeliveryStatusCubit.save(selectedFilter);
                              reset();
                              fetchData();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ).customMargins();
  }

  buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize:
          Size.fromHeight(context.resources.dimension.middleContainerSize + 45),
      child: AppBar(
          iconTheme: IconThemeData(
            size: 15,
            color: Theme.of(context).colorScheme.lamisColor,
          ),
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: NeumorphismContainer(
                child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).colorScheme.lamisColor,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
            )),
          ),
          title: SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: CustomText(
                maxlines: 2,
                content: context.resources.strings.orders,
                titletype: TitleType.subtitle,
                language: Language.center,
                color: Theme.of(context).colorScheme.lightBlue,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          actions: [
            Container(),
          ],
          flexibleSpace: Padding(
            padding: EdgeInsets.fromLTRB(
                context.resources.dimension.zeroElevation,
                context.resources.dimension.defaultMargin,
                context.resources.dimension.zeroElevation,
                context.resources.dimension.zeroElevation),
            child: Column(
              children: [
                Padding(
                  padding: MediaQuery.of(context).viewPadding.top >
                          context.resources.dimension
                              .extraHighElevation //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
                      ? EdgeInsets.only(
                          top: context.resources.dimension.extraHighElevation)
                      : EdgeInsets.only(
                          top: context.resources.dimension.highElevation),
                  child: buildTopAppBarContainer(),
                ),
                buildBottomAppBar(context)
              ],
            ),
          )),
    );
  }

  Row buildTopAppBarContainer() {
    return Row(
      children: [
        Builder(
          builder: (context) => IconButton(
            icon: Icon(
                context.read<LocalizationCubit>().state ==
                        const Locale('ar', '')
                    ? Icons.arrow_back
                    : Icons.arrow_forward,
                color: Theme.of(context).colorScheme.lamisColor),
            onPressed: () {
              // if (widget.fromCheckout) {
              //   Navigator.push(context, MaterialPageRoute(builder: (context) {
              //     return const ProfileScreen();
              //   }));
              // } else {
              return Navigator.of(context).pop();
              // }
            },
          ),
        ),
      ],
    );
  }

  buildOrderListList(List<Order> _orderList, BuildContext context) {
    return ListView.builder(
      //controller: _xcrollController,
      // controller: _xcrollController,
      padding: EdgeInsets.all(context.resources.dimension.smallMargin),
      itemCount: _orderList.length,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),

      shrinkWrap: true,
      itemBuilder: (context, index) {
        return DelayedAnimation(
          delay: index * 200,
          fromSide: FromSide.bottom,
          child: Padding(
              padding: EdgeInsets.only(
                  bottom: context.resources.dimension.verySmallMargin),
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.heavyImpact();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return OrderDetailsScreen(
                      id: _orderList[index].id,
                    );
                  }));
                },
                //
                child: Column(
                  children: [
                    buildOrderListItemCard(index, _orderList, context),
                    const FixedHieght(),
                  ],
                ),
                // child:
                //     buildOrderListItemCardDesign(index, _orderList, context),
              )),
        );
      },
    );
  }

  NeumorphismBrands buildOrderListItemCard(
      int index, List<Order> _orderList, BuildContext context) {
    return NeumorphismBrands(
      neumorphismType: NeumorphismType.todayDeal,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
            border: Border.all(
                color: _orderList[index].paymentStatus.toLowerCase() == "paid"
                    ? Theme.of(context).colorScheme.greenColor
                    : Theme.of(context).colorScheme.redColor,
                width: context.resources.dimension.selectedBorder),
            borderRadius:
                BorderRadius.circular(context.resources.dimension.bigMargin),
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.bottomRight,
                colors: Theme.of(context).colorScheme.blueShadeLiner)),
        child: Padding(
          padding: EdgeInsets.all(context.resources.dimension.defaultMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: context.resources.dimension.verySmallMargin),
                child: Row(
                  children: [
                    Padding(
                      padding: context.read<LocalizationCubit>().state ==
                              const Locale('ar', '')
                          ? EdgeInsets.only(
                              left: context.resources.dimension.smallMargin)
                          : EdgeInsets.only(
                              right: context.resources.dimension.smallMargin),
                      child: Icon(
                        Icons.credit_card,
                        size: 23,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    CustomText(
                      content: "${context.resources.strings.paymentStatus_} ",
                      color: Theme.of(context).colorScheme.primaryTextColor,
                      titletype: TitleType.body,
                      language: context.read<LocalizationCubit>().state ==
                              const Locale('ar', '')
                          ? Language.rtl
                          : Language.ltr,
                    ),
                    CustomText(
                      content: _orderList[index].paymentStatusString,
                      titletype: TitleType.body,
                      language: context.read<LocalizationCubit>().state ==
                              const Locale('ar', '')
                          ? Language.rtl
                          : Language.ltr,
                      color: Theme.of(context).colorScheme.primaryTextColor,
                    ),
                    // Padding(
                    //   padding: context.read<LocalizationCubit>().state ==
                    //           const Locale('ar', '')
                    //       ? EdgeInsets.only(
                    //           right: context.resources.dimension.smallMargin)
                    //       : EdgeInsets.only(
                    //           left: context.resources.dimension.smallMargin),
                    //   child: buildPaymentStatusCheckContainer(
                    //       _orderList[index].paymentStatus),
                    // ),
                    const Spacer(),
                    CustomText(
                      content: _orderList[index].grandTotal,
                      language: context.read<LocalizationCubit>().state ==
                              const Locale('ar', '')
                          ? Language.rtl
                          : Language.ltr,
                      color: Theme.of(context).colorScheme.primaryTextColor,
                      titletype: TitleType.body,
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: context.resources.dimension.verySmallMargin),
                child: Row(
                  children: [
                    Padding(
                      padding: context.read<LocalizationCubit>().state ==
                              const Locale('ar', '')
                          ? EdgeInsets.only(
                              left: context.resources.dimension.smallMargin)
                          : EdgeInsets.only(
                              right: context.resources.dimension.smallMargin),
                      child: Icon(
                        Icons.calendar_today_outlined,
                        size: 23,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    CustomText(
                      content: "${context.resources.strings.orderDate} ",
                      color: Theme.of(context).colorScheme.primaryTextColor,
                      titletype: TitleType.body,
                      language: context.read<LocalizationCubit>().state ==
                              const Locale('ar', '')
                          ? Language.rtl
                          : Language.ltr,
                    ),
                    SizedBox(
                      width: context.resources.dimension.verySmallMargin,
                    ),
                    CustomText(
                        content: _orderList[index].date,
                        titletype: TitleType.body,
                        color: Theme.of(context).colorScheme.primaryTextColor,
                        language: context.read<LocalizationCubit>().state ==
                                const Locale('ar', '')
                            ? Language.rtl
                            : Language.ltr),
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: context.read<LocalizationCubit>().state ==
                            const Locale('ar', '')
                        ? EdgeInsets.only(
                            left: context.resources.dimension.smallMargin)
                        : EdgeInsets.only(
                            right: context.resources.dimension.smallMargin),
                    child: Icon(
                      Icons.local_shipping_outlined,
                      size: 23,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  CustomText(
                    content: context.resources.strings.deliveryStatus_,
                    color: Theme.of(context).primaryColor,
                    titletype: TitleType.body,
                    language: context.read<LocalizationCubit>().state ==
                            const Locale('ar', '')
                        ? Language.rtl
                        : Language.ltr,
                  ),
                  CustomText(
                      content: _orderList[index].deliveryStatusString,
                      titletype: TitleType.body,
                      color: Theme.of(context).colorScheme.primaryTextColor,
                      language: context.read<LocalizationCubit>().state ==
                              const Locale('ar', '')
                          ? Language.rtl
                          : Language.ltr),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Container buildPaymentStatusCheckContainer(String paymentStatus) {
    return Container(
      height: context.resources.dimension.defaultMargin,
      width: context.resources.dimension.defaultMargin,
      decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(context.resources.dimension.defaultMargin),
          color: paymentStatus == "paid" ? Colors.green : Colors.red),
      child: Padding(
        padding: EdgeInsets.all(context.resources.dimension.verySmallMargin),
        child: Icon(
            paymentStatus == "paid" ? Icons.font_download : Icons.font_download,
            color: Colors.white,
            size: 10),
      ),
    );
  }
}
