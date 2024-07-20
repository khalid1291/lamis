import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/main.dart';
import 'package:lamis/models/categories/category_response.dart';
import 'package:lamis/repos/categories/categories_repo.dart';
import 'package:lamis/res/resources_export.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final _myRepo = CategoriesRepo();

  CategoriesBloc() : super(CategoriesInitial()) {
    on<CategoriesEvent>((event, emit) async {
      if (event is FeaturedCategoriesFetch) {
        emit(CategoriesLoading());
        await _myRepo
            .getFeaturedCategories()
            .then((value) => emit(CategoriesDone(value)))
            .onError((error, stackTrace) => emit(CategoriesError()));
      }
      if (event is FetchCategories) {
        emit(CategoriesLoading());
        await _myRepo
            .getCategories(parentId: event.id)
            .then((value) => emit(CategoriesDone(value)))
            .onError((error, stackTrace) => emit(CategoriesError()));
      }
      if (event is FetchCategoriesWithAll) {
        emit(CategoriesLoading());
        await _myRepo.getCategories(parentId: event.id).then((value) {
          //add "All" category to get all products in search page
          Category all = Category(
              id: 0,
              name: MyApp.context.resources.strings.all,
              banner: "",
              icon: "",
              numberOfChildren: 0);
          all.selected = true;
          value.categories.insert(0, all);
          emit(CategoriesDone(value));
        }).onError((error, stackTrace) {
          emit(CategoriesError());
        });
      }
      if (event is FetchSubCategories) {
        emit(CategoriesLoading());
        await _myRepo
            .getSubCategories(id: event.id)
            .then((value) => emit(CategoriesDone(value)))
            .onError((error, stackTrace) => emit(CategoriesError()));
      }
    });
  }
}
