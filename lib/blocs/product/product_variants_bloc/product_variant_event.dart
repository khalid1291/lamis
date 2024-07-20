part of 'product_variant_bloc.dart';

abstract class ProductVariantEvent {}

class FetchProductVariants extends ProductVariantEvent {
  final int id;
  final String color;
  final String variant;

  FetchProductVariants(this.id, this.color, this.variant);
}
