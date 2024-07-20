part of 'save_delivery_method_cubit.dart';

abstract class SaveDeliveryMethodsState {}

class SaveDeliveryMethodsInitial extends SaveDeliveryMethodsState {}

class SaveDeliveryMethodsLoading extends SaveDeliveryMethodsState {}

class SaveDeliveryMethodsDone extends SaveDeliveryMethodsState {
  final GeneralResponse response;

  SaveDeliveryMethodsDone(this.response);
}

class SaveDeliveryMethodsError extends SaveDeliveryMethodsState {
  final String message;

  SaveDeliveryMethodsError(this.message);
}
