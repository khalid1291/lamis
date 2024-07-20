part of 'order_history_details_cubit.dart';

abstract class OrderHistoryDetailsState {}

class OrderHistoryDetailsInitial extends OrderHistoryDetailsState {}

class OrderHistoryDetailsLoading extends OrderHistoryDetailsState {}

class OrderHistoryDetailsDone extends OrderHistoryDetailsState {
  final OrderDetailResponse orderDetailResponse;

  OrderHistoryDetailsDone({required this.orderDetailResponse});
}

class OrderHistoryDetailsError extends OrderHistoryDetailsState {}
