part of 'check_out_cart_cubit.dart';

abstract class CheckOutCartState {}

class CheckOutCartInitial extends CheckOutCartState {}

class CheckOutCartLoading extends CheckOutCartState {}

class CheckOutCartDone extends CheckOutCartState {
  final OrderCreateResponse res;

  CheckOutCartDone(this.res);
}

class CheckOutCartError extends CheckOutCartState {
  final String message;

  CheckOutCartError(this.message);
}
