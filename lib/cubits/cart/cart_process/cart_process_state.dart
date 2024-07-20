part of 'cart_process_cubit.dart';

abstract class CartProcessState {}

class CartProcessInitial extends CartProcessState {}

class CartProcessLoading extends CartProcessState {}

class CartProcessDone extends CartProcessState {
  final GeneralResponse response;

  CartProcessDone(this.response);
}

class CartProcessError extends CartProcessState {
  final String message;

  CartProcessError(this.message);
}
