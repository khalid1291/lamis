// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:lamis/cubits/cubits.dart';
import 'package:lamis/data/remote/network/network_api_service.dart';
import 'package:lamis/main.dart';
import 'package:lamis/repos/repos.dart';
import 'package:lamis/res/theme/static_theme.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockConnectivity extends Mock implements Connectivity {}

// class MockClient extends Mock implements http.Client {}

void main() {
  Client clients = Client();
  NetworkApiService.client = clients;

  testWidgets('test home screen', (WidgetTester tester) async {
    await tester.runAsync(() async {
      SharedPreferences.setMockInitialValues({
        AppRepo.themeKey: 1,
        AppRepo.isFirstOpenKey: false,
        AppRepo.isTutorialShow: false
      });

      var auto = ThemeDataObject();
      auto.firstTheme = lightTheme;
      auto.secondaryTheme = darkTheme;
      auto.themeMode = ThemeMode.system;
      auto.themeType = ThemeType.light;
      await Future.delayed(const Duration(seconds: 5), () async {
        await tester.pumpWidget(MultiBlocProvider(providers: [
          BlocProvider(
            create: (context) => CurrentThemeCubit(auto),
          ),
          BlocProvider(create: (context) => UserGuideCubit(true)),
          BlocProvider(
            create: (context) => LocalizationCubit(const Locale('en', '')),
          ),
          BlocProvider(create: (context) => CurrentScreenCubit(0)),
        ], child: const MyApp()));

        await tester.pump();
        expect(find.text("Loading please wait ..."), findsOneWidget);

        await Future.delayed(const Duration(seconds: 5), () async {
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 300));
          // expect(find.byWidget(widget), matcher)
          debugDumpApp();
        });
//               await tester.pump();
//               expect(find.text("عربي"), findsOneWidget);
//               expect(find.text("English"), findsOneWidget);
//               SharedPreferences.setMockInitialValues(
//                   {AppRepo.themeKey: 1, AppRepo.isFirstOpenKey: false});
//             });
//             await Future.delayed(const Duration(seconds: 5), () async {
//               await tester.pump();
//               expect(find.text("عربي"), findsOneWidget);
//               expect(find.text("English"), findsOneWidget);
//               await tester.tap(find.byKey(const Key("Select_country")));
//               await tester.pump(const Duration(milliseconds: 300));
//               final Finder buttonToTap = find.text("🇯🇴").first;
//
//               await tester.dragUntilVisible(
//                 buttonToTap,
//                 find.byType(ListView),
//                 const Offset(0, 100),
//               );
//               for (int i = 0; i < 5; i++) {
//                 await tester.pump(const Duration(seconds: 1));
//               }
//               await tester.tap(buttonToTap);
//
//               await tester.pump();
//               for (int i = 0; i < 5; i++) {
//                 await tester.pump(const Duration(seconds: 1));
//               }
//               await tester.tap(find.byKey(const Key("عربي")));
//               await tester.pump(const Duration(milliseconds: 300));
//               await tester.pump();
//               expect(find.byType(WalkThroughScreen), findsOneWidget);
//
// //          debugDumpApp();
//             });
      });
    });
  });
}
