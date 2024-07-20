import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:lamis/cubits/cubits.dart';
import 'package:lamis/repos/repos.dart';
import 'package:lamis/res/resources_export.dart';
import 'package:lamis/screens/intro/select_language_screen.dart';
import 'package:lamis/screens/offers/offers_secreen.dart';
import 'package:lamis/widgets/widgets.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rate_my_app/rate_my_app.dart';

import 'blocs/blocs.dart';
import 'main/mains.dart';
import 'screens/screens.dart';
import 'widgets/general/lamis_bottom_navigation_bar.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('Handling a background message ${message.messageId}');
  }
}

void main() async {
  var auto = ThemeDataObject();
  auto.firstTheme = lightTheme;
  auto.secondaryTheme = darkTheme;
  auto.themeMode = ThemeMode.light;
  auto.themeType = ThemeType.light;
  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 1, // Show rate popup on first day of install.
    remindDays: 1,
    remindLaunches: 3,
    minLaunches:
        3, // Show rate popup after 3 launches of app after minDays is passed.
  );
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // For handling the received notifications
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // Parse the message received
    PushNotification notification = PushNotification(
      title: message.notification?.title,
      body: message.notification?.body,
    );
    if (kDebugMode) {
      print("this  is the notification ${notification.body}");
    }
  });

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => CurrentThemeCubit(auto),
    ),
    BlocProvider(create: (context) => UserGuideCubit(true)),
    BlocProvider(create: (context) => RateAppCubit(rateMyApp)),
    BlocProvider(
      create: (context) => LocalizationCubit(const Locale('ar', '')),
    ),
    BlocProvider(create: (context) => CurrentScreenCubit(0)),
  ], child: Phoenix(child: const MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static late BuildContext context;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  // late int _themeNumber;

  bool firstBuild = true;
  bool firstBuildWalk = true;

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  InternetConnectionCubit internetConnectionCubit =
      InternetConnectionCubit(true);

  @override
  void initState() {
    super.initState();
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // RemoteNotification? notification = message.notification;
      // AndroidNotification? android = message.notification?.android;
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('A new onMessageOpenedApp event was published!');
        print('$message');
      }

      // Data data = Data.fromJson(message.data);
      // if (message.notification != null) {
      //   switchCase(data.type, context, message, navigatorKey);
      // }
    });

    //context.read<CurrentThemeCubit>().changeTheme(ThemeType.auto);
    if (!Platform.environment.containsKey('FLUTTER_TEST')) {
      _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) {
          if (result == ConnectivityResult.none) {
            internetConnectionCubit.appOffline();
          } else {
            internetConnectionCubit.appOnline();
          }
        },
      );
    }
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        if (result == ConnectivityResult.none) {
          internetConnectionCubit.appOffline();
        } else {
          internetConnectionCubit.appOnline();
        }
      },
    );
    // var window = WidgetsBinding.instance.window;
    //
    // window.onPlatformBrightnessChanged = () {
    //   if (context.read<CurrentThemeCubit>().state.themeType == ThemeType.auto) {
    //     ThemeDataObject themes = ThemeDataObject();
    //     themes.firstTheme = context.read<CurrentThemeCubit>().firstTheme;
    //     themes.secondaryTheme =
    //         context.read<CurrentThemeCubit>().secondaryTheme;
    //     themes.themeName = context.read<CurrentThemeCubit>().getThemeName();
    //     themes.themeMode = context.read<CurrentThemeCubit>().state.themeMode;
    //     ColorSchemeExtension.theme =
    //         themes.themeName.toString().replaceFirst(RegExp('ThemeName.'), '');
    //     AppImage.theme =
    //         themes.themeName.toString().replaceFirst(RegExp('ThemeName.'), '');
    //   }
    // };
  }

  @override
  Widget build(BuildContext context) {
    context.read<RateAppCubit>().init();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepo>(create: (context) => UserRepo()),
        RepositoryProvider<AppRepo>(create: (context) => AppRepo()),
        RepositoryProvider<InternetConnectionCubit>(
            create: (context) => internetConnectionCubit),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AppBloc(appRepo: context.read<AppRepo>())..add(FetchAppData()),
          ),
          BlocProvider(
            create: (context) =>
                IsLoggedInCubit(false, userRepo: context.read<UserRepo>()),
          ),
          BlocProvider(
            create: (context) => MainPageCartCubit(),
          ),
        ],
        child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              currentFocus.unfocus();
              SystemChannels.textInput.invokeMethod('TextInput.hide');
            },
            child: OverlaySupport(
              child: MaterialApp(
                locale: context.watch<LocalizationCubit>().state,
                debugShowCheckedModeBanner: false,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate
                ],
                supportedLocales: const [
                  Locale('en', ''),
                  Locale('ar', ''),
                ],
                theme: context.watch<CurrentThemeCubit>().state.firstTheme,
                darkTheme:
                    context.watch<CurrentThemeCubit>().state.secondaryTheme,
                themeMode: context.watch<CurrentThemeCubit>().state.themeMode,
                home: Scaffold(
                  drawerScrimColor: Colors.transparent,
                  body:
                      BlocBuilder<AppBloc, AppState>(builder: (context, state) {
                    logWarning(state.toString());
                    MyApp.context = context;
                    if (state is AppOutdated) {
                      return const OutDatedScreen();
                    } else if (state is AppLoading) {
                      return const LoadingScreen();
                    } else if (state is AppDemo) {
                      // return UserGuideScreen(
                      //   index: 0,
                      // );
                      if (firstBuildWalk) {
                        firstBuildWalk = false;
                        context
                            .read<CurrentThemeCubit>()
                            .changeTheme(state.themeType);
                      }
                      return SelectlanguageScreen(
                          countries: state.generalSettings.countries!.data!);
                    } else if (state is ShowLogin) {
                      return LoginScreen(
                        isFirst: true,
                        prevCountry: UserRepo().country,
                      );
                    } else if (state is ShowTutorial) {
                      context.read<AppRepo>().showTutorial = true;
                      //firstBuild = true;
                      context.read<AppBloc>().emit(AppReady(
                          themeType: state.themeType,
                          isLoggedIn: state.isLoggedIn,
                          appLanguage: state.appLanguage,
                          showTutorial: true));

                      // return const MyHomePage(index: 0);

                      return Container();
                    } else if (state is AppReady) {
                      context.read<AppRepo>().showTutorial = state.showTutorial;
                      if (firstBuild) {
                        context
                            .read<CurrentThemeCubit>()
                            .changeTheme(state.themeType);

                        context
                            .read<LocalizationCubit>()
                            .changeLanguage(state.appLanguage);
                        context
                            .read<IsLoggedInCubit>()
                            .changeUserState(isLoggedIn: state.isLoggedIn);
                        if (state.isLoggedIn) {
                          // context.read<UserRepo>().getUserData().then((value) {
                          UserRepo().getUserData();
                          // });
                        }
                        firstBuild = false;
                        //don't delete next line for dark mode theme
                        return Container();
                      }
                      return const MyHomePage(index: 0);
                    }
                    if (state is AppOffline) {
                      return const OfflineScreen();
                    } else {
                      return const OfflineScreen();
                    }
                  }),
                ),
              ),
            )),
      ),
    );
  }

  @override
  void dispose() {
    if (!Platform.environment.containsKey('FLUTTER_TEST')) {
      _connectivitySubscription.cancel();
    }

    super.dispose();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  List<Widget> screens = const [
    HomeScreen(),
    CategoriesScreen(),
    // CartScreen(),
    OffersScreen(),
    ProfileScreen()
  ];
  List<String> screenNames = [];
  // late TutorialCoachMark tutorialCoachMark;
  // List<TargetFocus> targets = <TargetFocus>[];

  GlobalKey keyButton = GlobalKey();

  late AnimationController controller;
  late Animation heightAnimation;

  @override
  void initState() {
    //register notification
    Authentication.registerNotification();

    if (context.read<AppRepo>().showTutorial == true) {
      ///this line for enable disable quick user guild
      // showTutorial();
    }
    var window = WidgetsBinding.instance.window;

    // This callback is called every time the brightness changes.
    window.onPlatformBrightnessChanged = () {
      if (context.read<CurrentThemeCubit>().state.themeType == ThemeType.auto) {
        ThemeDataObject themes = ThemeDataObject();
        themes.firstTheme = context.read<CurrentThemeCubit>().firstTheme;
        themes.secondaryTheme =
            context.read<CurrentThemeCubit>().secondaryTheme;
        themes.themeName = context.read<CurrentThemeCubit>().getThemeName();
        themes.themeMode = context.read<CurrentThemeCubit>().state.themeMode;
        ColorSchemeExtension.theme =
            themes.themeName.toString().replaceFirst(RegExp('ThemeName.'), '');
        AppImage.theme =
            themes.themeName.toString().replaceFirst(RegExp('ThemeName.'), '');
      }
    };
    controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 1, milliseconds: 500));
    heightAnimation = Tween<double>(begin: 0, end: 20.0).animate(controller);
    super.initState();
  }

  late DateTime _lastTimeBackButtonWasTapped;
  bool get _isSnackBarVisible {
    final lastTimeBackButtonWasTapped = _lastTimeBackButtonWasTapped;

    // ignore: unnecessary_null_comparison
    (lastTimeBackButtonWasTapped != null) &&
        (const Duration(seconds: 2) >
            DateTime.now().difference(lastTimeBackButtonWasTapped));

    // ignore: unnecessary_null_comparison
    return (lastTimeBackButtonWasTapped != null) &&
        (const Duration(seconds: 2) >
            DateTime.now().difference(lastTimeBackButtonWasTapped));
  }

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool get _willHandlePopInternally =>
      ModalRoute.of(context)?.willHandlePopInternally ?? true;
  Future<bool> _handleWillPop() async {
    if (context.read<CurrentScreenCubit>().state != 0) {
      setState(() {
        context.read<CurrentScreenCubit>().change(0);
      });
      return false;
    } else if (_isSnackBarVisible || _willHandlePopInternally) {
      return true;
    } else {
      _lastTimeBackButtonWasTapped = DateTime.now();
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.hideCurrentSnackBar();
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          elevation: 4,
          // margin: EdgeInsets.only(
          //   left: Values.medium,
          //   right: Values.medium,
          //   bottom: Values.big,
          // ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          content: CustomText(
            content: "Press again to exit",
            color: Colors.white,
          ),
          backgroundColor: Theme.of(context).colorScheme.darkBlue,
        ),
      );
      return false;
    }
  }

  DateTime preBackpress = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentThemeCubit, ThemeDataObject>(
      bloc: context.read<CurrentThemeCubit>(),
      builder: (context, state) {
        return BlocBuilder(
          bloc: context.read<CurrentScreenCubit>(),
          builder: (context, state) {
            return ScaffoldMessenger(
              key: scaffoldMessengerKey,
              child: Scaffold(
                  key: _key,
                  drawerScrimColor: Colors.transparent,
                  backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
                  // extendBodyBehindAppBar: true,
                  ///this for extend body only on profile tab
                  extendBodyBehindAppBar: state == 3 ? true : false,
                  appBar:
                      const AnimatedAppBar(), // don't add const to this line for theming
                  drawer: const DrawerScreen(),
                  body: Stack(children: [
                    WillPopScope(
                        onWillPop: () async {
                          if (_key.currentState!.isDrawerOpen) {
                            Navigator.pop(context);
                            return false;
                          } else if (context.read<CurrentScreenCubit>().state ==
                              0) {
                            final timegap =
                                DateTime.now().difference(preBackpress);
                            final cantExit =
                                timegap >= const Duration(seconds: 2);
                            preBackpress = DateTime.now();
                            if (cantExit) {
                              scaffoldMessengerKey.currentState?.showSnackBar(
                                SnackBar(
                                  elevation: 4,
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 2),
                                  content: CustomText(
                                    content: "Press again to exit",
                                    color: Colors.white,
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.darkBlue,
                                ),
                              );
                              return false;
                            } else {
                              return true;
                            }
                          } else {
                            context.read<CurrentScreenCubit>().change(0);
                            return false;
                          }
                        },
                        child:
                            screens[context.read<CurrentScreenCubit>().state]),
                    BlocBuilder<InternetConnectionCubit, bool>(
                      bloc: context.read<InternetConnectionCubit>(),
                      builder: (context, state) {
                        if (state) {
                          controller.reverse();
                        } else {
                          controller.forward();
                        }
                        return AnimatedBuilder(
                          animation: controller,
                          builder: (context, widget) {
                            return Align(
                              alignment: Alignment.topCenter,
                              child: AnimatedContainer(
                                duration: const Duration(seconds: 0),
                                height: heightAnimation.value,
                                width: MediaQuery.of(context).size.width,
                                color: state ? Colors.green : Colors.red,
                                child: CustomText(
                                  content: state
                                      ? context.resources.strings
                                          .internetConnectionRestored
                                      : context.resources.strings.noInternet,
                                  color: Colors.white,
                                  language: Language.center,
                                  titletype: TitleType.subtitle,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ]),
                  bottomNavigationBar: LamisButtomBar(
                      key: context.read<UserGuideCubit>().ourBrands,
                      index: context.read<CurrentScreenCubit>().state,
                      onTap: (i) {
                        context.read<CurrentScreenCubit>().change(i);
                      })
                  // BottomBar(
                  //   index: context.read<CurrentScreenCubit>().state,
                  //   changeIndex: (i) {
                  //     context.read<CurrentScreenCubit>().change(i);
                  //   },
                  // ),
                  ),
            );
          },
        );
      },
    );
  }

  // void showTutorial() {
  //   initTargets();
  //
  //   tutorialCoachMark = TutorialCoachMark(
  //     context,
  //     targets: targets,
  //     colorShadow: Colors.red,
  //     textSkip: MyApp.context.resources.strings.skip,
  //     paddingFocus: 10,
  //     opacityShadow: 0.5,
  //     onFinish: () {
  //       if (kDebugMode) {
  //         print("finish");
  //       }
  //       context.read<AppBloc>().add(EndTutorial());
  //     },
  //     onClickTarget: (target) {
  //       if (kDebugMode) {
  //         print('onClickTarget: $target');
  //       }
  //     },
  //     onClickOverlay: (target) {
  //       if (kDebugMode) {
  //         print('onClickOverlay: $target');
  //       }
  //     },
  //     onSkip: () {
  //       if (kDebugMode) {
  //         print("skip");
  //       }
  //       context.read<AppBloc>().add(EndTutorial());
  //     },
  //   )..show();
  // }

  // void initTargets() {
  //   targets.clear();
  //
  //   targets.add(
  //     TargetFocus(
  //       identify: "Target 0",
  //       keyTarget: context.read<UserGuideCubit>().slider,
  //       color: const Color(0xFF000000),
  //       enableOverlayTab: true,
  //       contents: [
  //         TargetContent(
  //           align: ContentAlign.bottom,
  //           builder: (context, controller) {
  //             return Column(
  //               // mainAxisSize: MainAxisSize.min,
  //               // crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 // CustomText(
  //                 //   content: context.resources.strings.news,
  //                 //   color: Colors.black,
  //                 //   titletype: TitleType.headline,
  //                 // ),
  //                 Padding(
  //                     padding: const EdgeInsets.only(top: 160),
  //                     child: Column(
  //                       children: [
  //                         CustomText(
  //                           content:
  //                               MyApp.context.resources.strings.userGuildOne,
  //                           color: Colors.white,
  //                           titletype: TitleType.headline,
  //                         ),
  //                       ],
  //                     )),
  //               ],
  //             );
  //           },
  //         )
  //       ],
  //       //shape: ShapeLightFocus.values,
  //       //radius: 5,
  //     ),
  //   );
  //   targets.add(
  //     TargetFocus(
  //       identify: "Target 1",
  //       keyTarget: context.read<UserGuideCubit>().ourBrands,
  //       color: const Color(0xFf000000),
  //       contents: [
  //         TargetContent(
  //           align: ContentAlign.top,
  //           builder: (context, controller) {
  //             return Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 CustomText(
  //                   content: context.resources.strings.ourBrands,
  //                   titletype: TitleType.headline,
  //                   color: Colors.white,
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 10.0),
  //                   child: CustomText(
  //                     content: MyApp.context.resources.strings.userGuildTow,
  //                     color: Colors.white,
  //                     titletype: TitleType.headline,
  //                   ),
  //                 ),
  //               ],
  //             );
  //           },
  //         )
  //       ],
  //       shape: ShapeLightFocus.RRect,
  //       radius: 5,
  //     ),
  //   );
  //
  //   targets.add(
  //     TargetFocus(
  //       identify: "Target 3",
  //       keyTarget: context.read<UserGuideCubit>().searchButton,
  //       color: const Color(0xFF000000),
  //       contents: [
  //         TargetContent(
  //           align: ContentAlign.bottom,
  //           builder: (context, controller) {
  //             return Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 110.0),
  //                   child: CustomText(
  //                     content: MyApp.context.resources.strings.userGuildThree,
  //                     color: Colors.white,
  //                     titletype: TitleType.headline,
  //                   ),
  //                 ),
  //               ],
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  bool onWillPop() {
    if (context.read<CurrentScreenCubit>().state == 0) {
      return true;
    } else {
      context.read<CurrentScreenCubit>().change(0);
      return false;
    }
  }
}
