import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../repos/repos.dart';
import '../../../../models/models.dart';

part 'order_history_details_state.dart';

class OrderHistoryDetailsCubit extends Cubit<OrderHistoryDetailsState> {
  OrderHistoryDetailsCubit() : super(OrderHistoryDetailsInitial());

  void getOrdersData({required int orderId}) async {
    UserRepo repo = UserRepo();

    emit(OrderHistoryDetailsLoading());

    try {
      OrderDetailResponse response =
          await repo.getOrderHistoryDetails(orderId: orderId);

      emit(OrderHistoryDetailsDone(orderDetailResponse: response));
    } catch (e) {
      emit(OrderHistoryDetailsError());
    }
  }
}
