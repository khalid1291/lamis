part of 'flash_deals_cubit.dart';

abstract class FlashDealsState {}

class FlashDealsInitial extends FlashDealsState {}

class FlashDealsLoading extends FlashDealsState {}

class FlashDealsDone extends FlashDealsState {
  final FlashDealResponse response;

  FlashDealsDone(this.response);
}

class FlashDealsError extends FlashDealsState {
  final String message;

  FlashDealsError(this.message);
}
