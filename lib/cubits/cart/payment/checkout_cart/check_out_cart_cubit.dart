import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/res/app_context_extension.dart';

import '../../../../main.dart';
import '../../../../repos/repos.dart';
import '../../../../models/models.dart';

part 'check_out_cart_state.dart';

class CheckOutCartCubit extends Cubit<CheckOutCartState> {
  final _myRepo = CartRepo();

  CheckOutCartCubit() : super(CheckOutCartInitial());

  Future<void> checkout(String type, String note) async {
    emit(CheckOutCartLoading());
    await _myRepo.checkoutCart(type, note).then((value) {
      if (value?.result == true) {
        emit(CheckOutCartDone(value!));
      } else {
        emit(CheckOutCartError(value!.message!));
      }
    }).onError((error, stackTrace) {
      emit(CheckOutCartError(MyApp.context.resources.strings.errorGot));
    });
  }

  Future<void> cashOnDelivery(String type, String note) async {
    emit(CheckOutCartLoading());
    await _myRepo.cashOnDelivery(type, note).then((value) {
      if (value?.result == true) {
        emit(CheckOutCartDone(value!));
      } else {
        emit(CheckOutCartError(value!.message!));
      }
    }).onError((error, stackTrace) {
      emit(CheckOutCartError(MyApp.context.resources.strings.errorGot));
    });
  }

  Future<void> walletCash(String type, String note) async {
    emit(CheckOutCartLoading());
    await _myRepo.walletPayment(type, note).then((value) {
      if (value?.result == true) {
        emit(CheckOutCartDone(value!));
      } else {
        emit(CheckOutCartError(value!.message!));
      }
    }).onError((error, stackTrace) {
      emit(CheckOutCartError(MyApp.context.resources.strings.errorGot));
    });
  }
}
