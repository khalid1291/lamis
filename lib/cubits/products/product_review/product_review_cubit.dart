import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/main.dart';
import 'package:lamis/res/app_context_extension.dart';

import '../../../models/models.dart';
import '../../../repos/repos.dart';

part 'product_review_state.dart';

class ProductReviewCubit extends Cubit<ProductReviewState> {
  ProductReviewCubit() : super(ProductReviewInitial());
  ProductRepo repo = ProductRepo();

  //bool isLoading = false;
  int num = 0;

  void submitReview(
      {required String comment,
      required double rating,
      required int productId}) async {
    if (comment == '') {
      emit(ProductReviewError(
          message: MyApp.context.resources.strings.addComment));
      return;
    }
    if (rating == 0.0) {
      emit(ProductReviewError(
          message: MyApp.context.resources.strings.selectStars));
      return;
    }

    emit(ProductReviewLoading());

    try {
      var response = await repo.submitProductsReview(
          comment: comment, rating: rating, productId: productId);
      if (response.result) {
        emit(ProductReviewDone());
      } else {
        emit(ProductReviewError(message: response.message));
      }
    } on Exception {
      emit(ProductReviewError(
          message: (MyApp.context.resources.strings.errorGot)));
    }
  }

  void getReviews({required int productId, int pageNumber = 1}) async {
    if (pageNumber == 1) {
      emit(ProductReviewLoading());
    } else {
      emit(ProductReviewPagination());
    }
    // isLoading = true;
    try {
      var response = await repo.getProductReviews(
          productId: productId, pageNumber: pageNumber);

      // unComment this to view the pagination loading effect
      // List<Review> reviews = [];

      // for (int i = 0; i < 10; i++) {
      //   reviews.add(Review(userName: '${num++}', avatar: ''));
      // }

      // response.reviews = reviews;

      //isLoading = false;
      emit(ProductReviewDone(response: response));
    } on Exception {
      emit(ProductReviewError(
          message: (MyApp.context.resources.strings.errorGot)));
    }
  }
}
