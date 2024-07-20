part of 'product_variant_bloc.dart';

abstract class ProductVariantState {}

class ProductVariantInitial extends ProductVariantState {}

class ProductVariantLoading extends ProductVariantState {}

class ProductVariantDone extends ProductVariantState {
  final VariantResponse response;

  ProductVariantDone(this.response);
}

class ProductVariantError extends ProductVariantState {}
