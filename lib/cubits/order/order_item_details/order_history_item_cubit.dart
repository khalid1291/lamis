import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../repos/repos.dart';
import '../../../../models/models.dart';

part 'order_history_item_state.dart';

class OrderHistoryItemCubit extends Cubit<OrderHistoryItemState> {
  OrderHistoryItemCubit() : super(OrderHistoryItemInitial());
  UserRepo repo = UserRepo();

  void getOrdersDataItem({required int orderId}) async {
    emit(OrderHistoryItemLoading());

    try {
      OrderItemResponse response =
          await repo.getOrderHistoryItem(orderId: orderId);
      emit(OrderHistoryItemDone(orderItemResponse: response));
    } catch (e) {
      emit(OrderHistoryItemError());
    }
  }
}
