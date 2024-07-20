import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/models.dart';
import '../../../repos/repos.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final _myRepo = ProductRepo();
  ProductsBloc() : super(ProductsInitial()) {
    on<ProductsEvent>((event, emit) async {
      if (event is FetchCategoryProducts) {
        emit(ProductsLoading());
        await _myRepo
            .getCategoryProducts(
                id: event.id, name: event.name, page: event.page)
            .then((value) => emit(CategoryProductsDone(value)))
            .onError((error, stackTrace) => emit(ProductsError()));
      }

      if (event is FetchProductDetails) {
        emit(ProductsLoading());
        await _myRepo.getProductDetails(id: event.id).then((value) {
          // print(value.detailedProducts[0].choiceOptions[0].options);
          emit(ProductDetailsDone(value));
        }).onError((error, stackTrace) {
          emit(ProductsError());
        });
      }
      if (event is FetchFlashDealProducts) {
        emit(ProductsLoading());
        await _myRepo
            .getFlashDealProducts(flashId: event.id)
            .then((value) => emit(CategoryProductsDone(value)))
            .onError((error, stackTrace) => emit(ProductsError()));
      }
      if (event is ProductError) {
        emit(ProductsError());
      }
      if (event is FetchBuyAgainProducts) {
        emit(ProductsLoading());
        await _myRepo
            .getBuyAgainProducts(page: event.page)
            .then((value) => emit(CategoryProductsDone(value)))
            .onError((error, stackTrace) => emit(ProductsError()));
      }
    });
  }
}
