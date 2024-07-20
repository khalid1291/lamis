import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/data/remote/remote.dart';
import 'package:lamis/res/resources_export.dart';
import 'package:lamis/screens/home/notifications_screen.dart';
import 'package:lamis/screens/orders/rebuy_screen.dart';
import 'package:lamis/screens/screens.dart';

import 'package:share_plus/share_plus.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../cubits/cubits.dart';
import '../repos/repos.dart';
import '../widgets/widgets.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Drawer(
        elevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.drawerColor,
        shape: RoundedRectangleBorder(
          borderRadius:
              context.watch<LocalizationCubit>().state == const Locale('ar', '')
                  ? BorderRadius.only(
                      bottomLeft: Radius.circular(
                          context.resources.dimension.drawerBorderRadios),
                      topLeft: Radius.circular(
                          context.resources.dimension.drawerBorderRadios))
                  : BorderRadius.only(
                      bottomRight: Radius.circular(
                          context.resources.dimension.drawerBorderRadios),
                      topRight: Radius.circular(
                          context.resources.dimension.drawerBorderRadios)),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 80,
            ),
            BlocBuilder(
              bloc: context.read<CurrentThemeCubit>(),
              builder: (context, state) {
                return CustomPaint(
                  painter: MyPainter(
                      context: context,
                      locale: context.watch<LocalizationCubit>().state),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: context.watch<LocalizationCubit>().state ==
                              const Locale('ar', '')
                          ? BorderRadius.only(
                              topLeft: Radius.circular(context
                                  .resources.dimension.drawerBorderRadios))
                          : BorderRadius.only(
                              topRight: Radius.circular(context
                                  .resources.dimension.drawerBorderRadios)),
                      // color: Theme.of(context).colorScheme.lamisColor,
                    ),
                    child: CustomPaint(
                      child: Stack(
                        children: [
                          CustomPaint(
                            child: context.watch<IsLoggedInCubit>().state
                                ? Center(
                                    child: Column(
                                      children: [
                                        Container(
                                          width: context.resources.dimension
                                              .circularImageContainer,
                                          height: context.resources.dimension
                                              .circularImageContainer,
                                          margin: EdgeInsets.only(
                                              top: context.resources.dimension
                                                  .bigMargin,
                                              left: context.resources.dimension
                                                  .smallMargin),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                context.resources.dimension
                                                    .circularImageContainer),
                                            child: UserRepo()
                                                        .user
                                                        .avatarOriginal !=
                                                    BaseApiService.imagesRoute
                                                ? CachedNetworkImage(
                                                    imageUrl: UserRepo()
                                                        .user
                                                        .avatarOriginal,
                                                    fadeOutDuration:
                                                        const Duration(
                                                            seconds: 1),
                                                    fadeInDuration:
                                                        const Duration(
                                                            seconds: 3),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        Image.asset(
                                                            'assets/images/user_image_place_holder.png'),
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    'assets/images/user_image_place_holder.png'),
                                          ),
                                        ),
                                        // padding: EdgeInsets.only(
                                        //     // top: context.resources.dimension.zeroElevation,
                                        //     left: context
                                        //         .resources.dimension.zeroElevation),
                                        const FixedHieght(),
                                        CustomText(
                                          content: UserRepo().user.name,
                                          titletype: TitleType.subtitle,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryTextColor,
                                        ),
                                      ],
                                    ),
                                  )
                                : Center(
                                    child: Column(
                                      children: [
                                        Container(
                                          width: context.resources.dimension
                                              .middleContainerSize,
                                          height: context.resources.dimension
                                              .middleContainerSize,
                                          margin: EdgeInsets.only(
                                              top: context.resources.dimension
                                                  .bigMargin,
                                              left: context.resources.dimension
                                                  .smallMargin),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                context.resources.dimension
                                                    .circularImageContainer),
                                            child: Image.asset(context
                                                .resources.images.logoImage),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 50,
            ),

            // context.watch<IsLoggedInCubit>().state
            //     ? ListTile(
            //         // leading: Icon(
            //         //   Icons.location_on_outlined,
            //         //   color: Theme.of(context).colorScheme.primaryTextColor,
            //         // ),
            //         title: Row(
            //           children: [
            //             Icon(
            //               Icons.location_on_outlined,
            //               color: Theme.of(context).colorScheme.primaryTextColor,
            //             ),
            //             const SizedBox(
            //               width: 15,
            //             ),
            //             CustomText(
            //               content: context.resources.strings.address,
            //               color: Theme.of(context).colorScheme.primaryTextColor,
            //               titletype: TitleType.subtitle,
            //               language: context.watch<LocalizationCubit>().state ==
            //                       const Locale('ar', '')
            //                   ? Language.rtl
            //                   : Language.ltr,
            //             ),
            //           ],
            //         ),
            //         onTap: () async {
            //           await Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) {
            //                 return const AddressScreen();
            //               },
            //             ),
            //           );
            //         },
            //       )
            //     : Container(),

            context.watch<IsLoggedInCubit>().state
                ? ListTile(
                    title: Row(
                      children: [
                        Icon(
                          Icons.favorite_outline,
                          color: Theme.of(context).colorScheme.primaryTextColor,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        CustomText(
                          content: context.resources.strings.wishlist,
                          color: Theme.of(context).colorScheme.primaryTextColor,
                          titletype: TitleType.subtitle,
                          language: context.watch<LocalizationCubit>().state ==
                                  const Locale('ar', '')
                              ? Language.rtl
                              : Language.ltr,
                        ),
                      ],
                    ),
                    onTap: () async {
                      HapticFeedback.heavyImpact();
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const WishListScreen();
                          },
                        ),
                      );
                    },
                  )
                : Container(),
            context.watch<IsLoggedInCubit>().state
                ? ListTile(
                    // leading: Icon(
                    //   Icons.assignment_outlined,
                    //   color: Theme.of(context).colorScheme.primaryTextColor,
                    // ),
                    title: Row(
                      children: [
                        ImageIcon(
                          AssetImage(context.resources.images.ordersIcon),
                          color: Theme.of(context).colorScheme.ordersIcon,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        CustomText(
                          content: context.resources.strings.orders,
                          color: Theme.of(context).colorScheme.primaryTextColor,
                          titletype: TitleType.subtitle,
                          // typefont: Typefont.amiri,
                          language: context.watch<LocalizationCubit>().state ==
                                  const Locale('ar', '')
                              ? Language.rtl
                              : Language.ltr,
                        ),
                      ],
                    ),
                    onTap: () async {
                      HapticFeedback.heavyImpact();
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const OrderList();
                          },
                        ),
                      );
                    },
                  )
                : Container(),
            if (context.watch<IsLoggedInCubit>().state)
              ListTile(
                title: Row(
                  children: [
                    Icon(
                      Icons.cases_outlined,
                      color: Theme.of(context).colorScheme.ordersIcon,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    CustomText(
                      content: context.resources.strings.myProducts,
                      color: Theme.of(context).colorScheme.primaryTextColor,
                      titletype: TitleType.subtitle,
                      language: context.watch<LocalizationCubit>().state ==
                              const Locale('ar', '')
                          ? Language.rtl
                          : Language.ltr,
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const RebuyScreen();
                      },
                    ),
                  );
                },
              ),

            if (context.watch<IsLoggedInCubit>().state)
              ListTile(
                title: Row(
                  children: [
                    Icon(
                      Icons.notifications,
                      color: Theme.of(context).colorScheme.primaryTextColor,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    CustomText(
                      content: context.resources.strings.notification,
                      color: Theme.of(context).colorScheme.primaryTextColor,
                      titletype: TitleType.subtitle,
                      language: context.watch<LocalizationCubit>().state ==
                              const Locale('ar', '')
                          ? Language.rtl
                          : Language.ltr,
                    ),
                  ],
                ),
                onTap: () async {
                  HapticFeedback.heavyImpact();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const NotificationScreen();
                      },
                    ),
                  );
                },
              ),

            ListTile(
              // leading: Icon(
              //   Icons.settings_outlined,
              //   color: Theme.of(context).colorScheme.lamisColor,
              // ),
              title: Row(
                children: [
                  Icon(
                    Icons.share_rounded,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  CustomText(
                    content: context.resources.strings.inviteFriends,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                    titletype: TitleType.subtitle,
                    //typefont: Typefont.amiri,
                    language: context.watch<LocalizationCubit>().state ==
                            const Locale('ar', '')
                        ? Language.rtl
                        : Language.ltr,
                  ),
                ],
              ),
              onTap: () async {
                // String appStoreId = "1629213305"; // Your app's App Store ID
                // final packageName =
                //     (await PackageInfo.fromPlatform()).packageName;
                final box = context.findRenderObject() as RenderBox?;

                String second = context.read<IsLoggedInCubit>().state ||
                        UserRepo().user.code != null
                    // ignore: use_build_context_synchronously
                    ? "${context.resources.strings.inviteSecondMessage} ${UserRepo().user.code} "
                    : "";
                Share.share(
                    // ignore: use_build_context_synchronously
                    "${context.resources.strings.inviteFirstMessage}. \n ${BaseApiService.rootUrl}/getappstore  \n $second",
                    // ignore: use_build_context_synchronously
                    subject: context.resources.strings.inviteFriends,
                    sharePositionOrigin:
                        box!.localToGlobal(Offset.zero) & box.size);
              },
            ),
            ListTile(
              // leading: Icon(
              //   Icons.settings_outlined,
              //   color: Theme.of(context).colorScheme.lamisColor,
              // ),
              title: Row(
                children: [
                  Icon(
                    Icons.settings_outlined,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  CustomText(
                    content: context.resources.strings.settings,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                    titletype: TitleType.subtitle,
                    //typefont: Typefont.amiri,
                    language: context.watch<LocalizationCubit>().state ==
                            const Locale('ar', '')
                        ? Language.rtl
                        : Language.ltr,
                  ),
                ],
              ),
              onTap: () async {
                HapticFeedback.heavyImpact();
                var res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const SettingsScreen();
                    },
                  ),
                );
                if (res != null && res) {
                  // setState(() {});
                }
              },
            ),
            ListTile(
              // leading: Icon(
              //   Icons.help_outline,
              //   color: Theme.of(context).colorScheme.primaryTextColor,
              // ),
              title: Row(
                children: [
                  ImageIcon(
                    AssetImage(context.resources.images.privacyImage),
                    color: Theme.of(context).colorScheme.ordersIcon,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  CustomText(
                    content: context.resources.strings.privacyPolicy,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                    titletype: TitleType.subtitle,
                    language: context.watch<LocalizationCubit>().state ==
                            const Locale('ar', '')
                        ? Language.rtl
                        : Language.ltr,
                  ),
                ],
              ),
              onTap: () async {
                HapticFeedback.heavyImpact();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const WebViewForUrl(
                    url: BaseApiService.rootUrl + ApiEndPoints.privacyPolicy,
                  );
                }));
                // var url = Uri.parse(
                //   BaseApiService.rootUrl + ApiEndPoints.privacyPolicy,
                // );

                // if (await canLaunchUrl(url)) {
                //
                //   await launchUrl(
                //     url,
                //     mode: LaunchMode.externalApplication,
                //   );
                // } else {
                //   throw 'Could not launch $url';
                // }
              },
            ),
            ListTile(
              title: Row(
                children: [
                  ImageIcon(
                    AssetImage(context.resources.images.termImage),
                    color: Theme.of(context).colorScheme.ordersIcon,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  CustomText(
                    content: context.resources.strings.termAndCondition,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                    titletype: TitleType.subtitle,
                    language: context.watch<LocalizationCubit>().state ==
                            const Locale('ar', '')
                        ? Language.rtl
                        : Language.ltr,
                  ),
                ],
              ),
              onTap: () async {
                HapticFeedback.heavyImpact();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const WebViewForUrl(
                      url: BaseApiService.rootUrl +
                          ApiEndPoints.termAndCondition);
                }));
              },
            ),

            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.people_outline_rounded,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  CustomText(
                    content: context.resources.strings.connectWithUs,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                    titletype: TitleType.subtitle,
                    language: context.watch<LocalizationCubit>().state ==
                            const Locale('ar', '')
                        ? Language.rtl
                        : Language.ltr,
                  ),
                ],
              ),
              onTap: () async {
                HapticFeedback.heavyImpact();
                var res = await BottomSheets.showModal(context,
                    type: BottomSheetType.big,
                    hasBorderMargin: true,
                    child: const SocialLinksScreen());

                if (res) {
                  // ignore: use_build_context_synchronously
                  Navigator.maybeOf(context);
                }
              },
            ),

            context.watch<IsLoggedInCubit>().state
                ? ListTile(
                    // leading: Icon(
                    //   Icons.logout,
                    //   color: Theme.of(context).colorScheme.primaryTextColor,
                    // ),
                    title: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: Theme.of(context).colorScheme.primaryTextColor,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        CustomText(
                          content: context.resources.strings.logout,
                          color: Theme.of(context).colorScheme.primaryTextColor,
                          titletype: TitleType.subtitle,
                          language: context.watch<LocalizationCubit>().state ==
                                  const Locale('ar', '')
                              ? Language.rtl
                              : Language.ltr,
                        ),
                      ],
                    ),
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      context.read<IsLoggedInCubit>().logOut(context: context);
                      context.read<MainPageCartCubit>().fetchRemoteData();
                      Navigator.maybePop(context);
                    },
                  )
                : ListTile(
                    // leading: Icon(
                    //   Icons.login,
                    //   color: Theme.of(context).colorScheme.primaryTextColor,
                    // ),
                    title: Row(
                      children: [
                        Icon(
                          Icons.login,
                          color: Theme.of(context).colorScheme.primaryTextColor,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        CustomText(
                          content: context.resources.strings.login,
                          color: Theme.of(context).colorScheme.primaryTextColor,
                          titletype: TitleType.subtitle,
                          // typefont: Typefont.amiri,
                          language: context.watch<LocalizationCubit>().state ==
                                  const Locale('ar', '')
                              ? Language.rtl
                              : Language.ltr,
                        ),
                      ],
                    ),
                    onTap: () async {
                      HapticFeedback.heavyImpact();
                      var res = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginScreen(
                              prevCountry: UserRepo().country,
                            );
                          },
                        ),
                      );
                      if (res != null && res == true) {
                        // ignore: use_build_context_synchronously
                        Navigator.maybePop(context);
                      }
                    },
                  ),
          ],
        ).customMargins(),
      ),
    );
  }
}

