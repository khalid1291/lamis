import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/models/cart/cart_summary_response.dart';

import 'package:lamis/repos/cart/cart_repo.dart';
import 'package:lamis/res/resources_export.dart';

import '../../../main.dart';

part 'cart_summary_state.dart';

class CartSummaryCubit extends Cubit<CartSummaryState> {
  final _myRepo = CartRepo();
  CartSummaryCubit() : super(CartSummaryInitial());

  Future<void> getCartSummary() async {
    emit(CartSummaryLoading());
    try {
      await _myRepo.getCartSummary().then((value) {
        emit(CartSummaryDone(value!));
      });
    } catch (e) {
      emit(CartSummaryError(MyApp.context.resources.strings.errorGot));
    }
  }

  Future<void> addCoupon(String coupon) async {
    emit(CartSummaryLoading());
    try {
      await _myRepo.applyCoupon(coupon).then((value) async {
        if (value!.result) {
          await _myRepo.getCartSummary().then((val) {
            emit(CartSummaryDone(val!, message: value.message));
          });
        } else {
          await _myRepo.getCartSummary().then((val) {
            emit(CartSummaryDone(val!, message: value.message));
          }).onError((error, stackTrace) {
            emit(CartSummaryError(MyApp.context.resources.strings.errorGot));
          });
        }
      });
    } catch (e) {
      emit(CartSummaryError(MyApp.context.resources.strings.errorGot));
    }
  }

  Future<void> removeCoupon() async {
    emit(CartSummaryLoading());
    try {
      await _myRepo.removeCoupon().then((value) async {
        if (value!.result) {
          await _myRepo.getCartSummary().then((val) {
            emit(CartSummaryDone(val!, message: value.message));
          }).onError((error, stackTrace) {
            emit(CartSummaryError(MyApp.context.resources.strings.errorGot));
          });
        } else {
          await _myRepo.getCartSummary().then((val) {
            emit(CartSummaryDone(val!, message: value.message));
          }).onError((error, stackTrace) {
            emit(CartSummaryError(MyApp.context.resources.strings.errorGot));
          });
        }
      });
    } catch (e) {
      emit(CartSummaryError(MyApp.context.resources.strings.errorGot));
    }
  }
}
