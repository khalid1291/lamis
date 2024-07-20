part of 'get_user_wish_list_cubit.dart';

abstract class GetUserWishListState {}

class GetUserWishListInitial extends GetUserWishListState {}

class GetUserWishListLoading extends GetUserWishListState {}

class GetUserWishListDone extends GetUserWishListState {
  final WishlistResponse response;

  GetUserWishListDone(this.response);
}

class GetUserWishListError extends GetUserWishListState {
  final String message;

  GetUserWishListError(this.message);
}