class LanguageChip extends StatelessWidget {
  const LanguageChip({
    Key? key,
    required this.text,
    required this.lang,
  }) : super(key: key);

  final String text;
  final String lang;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        context.read<LocalizationCubit>().changeLanguage(lang);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Center(
          child: AppButton(
            onTap: () {
              HapticFeedback.heavyImpact();
              context.read<LocalizationCubit>().changeLanguage(lang);
            },
            buttonText: text,
            buttonSize: ButtonSize.big,
            color: context.read<LocalizationCubit>().state.languageCode == lang
                ? Theme.of(context).colorScheme.lamisColor
                : Theme.of(context).colorScheme.disabledColor,
          ),
        ),
        // Chip(
        //   backgroundColor:
        //       context.read<LocalizationCubit>().state.languageCode == lang
        //           ? Theme.of(context).colorScheme.lamisColor
        //           : Theme.of(context).colorScheme.cardColor,
        //   label: Text(
        //     text,
        //     style: const TextStyle(color: Colors.white),
        //   ),
        // ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final BuildContext context;

  LinePainter(this.context);
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Theme.of(context).colorScheme.scaffoldColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..maskFilter = MaskFilter.blur(BlurStyle.solid, convertRadiusToSigma(3));

    final arc1 = Path();
    arc1.moveTo(size.width * 0.45, 0);

