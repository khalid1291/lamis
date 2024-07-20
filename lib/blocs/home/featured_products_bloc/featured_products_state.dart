part of 'featured_products_bloc.dart';

abstract class FeaturedProductsState {}

class FeaturedProductsInitial extends FeaturedProductsState {}

class FeaturedProductsLoading extends FeaturedProductsState {}

class FeaturedProductsDone extends FeaturedProductsState {
  final ProductMiniResponse value;
  FeaturedProductsDone(this.value);
}

class FeaturedProductsError extends FeaturedProductsState {}
