part of 'delivery_method_cubit.dart';

abstract class DeliveryMethodsState {}

class DeliveryMethodsInitial extends DeliveryMethodsState {}

class DeliveryMethodsLoading extends DeliveryMethodsState {}

class DeliveryMethodsDone extends DeliveryMethodsState {
  final DeliveryMethodsResponse response;

  DeliveryMethodsDone(this.response);
}

class DeliveryMethodsError extends DeliveryMethodsState {
  final String message;

  DeliveryMethodsError(this.message);
}
