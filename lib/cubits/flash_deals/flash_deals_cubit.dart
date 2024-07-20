import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/repos/offers_repo/offers_repo.dart';
import 'package:lamis/res/app_context_extension.dart';

import '../../main.dart';
import '../../models/models.dart';

part 'flash_deals_state.dart';

class FlashDealsCubit extends Cubit<FlashDealsState> {
  OffersRepo offerRepo = OffersRepo();
  FlashDealsCubit() : super(FlashDealsInitial());

  Future<void> getFlashDeals() async {
    emit(FlashDealsLoading());
    try {
      FlashDealResponse response = await offerRepo.getFlashDeals();
      emit(FlashDealsDone(response));
    } catch (e) {
      emit(FlashDealsError(MyApp.context.resources.strings.errorGot));
    }
  }
}
