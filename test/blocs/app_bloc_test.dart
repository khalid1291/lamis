

import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:lamis/blocs/blocs.dart';

import 'package:lamis/repos/app/app_repo.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

// Mock Cubit
class MockAppCubit extends MockCubit<AppState> implements AppBloc {}

// Mock Bloc
class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockConnectivity extends Mock implements Connectivity {}

void main() async {
  //mainCubit();
  // late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  // InternetConnectionCubit internetConnectionCubit =
  //     InternetConnectionCubit(true);

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  mainBloc();
}

// void mainCubit() {
//   group('whenListen', () {
//     test("Let's mock the CounterCubit's stream!", () {
//       // Create Mock CounterCubit Instance
//       final cubit = MockAppCubit();
//
//       // Stub the listen with a fake Stream
//       whenListen(cubit, Stream.fromIterable([0, 1, 2, 3]));
//
//       // Expect that the CounterCubit instance emitted the stubbed Stream of
//       // states
//       expectLater(cubit.stream, emitsInOrder(<int>[0, 1, 2, 3]));
//     });
//   });
//
//   group('CounterCubit', () {
//     blocTest<CounterCubit, int>(
//       'emits [] when nothing is called',
//       build: () => CounterCubit(),
//       expect: () => const <int>[],
//     );
//
//     blocTest<CounterCubit, int>(
//       'emits [1] when increment is called',
//       build: () => CounterCubit(),
//       act: (cubit) => cubit.increment(),
//       expect: () => const <int>[1],
//     );
//   });
// }

void mainBloc() {
  group('AppBloc', () {
    blocTest<AppBloc, AppState>(
      'emits [] when nothing is added',
      build: () => AppBloc(appRepo: AppRepo()),
      expect: () => const <AppState>[],
    );

    blocTest<AppBloc, AppState>(
      'emits [AppLoading] when FetchAppData is added',
      build: () => AppBloc(appRepo: AppRepo()),
      act: (bloc) => bloc.add(FetchAppData()),
      expect: () => [isA<AppLoading>()],
    );
    blocTest<AppBloc, AppState>(
      'emits [AppLoading,AppDemo] when FetchAppData is added with 6 seconds for the first time',
      build: () => AppBloc(appRepo: AppRepo()),
      act: (bloc) {
        bloc.add(FetchAppData());
      },
      wait: const Duration(seconds: 6),
      expect: () => [isA<AppLoading>(), isA<AppDemo>()],
    );
    blocTest<AppBloc, AppState>(
      'emits [AppLoading,ShowTutorial] when FetchAppData is added with 6 seconds',
      build: () => AppBloc(appRepo: AppRepo()),
      act: (bloc) {
        SharedPreferences.setMockInitialValues({
          AppRepo.isFirstOpenKey: false,
        });
        bloc.add(FetchAppData());
      },
      wait: const Duration(seconds: 6),
      expect: () => [isA<AppLoading>(), isA<ShowTutorial>()],
    );
    blocTest<AppBloc, AppState>(
      'emits [AppLoading,AppReady] when FetchAppData is added with 6 seconds',
      build: () => AppBloc(appRepo: AppRepo()),
      act: (bloc) {
        SharedPreferences.setMockInitialValues(
            {AppRepo.isFirstOpenKey: false, AppRepo.isTutorialShow: false});
        bloc.add(FetchAppData());
      },
      wait: const Duration(seconds: 6),
      expect: () => [isA<AppLoading>(), isA<AppReady>()],
    );
  });
  // group('AppDemo', () {
  //   blocTest<AppBloc, AppState>(
  //     'emits App Demo',
  //     build: () => AppBloc(appRepo: AppRepo()),
  //     expect: () => const <AppState>[],
  //   );
  //
  //   blocTest<AppBloc, AppState>(
  //     'emits [1] when CounterIncrementPressed is added',
  //     build: () => AppBloc(appRepo: AppRepo()),
  //     act: (bloc) {
  //       bloc.add(FetchAppData());
  //     },
  //     wait: const Duration(seconds: 6),
  //     expect: () => [isA<AppLoading>(), isA<AppDemo>()],
  //   );
  // });
}

// class CounterCubit extends Cubit<int> {
//   CounterCubit() : super(0);
//
//   void increment() => emit(state + 1);
// }
//
// abstract class CounterEvent {}
//
// class CounterIncrementPressed extends CounterEvent {}
//
// class CounterBloc extends Bloc<CounterEvent, int> {
//   CounterBloc() : super(0) {
//     on<CounterIncrementPressed>((event, emit) => emit(state + 1));
//   }
// }
