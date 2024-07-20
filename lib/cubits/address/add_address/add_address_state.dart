part of 'add_address_cubit.dart';


abstract class AddAddressState {}

class AddAddressInitial extends AddAddressState {}

class AddAddressLoading extends AddAddressState {}

class AddAddressDone extends AddAddressState {
  final GeneralResponse response;

  AddAddressDone(this.response);
}

class AddAddressError extends AddAddressState {
  final String message;

  AddAddressError(this.message);
}
