import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/models/models.dart';
import 'package:lamis/screens/screens.dart';

import '../../cubits/cubits.dart';
import '../../res/resources_export.dart';
import '../../widgets/widgets.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final ScrollController _mainScrollController = ScrollController();
  late WalletBalanceCubit _walletBalanceCubit;
  late WalletHistoryCubit _walletHistoryCubit;

  final List<dynamic> _rechargeList = [];
  int pageNumber = 1;

  @override
  void initState() {
    super.initState();
    _walletBalanceCubit = WalletBalanceCubit();
    _walletHistoryCubit = WalletHistoryCubit();
    fetchAll();
    _mainScrollController.addListener(() {
      if (_mainScrollController.position.pixels ==
          _mainScrollController.position.maxScrollExtent) {
        _walletHistoryCubit.getWalletHistoryData(pageNumber: ++pageNumber);
      }
    });
  }

  fetchAll() {
    fetchBalanceDetails();
    fetchRechargeList();
  }

  fetchBalanceDetails() async {
    _walletBalanceCubit.getWalletData();
  }

  fetchRechargeList() async {
    _walletHistoryCubit.getWalletHistoryData();
  }

  reset() {
    _rechargeList.clear();
    pageNumber = 1;
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  onPressProceed() {}
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          context.watch<LocalizationCubit>().state == const Locale('ar', '')
              ? TextDirection.rtl
              : TextDirection.ltr,
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
          appBar: CustomAppBar(
            title: context.resources.strings.wallet,
          ),
          body: ListView(
            controller: _mainScrollController,
            children: [
              // Center(
              //   child: CustomText(
              //     content: context.resources.strings.wallet,
              //     titletype: TitleType.subtitle,
              //     language: Language.center,
              //   ),
              // ),
              BlocBuilder(
                bloc: _walletBalanceCubit,
                builder: (context, state) {
                  if (state is WalletBalanceDone) {
                    return Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: double.infinity,
                        height: 250,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: context.resources.dimension.smallMargin),
                          child: buildTopSection(
                              context, state.walletBalanceResponse),
                        ),
                      ),
                    );
                  } else if (state is WalletHistoryError) {
                    return CustomErrorWidget(
                      onTap: () {
                        _walletBalanceCubit.getWalletData();
                      },
                    );
                  }
                  return _shimmerTopSection();
                },
              ),
              BlocBuilder(
                bloc: _walletHistoryCubit,
                builder: (context, state) {
                  if (state is WalletHistoryDone ||
                      state is WalletHistoryPagination) {
                    if (state is WalletHistoryDone) {
                      _rechargeList
                          .addAll(state.walletHistoryResponse.recharges);
                    }
                    if (_rechargeList.isEmpty) {
                      return Column(
                        children: [
                          const FixedHieght(
                            extra: true,
                          ),
                          SizedBox(
                            height:
                                context.resources.dimension.largeContainerSize,
                            width:
                                context.resources.dimension.largeContainerSize,
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
                    return buildRechargeList();
                  }
                  if (state is WalletHistoryError) {
                    return CustomErrorWidget(onTap: () {
                      _walletHistoryCubit.getWalletHistoryData();
                    });
                  }
                  return SingleChildScrollView(
                      child: buildRechargeListShimmer());
                },
              ),
            ],
          ).customMargins()),
    );
  }

  buildRechargeList() {
    return SingleChildScrollView(
      child: ListView.builder(
        itemCount: _rechargeList.length,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return DelayedAnimation(
              delay: index * 200,
              fromSide: FromSide.bottom,
              child: Column(
                children: [
                  buildRechargeListItemCard(index),
                  const FixedHieght(),
                ],
              ));
        },
      ),
    );
  }

  Widget buildRechargeListShimmer() {
    return ListView.builder(
      itemCount: 4,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
            padding: EdgeInsets.all(context.resources.dimension.smallMargin),
            child: Container(
              height: 100,
              color: Theme.of(context).colorScheme.lamisColor.withOpacity(0.3),
            ));
      },
    );
  }

  Stack buildRechargeListItemCard(int index) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: context.resources.dimension.smallMargin,
              left: context.resources.dimension.veryHighElevation,
              right: context.resources.dimension.veryHighElevation),
          child: Container(
            height: context.resources.dimension.middleContainerSize,
            decoration: BoxDecoration(
              border:
                  Border.all(color: Theme.of(context).colorScheme.lamisColor),
              borderRadius: BorderRadius.circular(
                  context.resources.dimension.dropDawnRadios),
            ),
            child: Card(
              color: Theme.of(context).colorScheme.productColor,
              elevation: 0.0,
              child: Padding(
                padding:
                    EdgeInsets.all(context.resources.dimension.defaultMargin),
                child: Row(
                  children: [
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.date_range_sharp),
                            const SizedBox(
                              width: 20,
                            ),
                            CustomText(
                              content: _rechargeList[index].date,
                              titletype: TitleType.body,
                            ),
                          ],
                        ),
                        const FixedHieght(),
                        const FixedHieght(),
                        Row(
                          children: [
                            ImageIcon(
                                AssetImage(context.resources.images.moneyIcon)),
                            const SizedBox(
                              width: 20,
                            ),
                            CustomText(
                              content: _rechargeList[index].amount,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 6,
          top: 45,
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(color: Theme.of(context).colorScheme.lamisColor),
                color: Theme.of(context).colorScheme.scaffoldColor),
            child: Center(
              child: CustomText(
                content: getFormattedRechargeListIndex(index),
                titletype: TitleType.subtitle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  getFormattedRechargeListIndex(int index) {
    int num = index + 1;
    var txt = num.toString().length == 1 ? "#$num" : "#$num";
    return txt;
  }

  buildTopSection(BuildContext context, WalletBalanceResponse state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NeumorphismBrands(
          neumorphismType: NeumorphismType.todayDeal,
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: Theme.of(context).colorScheme.blueLiner),
                borderRadius: BorderRadius.circular(24)),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: context.resources.dimension.bigMargin),
                  child: CustomText(
                    content: context.resources.strings.walletBalance,
                    color: Colors.white,
                    titletype: TitleType.subtitle,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: context.resources.dimension.defaultMargin),
                  child: CustomText(
                    content: state.balance,
                    color: Colors.white,
                    titletype: TitleType.headline,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: context.resources.dimension.defaultMargin),
                  child: CustomText(
                    content:
                        "${context.resources.strings.lastRecharge} ${state.lastRecharged}",
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const FixedHieght(),
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            content: context.resources.strings.rechargeWallet,
            onPress: () async {
              var res = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return const PointScreen();
              }));
              if (res != null && res) {
                _rechargeList.clear();
                fetchAll();
              }
            },
          ),
        ),
        // Padding(
      ],
    );
  }

  Widget _shimmerTopSection() {
    return Container(
      margin: EdgeInsets.only(top: context.resources.dimension.smallMargin),
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.lamisColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(24)),
    );
  }
}