    arc1.arcToPoint(
      Offset(0, size.height * 0.55),
      radius: const Radius.circular(200),
      clockwise: true,
    );

    canvas.drawPath(arc1, paint);

    final arc2 = Path();
    arc2.moveTo(size.width * 0.51, 0);

    arc2.arcToPoint(
      Offset(size.width, size.height * 0.1),
      radius: const Radius.circular(130),
      clockwise: false,
    );
    canvas.drawPath(arc2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  static double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }
}

// This is the Painter class
enum CircleAlignment {
  firstCircle,
  topRight,
  bottomLeft,
  bottomRight,
}

class MyPainter extends CustomPainter {
  final CircleAlignment circleAlignment = CircleAlignment.firstCircle;
  final BuildContext context;
  final Locale locale;
  MyPainter({required this.context, required this.locale});
  // MyPainter({required Listenable repaint, required this.context}) : super(repaint: repaint) {
  //   _repaint = repaint;
  //   player = Provider.of<Player>(context, listen: false);
  // }
  @override
  void paint(Canvas canvas, Size size) {
    final drawerWidth = MediaQuery.of(context).size.width * 0.2;
    final screenWidth = MediaQuery.of(context).size.width;
    final radius = math.min(size.height * 1.5, size.width - drawerWidth);
    Paint paint = Paint();

    final offset3 = locale == const Locale('en', '')
        ? Offset(-drawerWidth, 30)
        : Offset(screenWidth - 50, 30);

    final radius3 = locale == const Locale('en', '')
        ? math.max(size.height * 2.4, size.width + drawerWidth + 15)
        : math.max(size.height * 2.4, size.width + drawerWidth);
    paint.color = Theme.of(context).colorScheme.drawerLayerTow;

    canvas.drawCircle(
      offset3,
      radius3,
      paint,
    );
    final offset2 = locale == const Locale('en', '')
        ? Offset(-drawerWidth / 4.5, 0)
        : Offset(screenWidth - drawerWidth, 0);
    final radius2 = math.min(size.height * 2, size.width);

    paint.color = Theme.of(context).colorScheme.drawerLayerTow;

    canvas.drawCircle(
      offset2,
      radius2,
      paint,
    );
    final offset1 = locale == const Locale('en', '')
        ? const Offset(0, 0)
        : Offset(screenWidth - drawerWidth, 0);
    paint.color = Theme.of(context).colorScheme.drawerLayerOne;
    // paint.shader = RadialGradient(
    //   // begin: Alignment.topCenter,
    //   // end: Alignment.bottomCenter,
    //   radius: 0.0,
    //   colors: [
    //     const Color(0xff9CD1EB),
    //     const Color(0xFF4CA1CA).withOpacity(0.3),
    //   ],
    // ).createShader(rect);

    canvas.drawCircle(
      offset1,
      radius,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class WebViewForUrl extends StatefulWidget {
  final String url;
  const WebViewForUrl({Key? key, required this.url}) : super(key: key);

  @override
  State<WebViewForUrl> createState() => _WebViewForUrlState();
}

class _WebViewForUrlState extends State<WebViewForUrl> {
  late WebViewController _webViewController;

  @override
  void initState() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              setState(() {
                isLoading = false;
              });
            }
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(
          widget.url,
        ),
      );
    super.initState();
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [
            WebViewWidget(controller: _webViewController),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(),
          ],
        ));
  }
}
