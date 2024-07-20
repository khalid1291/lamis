part of 'product_review_cubit.dart';

abstract class ProductReviewState {}

class ProductReviewInitial extends ProductReviewState {}

class ProductReviewLoading extends ProductReviewState {}

class ProductReviewDone extends ProductReviewState {
  final ReviewResponse? response;

  ProductReviewDone({this.response});
}

class ProductReviewPagination extends ProductReviewState {}

class ProductReviewError extends ProductReviewState {
  final String message;

  ProductReviewError({required this.message});
}
