import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/cart/cart_response.dart';
import '../../../repos/cart/cart_repo.dart';

part 'main_page_cart_state.dart';

class MainPageCartCubit extends Cubit<MainPageCartState> {
  final _myRepo = CartRepo();
  MainPageCartCubit() : super(MainPageCartInitial());

  Future<void> fetchRemoteData() async {
    emit(MainPageCartLoading());

    try {
      List val = await _myRepo.fetchCartItems();
      List<CartItem> carts = [];
      int sum = 0;
      for (var element in val) {
        List<CartItem> cart = element.cartItems!;
        for (var h in cart) {
          carts.add(h);
        }
      }
      for (var val in carts) {
        sum += val.quantity!;
      }

      emit(MainPageCartDone(sum));
    } catch (e) {
      emit(MainPageCartError());
    }
  }
}
