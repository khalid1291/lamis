part of 'remove_from_wish_list_cubit.dart';

abstract class RemoveFromWishListState {}

class RemoveFromWishListInitial extends RemoveFromWishListState {}

class RemoveFromWishListLoading extends RemoveFromWishListState {}

class RemoveFromWishListDone extends RemoveFromWishListState {
  final WishListChekResponse response;

  RemoveFromWishListDone(this.response);
}

class RemoveFromWishListError extends RemoveFromWishListState {
  final String message;

  RemoveFromWishListError(this.message);
}
