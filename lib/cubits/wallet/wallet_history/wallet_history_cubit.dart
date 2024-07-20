import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/models.dart';
import '../../../../repos/repos.dart';

part 'wallet_history_state.dart';

class WalletHistoryCubit extends Cubit<WalletHistoryState> {
  WalletHistoryCubit() : super(WalletHistoryInitial());
  int pageNumber = 0;
  UserRepo repo = UserRepo();

  void getWalletHistoryData({int pageNumber = 1}) async {
    if (pageNumber == 1) {
      emit(WalletHistoryLoading());
    } else {
      emit(WalletHistoryPagination());
    }

    try {
      WalletHistoryResponse response =
          await repo.getWalletHistoryResponse(pageNumber);

      // ///for test should be deleted
      // List<Recharge> testList = [];
      // for (int i = 0; i < 10; i++) {
      //   testList.add(Recharge(
      //       amount: "300",
      //       paymentMethod: "Paypal",
      //       approvalString: "N/A",
      //       date: "27-03-2022"));
      // }
      // var test =
      //     WalletHistoryResponse(recharges: testList, success: true, status: 0);

      emit(WalletHistoryDone(walletHistoryResponse: response));
    } catch (e) {
      emit(WalletHistoryError());
    }
  }
}
