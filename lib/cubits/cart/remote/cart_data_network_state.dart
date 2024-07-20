part of 'cart_data_network_cubit.dart';

abstract class CartDataNetworkState {}

class CartDataNetworkInitial extends CartDataNetworkState {}

class CartDataNetworkLoading extends CartDataNetworkState {}

class CartDataNetworkGetMessage extends CartDataNetworkState {
  final String message;

  CartDataNetworkGetMessage(this.message);
}
