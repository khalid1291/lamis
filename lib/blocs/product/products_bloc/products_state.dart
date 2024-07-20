part of 'products_bloc.dart';

abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductDetailsDone extends ProductsState {
  final ProductDetailsResponse product;

  ProductDetailsDone(this.product);
}

class CategoryProductsDone extends ProductsState {
  final ProductMiniResponse value;

  CategoryProductsDone(this.value);
}

class ProductsError extends ProductsState {}
