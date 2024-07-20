import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/models/models.dart';
import 'package:lamis/repos/cart/cart_repo.dart';
import 'package:lamis/res/app_context_extension.dart';

import '../../../../main.dart';

part 'save_delivery_method_state.dart';

class SaveDeliveryMethodsCubit extends Cubit<SaveDeliveryMethodsState> {
  final _myRepo = CartRepo();
  SaveDeliveryMethodsCubit() : super(SaveDeliveryMethodsInitial());

  Future<void> saveDeliveryMethods(int deliveryId, String? date) async {
    emit(SaveDeliveryMethodsLoading());
    try {
      await _myRepo.saveDeliveryMethods(deliveryId, date).then((value) {
        emit(SaveDeliveryMethodsDone(value!));
      }).onError((error, stackTrace) {
        emit(
            SaveDeliveryMethodsError(MyApp.context.resources.strings.errorGot));
      });
    } catch (e) {
      emit(SaveDeliveryMethodsError(MyApp.context.resources.strings.errorGot));
    }
  }
}
