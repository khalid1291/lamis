part of 'search_key_word_cubit.dart';

@immutable
abstract class SearchKeyWordState {}

class SearchKeyWordInitial extends SearchKeyWordState {}

class SearchKeyWordLoading extends SearchKeyWordState {}

class SearchKeyWordDone extends SearchKeyWordState {
  final ProductMiniResponse response;

  SearchKeyWordDone(this.response);
}
class SearchKeyWordPagination extends SearchKeyWordState {}

class SearchBrandsDone extends SearchKeyWordState {
  final BrandResponse response;

  SearchBrandsDone(this.response);
}

class SearchSellersDone extends SearchKeyWordState {
  final ShopResponse response;

  SearchSellersDone(this.response);
}

class SearchKeyWordError extends SearchKeyWordState {
  final String message;

  SearchKeyWordError(this.message);
}
