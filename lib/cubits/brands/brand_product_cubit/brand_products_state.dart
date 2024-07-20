part of 'brand_products_cubit.dart';

@immutable
abstract class BrandProductState {}

class BrandProductInitial extends BrandProductState {}

class BrandProductLoading extends BrandProductState {}

class BrandProductPagination extends BrandProductState {}

class BrandProductDone extends BrandProductState {
  final ProductMiniResponse response;
  BrandProductDone({required this.response});
}

class BrandProductError extends BrandProductState {
  final String message;
  BrandProductError({required this.message});
}
