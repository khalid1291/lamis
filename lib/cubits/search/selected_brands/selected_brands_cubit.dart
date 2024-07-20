import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/models/brands/brands_response.dart';

class SelectedBrandsCubit extends Cubit<List<int>> {
  SelectedBrandsCubit() : super([]);

  List<int> selectedBrands = [];
  // void save(int val) => emit(val);
  void add(int val, List<Brands> brands, {bool addAll = false}) {
    if (addAll) {
      state.clear();
      for (var element in brands) {
        state.add(element.id);
        selectedBrands.add(element.id);
        element.selected = true;
      }
      selectedBrands.toSet().toList();
      emit(state.toSet().toList());
    } else {
      state.add(val);
      for (var element in brands) {
        if (element.id == val) {
          element.selected = true;
        }
      }
      emit(state.toList());
    }
  }

  void defaultBrands() {
    state.clear();
    state.addAll(selectedBrands);
    emit(state.toList());
  }

  void remove(int val, List<Brands> brands) {
    int index = state.indexOf(val);
    state.removeAt(index);
    for (var element in brands) {
      if (element.id == val) {
        element.selected = false;
      }
    }

    emit(state.toList());
  }

  // void removeByName(int val, List<Brands> brands) {}

  void removeAll(List<Brands> brands) {
    state.clear();
    for (var element in brands) {
      element.selected = false;
    }
    emit(state.toList());
  }

  bool check(int val) {
    return state.contains(val);
  }
}
