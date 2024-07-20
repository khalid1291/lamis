import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/repos/repos.dart';

import 'package:transparent_image/transparent_image.dart';

import '../../cubits/cubits.dart';
import '../../data/remote/network/base_api_service.dart';
import '../../res/resources_export.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ScrollController _mainScrollController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool clubPointAddonInstalled = true;
  bool refundAddonInstalled = true;
  bool otpAddonInstalled = true;

  ProfileCubit profileCubit = ProfileCubit();
  CountersCubit counterCubit = CountersCubit();

  @override
  void initState() {
    _mainScrollController = ScrollController();
    super.initState();
    fetchAll();
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  Future<void> _onPageRefresh() async {
    fetchAll();
  }

  onPopped(value) async {
    fetchAll();
  }

  fetchAll() {
    if (context.read<IsLoggedInCubit>().state) {
      profileCubit.getProfileData();
      counterCubit.getCountersData();
    }
  }

  String usercode = "";
  @override
  Widget build(BuildContext context) {
    // if (context.watch<IsLoggedInCubit>().state == true) {
    //   print("logedin");
    //   fetchAll();
    // }
    return WillPopScope(
      onWillPop: fetchAll(),
      child: Directionality(
        textDirection:
            context.read<LocalizationCubit>().state == const Locale('ar', '')
                ? TextDirection.rtl
                : TextDirection.ltr,
        child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
            key: _scaffoldKey,
            // backgroundColor: Colors.white,
            body: context.watch<IsLoggedInCubit>().state
                ? RefreshIndicator(
                    color: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.background,
                    onRefresh: _onPageRefresh,
                    displacement: 10,
                    child: SingleChildScrollView(
                      child: Column(
                        // controller: _mainScrollController,
                        // physics: const BouncingScrollPhysics(
                        //     parent: AlwaysScrollableScrollPhysics()),
                        children: [
                          BlocBuilder(
                              bloc: profileCubit,
                              builder: (BuildContext context, state) {
                                if (state is ProfileDone) {
                                  UserRepo().user.code =
                                      state.profileResponse.user.code!;
                                  usercode = state.profileResponse.user.code!;
                                  return _TopSectionProfile(
                                    userCode: state.profileResponse.user.code,
                                    userImage: state
                                        .profileResponse.user.avatarOriginal,
                                    userName: state.profileResponse.user.name,
                                    userPhone:
                                        state.profileResponse.user.phone ?? "",
                                  );
                                } else if (state is ProfileLoading) {
                                  return _shimmerTopSection(false);
                                } else {
                                  return _shimmerTopSection(true);
                                  // return GestureDetector(
                                  //     onTap: () {
                                  //       profileCubit.getProfileData();
                                  //     },
                                  //     child: CustomText(
                                  //       language: Language.center,
                                  //       content: context
                                  //           .resources.strings.pleaseReload,
                                  //       titletype: TitleType.subtitle,
                                  //       color: Theme.of(context)
                                  //           .colorScheme
                                  //           .redColor,
                                  //     ));
                                }
                              }),
                          BlocBuilder(
                              bloc: counterCubit,
                              builder: (BuildContext context, state) {
                                if (state is CountersDone) {
                                  return Column(
                                    children: [
                                      const FixedHieght(
                                        extra: true,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomText(
                                            titletype: TitleType.subtitle,
                                            content:
                                                "${context.resources.strings.inviteCode}: ",
                                            language: context
                                                        .read<
                                                            LocalizationCubit>()
                                                        .state ==
                                                    const Locale('ar', "")
                                                ? Language.rtl
                                                : Language.ltr,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .darkBlue,
                                          ),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          Directionality(
                                            textDirection: TextDirection.ltr,
                                            child: CustomText(
                                              content: usercode,
                                              typefont: Typefont.raleway,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .darkBlue,
                                              titletype: TitleType.subtitle,
                                              // language: Language.ltr,
                                            ),
                                          ),
                                        ],
                                      ),
                                      _CounterRow(
                                        cartCounterString: state
                                            .profileCountersResponse
                                            .cartItemCount
                                            .toString(),
                                        wishListCounterString: state
                                            .profileCountersResponse
                                            .wishlistItemCount
                                            .toString(),
                                        orderCounterString: state
                                            .profileCountersResponse.orderCount
                                            .toString(),
                                        onCall: () {
                                          fetchAll();
                                        },
                                      ),
                                    ],
                                  );
                                } else if (state is CountersLoading) {
                                  return _shimmerCountersRow();
                                } else {
                                  return CustomErrorWidget(
                                    onTap: () {
                                      counterCubit.getCountersData();
                                    },
                                  );
                                }
                              }),
                          const FixedHieght(),
                          const CustomDevider(),
                          _BottomSectionProfile(
                            function: fetchAll,
                          ),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: MustLogin(
                      function: fetchAll(),
                    ).customMargins(),
                  )),
      ),
    );
  }

  _shimmerTopSection(bool hasError) {
    return Column(children: [
      Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                      context.resources.dimension.circularImageBorderRadius),
                  bottomRight: Radius.circular(
                      context.resources.dimension.circularImageBorderRadius)),
              color: Theme.of(context).colorScheme.lamisColor.withOpacity(0.3),
            ),

            child: hasError
                ? Center(child: CustomErrorWidget(
                    onTap: () {
                      profileCubit.getProfileData();
                    },
                  ))
                : Container(),
            // child: CustomPaint(painter: LinePainter(), child: Container()),
          ),
        ],
      ),
    ]);
  }

  _shimmerCountersRow() {
    return Padding(
      padding:
          EdgeInsets.only(top: context.resources.dimension.veryHighElevation),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Column(
          //   children: [
          //     // Padding(
          //     //     padding: EdgeInsets.only(
          //     //         top: context.resources.dimension.smallMargin),
          //     //     child: Badge(
          //     //       badgeColor: Colors.transparent,
          //     //       badgeContent: const Text(
          //     //         "",
          //     //       ),
          //     //       child: Icon(
          //     //         Icons.shopping_cart_outlined,
          //     //         size: 30,
          //     //         color: Theme.of(context).colorScheme.iconColor,
          //     //       ),
          //     //     )),
          //     // Padding(
          //     //   padding: EdgeInsets.only(
          //     //       top: context.resources.dimension.verySmallMargin),
          //     //   child: CustomText(
          //     //     content: context.resources.strings.inYourCart,
          //     //     typefont: Typefont.amiri,
          //     //     titletype: TitleType.bottoms,
          //     //   ),
          //     // ),
          //   ],
          // ),
          Column(
            children: [
              Padding(
                  padding: EdgeInsets.only(
                      top: context.resources.dimension.smallMargin),
                  child: badge.Badge(
                    badgeStyle:
                        const badge.BadgeStyle(badgeColor: Colors.transparent),
                    badgeContent: const Text(
                      "",
                    ),
                    child: Icon(
                      Icons.favorite_outline,
                      size: 30,
                      color: Theme.of(context).colorScheme.iconColor,
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(
                    top: context.resources.dimension.verySmallMargin),
                child: CustomText(
                  content: context.resources.strings.inWishlist,
                  typefont: Typefont.amiri,
                  titletype: TitleType.bottoms,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                  padding: EdgeInsets.only(
                      top: context.resources.dimension.smallMargin),
                  child: badge.Badge(
                    badgeStyle:
                        const badge.BadgeStyle(badgeColor: Colors.transparent),
                    badgeContent: CustomText(
                      content: "",
                    ),
                    child: Icon(
                      Icons.reorder_outlined,
                      size: 30,
                      color: Theme.of(context).colorScheme.iconColor,
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(
                    top: context.resources.dimension.verySmallMargin),
                child: CustomText(
                  content: context.resources.strings.inOrderd,
                  typefont: Typefont.amiri,
                  titletype: TitleType.bottoms,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _CounterRow extends StatelessWidget {
  const _CounterRow({
    Key? key,
    required String cartCounterString,
    required String wishListCounterString,
    required String orderCounterString,
    required this.onCall,
  })  : _wishListCounterString = wishListCounterString,
        _orderCounterString = orderCounterString,
        super(key: key);

  final String _wishListCounterString;

  final String _orderCounterString;
  final Function onCall;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(top: context.resources.dimension.veryHighElevation),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // _CounterIcon(
          //   content: context.resources.strings.inYourCart,
          //   icon: Icons.shopping_cart_outlined,
          //   badgeNumber: _cartCounterString,
          //   function: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) {
          //           return const CartScreen();
          //         },
          //       ),
          //     );
          //   },
          // ),
          _CounterIcon(
            content: context.resources.strings.inWishlist,
            icon: Icons.favorite_outline,
            badgeNumber: _wishListCounterString,
            function: () async {
              var res = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const WishListScreen();
                  },
                ),
              );
              if (res) {
                onCall();
              }
            },
          ),
          _CounterIcon(
            content: context.resources.strings.inOrderd,
            icon: Icons.reorder_outlined,
            badgeNumber: _orderCounterString,
            function: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const OrderList();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TopSectionProfile extends StatelessWidget {
  const _TopSectionProfile({
    Key? key,
    required this.userImage,
    required this.userName,
    required this.userPhone,
    this.userCode,
  }) : super(key: key);

  final String userImage;
  final String userName;
  final String userPhone;
  final String? userCode;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(
                    context.resources.dimension.circularImageBorderRadius),
                bottomRight: Radius.circular(
                    context.resources.dimension.circularImageBorderRadius)),
            color: Theme.of(context).colorScheme.lamisColor.withOpacity(0.3),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(
                    context.resources.dimension.circularImageBorderRadius),
                bottomRight: Radius.circular(
                    context.resources.dimension.circularImageBorderRadius)),
            child: userImage != BaseApiService.imagesRoute
                ? FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: userImage,
                    fit: BoxFit.fill,
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
                  )
                : Image.asset(
                    'assets/images/user_image_place_holder.png',
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Positioned(
            bottom: 1,
            child: Container(
              height: 90,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(
                        context.resources.dimension.circularImageBorderRadius),
                    bottomRight: Radius.circular(
                        context.resources.dimension.circularImageBorderRadius)),
                color: Theme.of(context)
                    .colorScheme
                    .userInfoCard
                    .withOpacity(0.65),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      content: userName,
                      typefont: Typefont.raleway,
                      color: Colors.white,
                      titletype: TitleType.headline,
                      // language: Language.ltr,
                    ),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: CustomText(
                        content: userPhone,
                        typefont: Typefont.raleway,
                        color: Colors.white,
                        titletype: TitleType.bottoms,
                        // language: Language.ltr,
                      ),
                    ),
                  ],
                ),
              ),
            ))
      ],
    );
  }
}

