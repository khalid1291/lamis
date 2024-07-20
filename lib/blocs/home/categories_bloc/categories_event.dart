part of 'categories_bloc.dart';

abstract class CategoriesEvent {}

class FeaturedCategoriesFetch extends CategoriesEvent {
  final int? page;

  FeaturedCategoriesFetch({this.page});
}

class FetchCategories extends CategoriesEvent {
  final int? page;
  final int? id;

  FetchCategories({this.page, this.id});
}

class FetchCategoriesWithAll extends CategoriesEvent {
  final int? page;
  final int? id;

  FetchCategoriesWithAll({this.page, this.id});
}

class FetchSubCategories extends CategoriesEvent {
  final int id;
  FetchSubCategories({required this.id});
}
