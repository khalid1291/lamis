part of 'get_payment_types_cubit.dart';

abstract class GetPaymentTypesState {}

class GetPaymentTypesInitial extends GetPaymentTypesState {}

class GetPaymentTypesLoading extends GetPaymentTypesState {}

class GetPaymentTypesDone extends GetPaymentTypesState {
  final List<PaymentTypeResponse> paymentsTypes;

  GetPaymentTypesDone(this.paymentsTypes);
}

class GetPaymentTypesError extends GetPaymentTypesState {
  final String message;

  GetPaymentTypesError(this.message);
}
