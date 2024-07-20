import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/res/app_context_extension.dart';

import '../../../../repos/repos.dart';
import '../../../main.dart';
part 'cart_data_network_state.dart';

class CartDataNetworkCubit extends Cubit<CartDataNetworkState> {
  final _myRepo = CartRepo();
  CartDataNetworkCubit() : super(CartDataNetworkInitial());

  Future<void> addToCart(
      int itemId, String variant, int? userId, int quantity) async {
    await _myRepo.addToCart(itemId, variant, userId, quantity).then((value) {
      if (value?.result == true) {
        emit(CartDataNetworkGetMessage(value?.message ?? ""));
      } else {
        emit(CartDataNetworkGetMessage(value?.message ?? ""));
      }
    }).onError((error, stackTrace) {
      emit(CartDataNetworkGetMessage(MyApp.context.resources.strings.errorGot));
    });
  }
}
