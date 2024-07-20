import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lamis/screens/home/home_screen.dart';

import '../../cubits/cubits.dart';
import '../../data/remote/network/base_api_service.dart';
import '../../models/models.dart';
import '../../res/resources_export.dart';
import '../../widgets/widgets.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({Key? key, required this.productId}) : super(key: key);

  final int productId;

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  ProductReviewCubit productReviewCubit = ProductReviewCubit();

  ProductReviewCubit submitProductReviewCubit = ProductReviewCubit();

  TextEditingController productReviewController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  int pageNumber = 1;

  Set<Review> reviews = {};

  double reviewRating = 0.0;

  FToast fToast = FToast();

  @override
  void initState() {
    productReviewCubit.getReviews(productId: widget.productId);
    fToast.init(context);
    _scrollController.addListener(() {
      if (_scrollController.offset ==
          _scrollController.position.maxScrollExtent) {
        productReviewCubit.getReviews(
            productId: widget.productId, pageNumber: ++pageNumber);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
      appBar: CustomAppBar(title: context.resources.strings.reviews),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //const FixedHieght(),
            // CustomText(
            //   content: context.resources.strings.reviews,
            //   color: Theme.of(context).colorScheme.primaryTextColor,
            //   titletype: TitleType.headline,
            // ),
            Expanded(
              child: BlocBuilder<ProductReviewCubit, ProductReviewState>(
                bloc: productReviewCubit,
                builder: (context, state) {
                  if (state is ProductReviewLoading) {
                    return ListView.builder(
                      itemCount: 4,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return DelayedAnimation(
                          delay: index * 100,
                          fromSide: FromSide.right,
                          child: const ReviewCardShimmer(),
                        );
                      },
                    );
                  }
                  if (state is ProductReviewDone ||
                      state is ProductReviewPagination) {
                    if (state is ProductReviewDone) {
                      reviews.addAll(state.response?.reviews ?? {});
                    }
                    if (reviews.isEmpty) {
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
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: reviews.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return DelayedAnimation(
                                delay: index * 10,
                                fromSide: FromSide.right,
                                child: ReviewCard(
                                  disableEdit: true,
                                  review: reviews.elementAt(index),
                                ),
                              );
                            },
                          ).customMargins(),
                        ),
                        Expanded(
                            flex: 0,
                            child: AnimatedContainer(
                              duration: const Duration(seconds: 1),
                              color: Colors.grey,
                              height:
                                  (state is ProductReviewPagination) ? 25 : 0,
                              child: Center(
                                child: CustomText(
                                  content: context.resources.strings.loading,
                                  titletype: TitleType.bottoms,
                                  language: Language.center,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryTextColor,
                                ),
                              ),
                            ))
                      ],
                    );
                  }
                  if (state is ProductReviewError) {
                    return CustomErrorWidget(onTap: () {
                      productReviewCubit.getReviews(
                          productId: widget.productId);
                      _scrollController.addListener(() {
                        if (_scrollController.offset ==
                            _scrollController.position.maxScrollExtent) {
                          productReviewCubit.getReviews(
                              productId: widget.productId,
                              pageNumber: ++pageNumber);
                        }
                      });
                    });
                  }
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
                },
              ),
            ),
            context.read<IsLoggedInCubit>().state
                ? BlocConsumer<ProductReviewCubit, ProductReviewState>(
                    bloc: submitProductReviewCubit,
                    listener: (context, state) {
                      if (state is ProductReviewDone) {
                        reviews.clear();
                        productReviewCubit.getReviews(
                            productId: widget.productId);
                      }
                      if (state is ProductReviewError) {
                        fToast.showToast(
                          child: ToastBody(
                            text: state.message,
                            iconColor: Theme.of(context).colorScheme.redColor,
                            bgColor:
                                Theme.of(context).colorScheme.toastBackGround,
                          ),
                          gravity: ToastGravity.CENTER,
                          toastDuration: const Duration(seconds: 2),
                        );
                      }
                    },
                    builder: (context, state) {
                      return Container(
                        height: 130,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.scaffoldColor,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(0.0),
                                bottomRight: Radius.circular(0.0)),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .shadowColor
                                    .withOpacity(0.5),
                                spreadRadius: 0.2,
                                blurRadius: 5,
                                offset: const Offset(
                                    0, 0), // changes position of shadow
                              ),
                            ]),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      context.resources.dimension.smallMargin,
                                  top: context.resources.dimension.smallMargin),
                              child: RatingBar(
                                itemSize: context.resources.dimension.bigMargin,
                                ignoreGestures: (state is ProductReviewLoading)
                                    ? true
                                    : false,
                                initialRating: 0.0,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                ratingWidget: RatingWidget(
                                    full: Icon(Icons.star,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .yellowColor),
                                    empty: Icon(Icons.star_border,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .yellowColor),
                                    half: Icon(Icons.star_half,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .yellowColor)),
                                itemPadding: EdgeInsets.only(
                                    right: context
                                        .resources.dimension.selectedBorder),
                                onRatingUpdate: (rating) {
                                  reviewRating = rating;
                                },
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(
                                right: context.resources.dimension.bigMargin,
                                left: context.resources.dimension.bigMargin,
                                bottom: context.resources.dimension.smallMargin,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    context.resources.dimension.bigMargin)),
                                color:
                                    Theme.of(context).colorScheme.scaffoldColor,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                      child: Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(35)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .shadow200,
                                            offset: const Offset(0, 5),
                                            blurRadius: 5,
                                            spreadRadius: 1),
                                      ],
                                      // color: Theme.of(context)
                                      //     .colorScheme
                                      //     .background
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: CustomTextField(
                                            transparentBackground: true,
                                            label: context
                                                .resources.strings.comment,
                                            onChange: (value) {
                                              productReviewController.text =
                                                  value;
                                            },
                                            enabled:
                                                (state is ProductReviewLoading)
                                                    ? false
                                                    : true,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: context.resources.dimension
                                                  .smallMargin),
                                          child: (state is ProductReviewLoading)
                                              ? CircularProgressIndicator(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .lamisColor)
                                              : GestureDetector(
                                                  child: Icon(
                                                    Icons.send,
                                                    size: 30,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .lamisColor,
                                                  ),
                                                  onTap: () {
                                                    HapticFeedback
                                                        .heavyImpact();
                                                    submitProductReviewCubit
                                                        .submitReview(
                                                      comment:
                                                          productReviewController
                                                              .text,
                                                      rating: reviewRating,
                                                      productId:
                                                          widget.productId,
                                                    );
                                                  },
                                                ),
                                        )
                                      ],
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  const ReviewCard({Key? key, required this.review, this.disableEdit = false})
      : super(key: key);

  final Review review;
  final bool disableEdit;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      margin: EdgeInsets.only(
        // bottom: context.resources.dimension.smallMargin,
        top: context.resources.dimension.bigMargin,
      ),
      padding: EdgeInsets.all(context.resources.dimension.mediumMargin),
      decoration: BoxDecoration(
          //color: Theme.of(context).colorScheme.background,
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: Theme.of(context).colorScheme.blueShadeLiner),
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.shadow200,
                offset: const Offset(10, 10),
                blurRadius: 5,
                spreadRadius: 1),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: context.resources.dimension.circularImageContainer,
                height: context.resources.dimension.circularImageContainer,
                padding: EdgeInsets.only(
                    top: context.resources.dimension.mediumMargin,
                    left: context.resources.dimension.smallMargin),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      context.resources.dimension.circularImageBorderRadius),
                  child: review.avatar != BaseApiService.imagesRoute
                      ? CachedNetworkImage(
                          imageUrl: review.avatar!,
                          fadeOutDuration: const Duration(seconds: 1),
                          fadeInDuration: const Duration(seconds: 3),
                          errorWidget: (context, url, error) => Image.asset(
                              'assets/images/user_image_place_holder.png'),
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/user_image_place_holder.png'),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: context.resources.dimension.mediumMargin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        content: review.userName ?? '',
                        titletype: TitleType.subtitle,
                        color: Theme.of(context).colorScheme.primaryTextColor,
                      ),
                      RatingBar(
                        itemSize: context.resources.dimension.bigMargin,
                        ignoreGestures: disableEdit,
                        initialRating: review.rating ?? 0.0,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        ratingWidget: RatingWidget(
                            full: Icon(Icons.star,
                                color:
                                    Theme.of(context).colorScheme.yellowColor),
                            empty: Icon(Icons.star_border,
                                color:
                                    Theme.of(context).colorScheme.yellowColor),
                            half: Icon(Icons.star_half,
                                color:
                                    Theme.of(context).colorScheme.yellowColor)),
                        itemPadding: const EdgeInsets.only(right: 0),
                        onRatingUpdate: (rating) {},
                      ),
                      // CustomText(
                      //   content: review.time ?? '',
                      //   titletype: TitleType.time,
                      //   color: Theme.of(context).colorScheme.primaryTextColor,
                      // ),
                      CustomText(
                        content: review.comment ?? '',
                        titletype: TitleType.body,
                        color: Theme.of(context).colorScheme.primaryTextColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: CustomText(
              content: review.time ?? '',
              titletype: TitleType.bottoms,
              color: Theme.of(context).colorScheme.lamisColor,
              language: Language.rtl,
            ),
          )
        ],
      ),
    );
  }
}

class ReviewCardShimmer extends StatelessWidget {
  const ReviewCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        // bottom: context.resources.dimension.smallMargin,
        top: context.resources.dimension.smallMargin,
      ),
      padding: EdgeInsets.all(context.resources.dimension.smallMargin),
      decoration: BoxDecoration(
        // color: Theme.of(context).colorScheme.primaryText.withOpacity(0.3),
        color: Theme.of(context).colorScheme.background.withOpacity(0.5),
        borderRadius: BorderRadius.all(
          Radius.circular(context.resources.dimension.smallText),
        ),
      ),
    );
  }
}
