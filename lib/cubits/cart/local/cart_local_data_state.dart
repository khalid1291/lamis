part of 'cart_local_data_cubit.dart';

abstract class CartLocalDataState {}

class CartLocalDataInitial extends CartLocalDataState {}

class CartLocalDataLoading extends CartLocalDataState {}

class CartLocalDataDone extends CartLocalDataState {
  final List<CartItem> items;
  final String? message;

  CartLocalDataDone(this.items, {this.message});
}

class CartLocalDataError extends CartLocalDataState {
  final String message;

  CartLocalDataError(this.message);
}
