part of 'categories_bloc.dart';

abstract class CategoriesState {}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesDone extends CategoriesState {
  final CategoryResponse value;
  CategoriesDone(this.value);
}

class CategoriesError extends CategoriesState {}
