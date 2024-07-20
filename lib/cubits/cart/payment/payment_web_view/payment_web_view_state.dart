part of 'payment_web_view_cubit.dart';

abstract class PaymentWebViewState {}

class PaymentWebViewInitial extends PaymentWebViewState {}

class PaymentWebViewLoading extends PaymentWebViewState {}

class PaymentWebViewDone extends PaymentWebViewState {
  final String paymentUrl;
  final String successString;
  final String cancelString;

  PaymentWebViewDone({
    required this.paymentUrl,
    required this.successString,
    required this.cancelString,
  });
}

class PaymentWebViewError extends PaymentWebViewState {}
