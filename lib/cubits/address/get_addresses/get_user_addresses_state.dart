part of 'get_user_addresses_cubit.dart';

abstract class GetUserAddressesState {}

class GetUserAddressesInitial extends GetUserAddressesState {}

class GetUserAddressesLoading extends GetUserAddressesState {}

class GetUserAddressesDone extends GetUserAddressesState {
  final AddressResponse addressResponse;

  GetUserAddressesDone(this.addressResponse);
}

class GetUserAddressesError extends GetUserAddressesState {
  final String message;

  GetUserAddressesError(this.message);
}
