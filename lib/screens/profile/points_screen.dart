import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lamis/cubits/cubits.dart';
import 'package:lamis/cubits/points/convert_point/convert_point_cubit.dart';
import 'package:lamis/models/models.dart';
import 'package:lamis/res/resources_export.dart';
import 'package:lamis/screens/home/home_screen.dart';

import '../../widgets/widgets.dart';

class PointScreen extends StatefulWidget {
  const PointScreen({Key? key}) : super(key: key);

  @override
  State<PointScreen> createState() => _PointScreenState();
}

class _PointScreenState extends State<PointScreen> {
  late PointHistoryCubit _pointHistoryCubit;
  late ConvertPointCubit _convertPointCubit;
  late MyPointsCubit _myPointsCubit;
  int pageNumber = 1;
  double myPoint = 0;
  List<ClubPoint> _pointHistoryList = [];
  late ScrollController _mainScrollController;
  FToast fToast = FToast();

  @override
  void initState() {
    _pointHistoryCubit = PointHistoryCubit();
    _convertPointCubit = ConvertPointCubit();
    _myPointsCubit = MyPointsCubit();
    _myPointsCubit.getMyPoints();
    _pointHistoryCubit.getPointHistory(pageNumber: pageNumber);
    _mainScrollController = ScrollController();
    _mainScrollController.addListener(() {
      if (_mainScrollController.position.pixels ==
          _mainScrollController.position.maxScrollExtent) {
        _pointHistoryCubit.getPointHistory(pageNumber: ++pageNumber);
      }
    });
    fToast.init(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: context.resources.strings.point,
      ),
      backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
      body: ListView(
        controller: _mainScrollController,
        children: [
          // Center(
          //   child: CustomText(
          //     content: context.resources.strings.earnedPoints,
          //     titletype: TitleType.subtitle,
          //     language: Language.center,
          //   ),
          // ),
          BlocConsumer(
            bloc: _convertPointCubit,
            listener: (context, state) {
              if (state is ConvertPointLoading) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.resources.strings.loading)));
              }
              if (state is ConvertPointDone) {
                pageNumber = 1;
                _pointHistoryCubit.pointHistoryList.clear();
                _pointHistoryCubit.getPointHistory(pageNumber: pageNumber);
                _myPointsCubit.getMyPoints();
              }
              if (state is ConvertPointError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.errorMessage)));
              }
            },
            builder: (context, state) {
              if (state is ConvertPointInitial || state is ConvertPointDone) {
                return Column(
                  children: [
                    BlocBuilder(
                      bloc: _myPointsCubit,
                      builder: (context, state) {
                        if (state is PointsDone) {
                          myPoint = state.myPointsResponse.userPoints;
                          return Column(
                            children: [
                              buildPointsTopSection(state.myPointsResponse),
                            ],
                          );
                        } else if (state is PointsError) {
                          return CustomErrorWidget(
                            onTap: () {
                              _myPointsCubit.getMyPoints();
                            },
                          );
                        }
                        return _shimmerTopSection();
                      },
                    ),
                    const FixedHieght(),
                    BlocBuilder(
                      bloc: _pointHistoryCubit,
                      builder: (context, state) {
                        if (state is PointHistoryDone ||
                            state is PointHistoryPagination) {
                          if (state is PointHistoryDone) {
                            _pointHistoryList =
                                _pointHistoryCubit.pointHistoryList;
                          }
                          if (_pointHistoryList.isEmpty) {
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
                            return Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: CustomButton(
                                    content:
                                        context.resources.strings.convertAll,
                                    onPress: () {
                                      if (myPoint == 0.0) {
                                        fToast.showToast(
                                            child: ToastBody(
                                          bgColor: Theme.of(context)
                                              .colorScheme
                                              .toastBackGround,
                                          iconColor: Theme.of(context)
                                              .colorScheme
                                              .redColor,
                                          text: context
                                              .resources.strings.noPoints,
                                        ));
                                      } else {
                                        _convertPointCubit.convertAll();
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: context
                                          .resources.dimension.smallMargin),
                                  child: ListView.builder(
                                    itemCount: _pointHistoryList.length,
                                    scrollDirection: Axis.vertical,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return DelayedAnimation(
                                          delay: index * 200,
                                          fromSide: FromSide.bottom,
                                          child: Column(
                                            children: [
                                              buildItemCard(index, context),
                                              const FixedHieght(),
                                            ],
                                          ));
                                    },
                                  ).customMargins(),
                                ),
                              ],
                            );
                          }
                        } else if (state is PointHistoryError) {
                          return CustomErrorWidget(
                            onTap: () {
                              _pointHistoryCubit.getPointHistory(
                                  pageNumber: pageNumber);
                            },
                          );
                        }
                        return Container(
                          margin: EdgeInsets.only(
                              top: context.resources.dimension.smallMargin),
                          child: ListView.builder(
                            itemCount: 4,
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (contexts, index) {
                              return buildShimmer();
                            },
                          ).customMargins(),
                        );
                      },
                    ),
                  ],
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.lamisColor,
      shadowColor: Colors.transparent,
      title: CustomText(
        content: context.resources.strings.earnedPoints,
        language: Language.center,
        titletype: TitleType.subtitle,
      ),
    );
  }

  Stack buildItemCard(int index, BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: context.resources.dimension.smallMargin,
              left: context.resources.dimension.veryHighElevation,
              right: context.resources.dimension.zeroElevation),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: context.resources.dimension.containerSize,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.date_range_sharp),
                          const SizedBox(
                            width: 12,
                          ),
                          CustomText(
                            content: _pointHistoryList[index].date,
                            titletype: TitleType.body,
                          ),
                        ],
                      ),
                      const FixedHieght(
                        extra: true,
                      ),
                      CustomText(
                        content: _pointHistoryList[index].type ?? '',
                        titletype: TitleType.body,
                        color: Theme.of(context).colorScheme.primaryTextColor,
                        language: Language.center,
                      )
                    ],
                  ),
                  SizedBox(
                    width: context.resources.dimension.mediumMargin,
                  ),
                  _pointHistoryList[index].convertStatus == 0
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: BlueButton(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              _convertPointCubit
                                  .convertPoint(_pointHistoryList[index].id);
                            },
                            content: context.resources.strings.convert,
                          ))
                      : Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: CustomText(
                            content: context.resources.strings.converted,
                            color: Theme.of(context).colorScheme.greenColor,
                          ),
                        ),
                ],
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
              child: Padding(
                padding: EdgeInsets.only(
                    top: context.resources.dimension.zeroElevation),
                child: CustomText(
                  content: _pointHistoryList[index].points.toString(),
                  titletype: TitleType.body,
                  language: Language.center,
                  minTextSize: 6,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPointsTopSection(MyPointsResponse points) {
    return Padding(
      padding: EdgeInsets.only(top: context.resources.dimension.smallMargin),
      child: NeumorphismBrands(
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
                      top: context.resources.dimension.defaultMargin),
                  child: CustomText(
                    content: context.resources.strings.myPoints,
                    color: Colors.white,
                    titletype: TitleType.subtitle,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: context.resources.dimension.defaultMargin),
                  child: CustomText(
                    content: points.userPoints.toString(),
                    color: Colors.white,
                    titletype: TitleType.headline,
                    language: Language.center,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: context.resources.dimension.defaultMargin),
                  child: CustomText(
                    content:
                        "${points.pointsSystemConvertRate} ${context.resources.strings.point} = 1.00 ${context.resources.strings.walletMoney}",
                    titletype: TitleType.bottoms,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )).customMargins(),
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
    ).customMargins();
  }

  Widget buildShimmer() {
    return Column(
      children: [
        Container(
          height: 100,
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color:
                    Theme.of(context).colorScheme.lamisColor.withOpacity(0.3),
                offset: const Offset(1.5, 4.5),
                blurRadius: 4.0,
              )
            ],
          ),
        ),
        const FixedHieght(),
      ],
    );
  }
}
