part of 'brand_cubit.dart';

@immutable
abstract class BrandsState {}

class BrandsInitial extends BrandsState {}

class BrandsLoading extends BrandsState {}

class BrandsPagination extends BrandsState {}

class BrandsDone extends BrandsState {
  final BrandResponse response;
  BrandsDone({required this.response});
}

class BrandsError extends BrandsState {
  final String message;
  BrandsError({required this.message});
}
