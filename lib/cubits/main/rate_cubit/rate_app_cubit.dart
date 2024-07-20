import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rate_my_app/rate_my_app.dart';

class RateAppCubit extends Cubit<RateMyApp> {
  RateAppCubit(RateMyApp initialState) : super(initialState);

  void init() {
    RateMyApp rateMyApp = RateMyApp(
      preferencesPrefix: 'rateMyApp_',
      minDays: 1, // Show rate popup on first day of install.
      remindDays: 1,
      remindLaunches: 3,
      minLaunches:
          3, // Show rate popup after 3 launches of app after minDays is passed.
    );
    emit(rateMyApp);
  }

  void save(RateMyApp val) => emit(val);
}
