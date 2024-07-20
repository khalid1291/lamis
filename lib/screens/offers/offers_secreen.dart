import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/models/models.dart';
import 'package:lamis/res/resources_export.dart';

import 'package:lamis/widgets/widgets.dart';

import '../../blocs/home/today_deal_bloc/today_deal_bloc.dart';
import '../../cubits/cubits.dart';
import '../screens.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({Key? key}) : super(key: key);

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  final FlashDealsCubit _flashDeal = FlashDealsCubit();
  final TodayDealBloc _todaysBloc = TodayDealBloc();

  @override
  void initState() {
    _todaysBloc.add(OffersFetch());
    _flashDeal.getFlashDeals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
      body: ListView(
        children: [
          const FixedHieght(),
          Container(
            height: 30,
            alignment: context.read<LocalizationCubit>().state ==
                    const Locale('ar', '')
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: CustomText(
              content: context.resources.strings.offers,
              titletype: TitleType.headline,
              color: Theme.of(context).colorScheme.primaryTextColor,
            ),
          ),
          const FixedHieght(),
          buildFlashDeal(_flashDeal, () {
            _todaysBloc.add(OffersFetch());
            _flashDeal.getFlashDeals();
          }),
          const FixedHieght(),
          buildTodaysDealCards(_todaysBloc),
        ],
      ).customMargins(),
    );
  }

  buildTodaysDealCards(TodayDealBloc todaysBloc) {
    ScrollController todaysDealScrollController = ScrollController();
    return BlocBuilder<TodayDealBloc, TodayDealState>(
        bloc: todaysBloc,
        builder: (context, state) {
          if (state is TodayDealLoading) {
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ListView.builder(
                shrinkWrap: true,
                controller: todaysDealScrollController,
                scrollDirection: Axis.vertical,
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
                        height: 100,
                        width: MediaQuery.of(context).size.width * 0.8,
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
          if (state is TodayDealDone) {
            // ignore: prefer_is_empty
            if (state.value.products.length == 0) {
              return Column(
                children: [
                  const FixedHieght(
                    extra: true,
                  ),
                  SizedBox(
                    height: context.resources.dimension.largeContainerSize,
                    width: context.resources.dimension.largeContainerSize,
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FixedHieght(),
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
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
                            child: Column(
                              children: [
                                _ToDaysDealCard(
                                  response: product,
                                ),
                                const FixedHieght(),
                              ],
                            ),
                          ),
                        );
                      }),
                ],
              );
            }
          }
          if (state is TodayDealError) {
            return CustomErrorWidget(
              onTap: () {
                _todaysBloc.add(OffersFetch());
                _flashDeal.getFlashDeals();
              },
            );
          }

          return Container();
        });
  }
}

class _ToDaysDealCard extends StatelessWidget {
  const _ToDaysDealCard({Key? key, required this.response}) : super(key: key);
  final MiniProduct response;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetails(
            image: response.thumbnailImage,
            id: response.id,
          );
        }));
      },
      child: Container(
        margin: EdgeInsets.all(context.resources.dimension.lightElevation),
        padding: EdgeInsets.all(context.resources.dimension.lightElevation),
        height: context.resources.dimension.circularImageContainer,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: Theme.of(context).colorScheme.grayShadeLiner),
          borderRadius:
              BorderRadius.circular(context.resources.dimension.mediumMargin),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.shadow200,
                offset: const Offset(15, 10),
                blurRadius: 5,
                spreadRadius: 1),
            BoxShadow(
                color: Theme.of(context).colorScheme.homeScreen,
                offset: const Offset(-10, -10),
                blurRadius: 5,
                spreadRadius: 1),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16), bottom: Radius.zero),
                child: CachedNetworkImage(
                    // imageUrl: "https://via.placeholder.com/350x200",
                    imageUrl: response.thumbnailImage,
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
            const SizedBox(
              width: 4,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomText(
                        content: response.name,
                        color: Theme.of(context).colorScheme.primaryTextColor,
                        titletype: TitleType.bottoms,
                        language: context.read<LocalizationCubit>().state ==
                                const Locale('ar', '')
                            ? Language.rtl
                            : Language.ltr,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        response.hasDiscount
                            ? Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CustomText(
                                        content: response.strokedPrice,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .redColor,
                                        textDecore: TextDecoration.lineThrough,
                                        titletype: TitleType.body,
                                        language: context
                                                    .read<LocalizationCubit>()
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
                                        content: response.mainPrice,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryTextColor,
                                        titletype: TitleType.bottoms,
                                        language: context
                                                    .read<LocalizationCubit>()
                                                    .state ==
                                                const Locale('en', '')
                                            ? Language.rtl
                                            : Language.ltr,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Expanded(
                                child: CustomText(
                                  content: response.mainPrice,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryTextColor,
                                  titletype: TitleType.bottoms,
                                  language:
                                      context.read<LocalizationCubit>().state ==
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
