import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/models/models.dart';
import 'package:lamis/repos/cart/cart_repo.dart';
import 'package:lamis/res/app_context_extension.dart';

import '../../../main.dart';

part 'delivery_method_state.dart';

class DeliveryMethodsCubit extends Cubit<DeliveryMethodsState> {
  final _myRepo = CartRepo();
  DeliveryMethodsCubit() : super(DeliveryMethodsInitial());

  Future<void> getDeliveryMethods() async {
    emit(DeliveryMethodsLoading());
    try {
      await _myRepo.getDeliveryMethods().then((value) {
        emit(DeliveryMethodsDone(value!));
      }).onError((error, stackTrace) {
        emit(DeliveryMethodsError(MyApp.context.resources.strings.errorGot));
      });
    } catch (e) {
      emit(DeliveryMethodsError(MyApp.context.resources.strings.errorGot));
    }
  }
}
