import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/models.dart';
import '../../../../repos/repos.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial());
  dynamic nextPage;
  UserRepo repo = UserRepo();

  int pageNumber = 1;
  void getOrdersData({
    required int userId,
    int page = 1,
    required String paymentStatus,
    required String deliveryStatus,
  }) async {
    if (page == 1) {
      emit(OrderLoading());
    } else {
      emit(OrderPagination());
    }
    try {
      OrderMiniResponse response = await repo.getOrdersResponse(
          userId: userId,
          page: page,
          paymentStatus: paymentStatus,
          deliveryStatus: deliveryStatus);
      emit(OrderDone(orderMiniResponse: response));
      nextPage = response.links?.next;
    } catch (e) {
      emit(OrderError());
    }
  }
}
