part of 'products_bloc.dart';

abstract class ProductsEvent {}

class FetchProductDetails extends ProductsEvent {
  final int id;

  FetchProductDetails(this.id);
}

class FetchCategoryProducts extends ProductsEvent {
  final int id;
  final String? name;
  final int page;

  FetchCategoryProducts({required this.id, this.name, this.page = 0});
}

class FetchFlashDealProducts extends ProductsEvent {
  final int id;

  FetchFlashDealProducts({
    required this.id,
  });
}

class FetchBuyAgainProducts extends ProductsEvent {
  final int page;

  FetchBuyAgainProducts({this.page = 1});
}

class ProductError extends ProductsEvent {}
