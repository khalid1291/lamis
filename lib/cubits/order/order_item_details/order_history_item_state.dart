part of 'order_history_item_cubit.dart';

abstract class OrderHistoryItemState {}

class OrderHistoryItemInitial extends OrderHistoryItemState {}

class OrderHistoryItemLoading extends OrderHistoryItemState {}

class OrderHistoryItemDone extends OrderHistoryItemState {
  final OrderItemResponse orderItemResponse;

  OrderHistoryItemDone({required this.orderItemResponse});
}

class OrderHistoryItemError extends OrderHistoryItemState {}
