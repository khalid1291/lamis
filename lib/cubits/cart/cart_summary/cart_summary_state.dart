part of 'cart_summary_cubit.dart';

abstract class CartSummaryState {}

class CartSummaryInitial extends CartSummaryState {}

class CartSummaryLoading extends CartSummaryState {}

class CartSummaryDone extends CartSummaryState {
  final CartSummaryResponse response;
  final String? message;

  CartSummaryDone(this.response, {this.message = ""});
}

class CartSummaryError extends CartSummaryState {
  final String message;

  CartSummaryError(this.message);
}
