part of 'featured_products_bloc.dart';

abstract class FeaturedProductsEvent {}

class FeaturedProductsFetch extends FeaturedProductsEvent {
  final int? page;

  FeaturedProductsFetch({this.page});
}
