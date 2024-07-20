import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/models.dart';
import '../../../../repos/repos.dart';

part 'wallet_balance_state.dart';

class WalletBalanceCubit extends Cubit<WalletBalanceState> {
  WalletBalanceCubit() : super(WalletBalanceInitial());
  dynamic nextPage;
  UserRepo repo = UserRepo();

  void getWalletData() async {
    emit(WalletBalanceLoading());

    try {
      WalletBalanceResponse response = await repo.getWalletResponse();
      emit(WalletBalanceDone(walletBalanceResponse: response));
    } catch (e) {
      emit(WalletBalanceError());
    }
  }
}