class _BottomSectionProfile extends StatelessWidget {
  const _BottomSectionProfile({
    Key? key,
    required this.function,
  }) : super(key: key);
  final VoidCallback function;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: context.resources.dimension.veryHighElevation),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: context.resources.dimension.bigMargin,
          ),
          _CustomInkWall(
            content: context.resources.strings.wallet,
            image: context.resources.images.walletIcon,
            function: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const WalletScreen();
              }));
            },
          ),
          _CustomInkWall(
            content: context.resources.strings.point,
            image: context.resources.images.pointIcon,
            function: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const PointScreen();
              }));
            },
          ),
          _CustomInkWall(
            content: context.resources.strings.updateProfile,
            image: context.resources.images.editProfileIcon,
            function: () async {
              var res = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const ProfileEdit();
                  },
                ),
              );
              if (res != null && res == true) {
                function();
              }
              // var result =
              //     Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return const ProfileEdit();
              // }));
            },
          ),
          _CustomInkWall(
            content: context.resources.strings.address,
            image: "",
            enableIcon: true,
            iconData: Icons.location_on_outlined,
            function: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const AddressScreen();
              }));
            },
          )
        ],
      ),
    );
  }
}

class _CustomInkWall extends StatelessWidget {
  const _CustomInkWall(
      {required this.content,
      required this.image,
      required this.function,
      this.enableIcon = false,
      this.iconData = Icons.add});
  final String image;
  final bool enableIcon;
  final IconData iconData;
  final String content;
  final VoidCallback function;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Visibility(
        visible: true,
        child: Padding(
          padding: EdgeInsets.only(
              bottom: context.resources.dimension.defaultMargin),
          child: Row(
            children: [
              Container(
                  height: 45,
                  width: 50,
                  decoration: const BoxDecoration(
                    // color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(
                          context.resources.dimension.smallMargin),
                      child: enableIcon
                          ? Icon(
                              iconData,
                              color: Theme.of(context).colorScheme.iconColor,
                            )
                          : ImageIcon(
                              AssetImage(image),
                              color: Theme.of(context).colorScheme.iconColor,
                            ))),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: context.resources.dimension.defaultMargin),
                child: CustomText(
                  content: content,
                  typefont: Typefont.amiri,
                  titletype: TitleType.bottoms,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _CounterIcon extends StatelessWidget {
  const _CounterIcon(
      {required this.content,
      required this.icon,
      required this.badgeNumber,
      required this.function});
  final String content;
  final String badgeNumber;
  final IconData icon;
  final VoidCallback function;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Column(
        children: [
          Padding(
              padding:
                  EdgeInsets.only(top: context.resources.dimension.smallMargin),
              child: badge.Badge(
                badgeStyle:
                    const badge.BadgeStyle(badgeColor: Colors.transparent),
                badgeContent: Text(
                  badgeNumber,
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: Theme.of(context).colorScheme.iconColor,
                ),
              )),
          Padding(
            padding: EdgeInsets.only(
                top: context.resources.dimension.verySmallMargin),
            child: CustomText(
              content: content,
              typefont: Typefont.amiri,
              titletype: TitleType.bottoms,
            ),
          ),
        ],
      ),
    );
  }
}
