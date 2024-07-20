part of 'check_if_in_user_wish_list_cubit.dart';

abstract class CheckIfInUserWishListState {}

class CheckIfInUserWishListInitial extends CheckIfInUserWishListState {}

class CheckIfInUserWishListLoading extends CheckIfInUserWishListState {}

class CheckIfInUserWishListDone extends CheckIfInUserWishListState {
  final WishListChekResponse response;

  CheckIfInUserWishListDone(this.response);
}

class CheckIfInUserWishListError extends CheckIfInUserWishListState {
  final String message;

  CheckIfInUserWishListError(this.message);
}
