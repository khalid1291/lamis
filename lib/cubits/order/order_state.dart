part of 'order_cubit.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderPagination extends OrderState {}

class OrderDone extends OrderState {
  final OrderMiniResponse orderMiniResponse;

  OrderDone({required this.orderMiniResponse});
}

class OrderError extends OrderState {}
