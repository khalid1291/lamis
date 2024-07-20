part of 'post_selected_address_cubit.dart';

abstract class PostSelectedAddressState {}

class PostSelectedAddressInitial extends PostSelectedAddressState {}

class PostSelectedAddressLoading extends PostSelectedAddressState {}

class PostSelectedAddressMessage extends PostSelectedAddressState {
  final GeneralResponse generalResponse;

  PostSelectedAddressMessage(this.generalResponse);
}
