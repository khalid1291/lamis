part of 'add_to_wish_list_cubit.dart';

abstract class AddToWishListState {}

class AddToWishListInitial extends AddToWishListState {}

class AddToWishListLoading extends AddToWishListState {}

class AddToWishListDone extends AddToWishListState {
  final WishListChekResponse response;

  AddToWishListDone(this.response);
}

class AddToWishListError extends AddToWishListState {
  final String message;

  AddToWishListError(this.message);
}
