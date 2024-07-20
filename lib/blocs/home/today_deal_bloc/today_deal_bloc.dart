import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/models.dart';
import '../../../repos/repos.dart';

part 'today_deal_event.dart';
part 'today_deal_state.dart';

class TodayDealBloc extends Bloc<TodayDealEvent, TodayDealState> {
  TodayDealBloc() : super(TodayDealInitial()) {
    final myRepo = OffersRepo();

    on<TodayDealEvent>((event, emit) async {
      if (event is TodayDealFetch) {
        emit(TodayDealLoading());
        await myRepo
            .getTodayDeal()
            .then((value) => emit(TodayDealDone(value)))
            .onError((error, stackTrace) => emit(TodayDealError()));
      }
      if (event is OffersFetch) {
        emit(TodayDealLoading());
        await myRepo
            .getOffers()
            .then((value) => emit(TodayDealDone(value)))
            .onError((error, stackTrace) => emit(TodayDealError()));
      }
    });
  }
}
