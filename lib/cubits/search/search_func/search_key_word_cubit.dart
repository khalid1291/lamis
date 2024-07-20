import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/repos/repos.dart';
import 'package:lamis/res/app_context_extension.dart';
import '../../../main.dart';
import '../../../models/models.dart';
part 'search_key_word_state.dart';

class SearchKeyWordCubit extends Cubit<SearchKeyWordState> {
  String type = "Product";
  final _myRepo = SearchRepo();
  final _productRepo = ProductRepo();

  SearchKeyWordCubit() : super(SearchKeyWordInitial());

  Future<void> searchCategoryProduct(
      int categoryId, String name, int page) async {
    if (page == 1) {
      emit(SearchKeyWordLoading());
    } else {
      emit(SearchKeyWordPagination());
    }
    try {
      await _productRepo
          .getCategoryProducts(id: categoryId, name: name, page: page)
          .then((value) {
        emit(SearchKeyWordDone(value));
      }).onError((error, stackTrace) {
        emit(SearchKeyWordError(MyApp.context.resources.strings.errorGot));
      });
    } catch (error) {
      emit(SearchKeyWordError(MyApp.context.resources.strings.errorGot));
    }
  }

  Future<void> searchTheKeyWord(String keyWord, int pageNumber,
      {String sortKey = "",
      String brands = "",
      String categories = "",
      String min = "",
      String max = ""}) async {
    if (pageNumber == 1) {
      emit(SearchKeyWordLoading());
    } else {
      emit(SearchKeyWordPagination());
    }
    try {
      await _myRepo
          .searchKeyWord(keyWord, pageNumber,
              sortKey: sortKey,
              brands: brands,
              categories: categories,
              min: min,
              max: max)
          .then((value) {
        emit(SearchKeyWordDone(value));
      }).onError((error, stackTrace) {
        emit(SearchKeyWordError(MyApp.context.resources.strings.errorGot));
      });
    } catch (error) {
      emit(SearchKeyWordError(MyApp.context.resources.strings.errorGot));
    }
  }
}
