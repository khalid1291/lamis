import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/res/resources_export.dart';

import '../../../main.dart';
import '../../../models/models.dart';
import '../../../repos/repos.dart';

part 'cart_process_state.dart';

class CartProcessCubit extends Cubit<CartProcessState> {
  final _myRepo = CartRepo();
  CartProcessCubit() : super(CartProcessInitial());

  void cartProcess(String cartIds, String cartQuantities) async {
    emit(CartProcessLoading());
    try {
      // emit(CartProcessDone(GeneralResponse(result: true, message: "")));
      await _myRepo.cartProcess(cartIds, cartQuantities).then((value) {
        if (value?.result == true) {
          emit(CartProcessDone(value!));
        } else {
          emit(CartProcessError(value?.message ?? ""));
        }
      }).onError((error, stackTrace) {
        emit(CartProcessError(MyApp.context.resources.strings.errorGot));
      });
    } catch (error) {
      emit(CartProcessError(MyApp.context.resources.strings.errorGot));
    }
  }

  void save(val) {
    emit(val);
  }
}
