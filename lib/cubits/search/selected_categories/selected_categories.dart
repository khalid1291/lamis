import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/models/categories/category_response.dart';

class SelectedCategoriesCubit extends Cubit<int> {
  SelectedCategoriesCubit(int initialState) : super(initialState);

  // List<int> selectedBrands = [];
  void save(int val) => emit(val);
  void setIndex(List<Category> val) {
    for (var element in val) {
      if (element.selected) {
        emit(element.id);
        break;
      }
    }
  }

  void updateList(List<Category> val, int id) {
    for (var element in val) {
      element.selected = false;
    }
    for (var element in val) {
      if (element.id == id) {
        element.selected = true;
        emit(element.id);
        break;
      }
    }
  }
}
