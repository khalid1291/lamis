import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/main.dart';
import 'package:lamis/res/resources_export.dart';

import '../../../models/brands/brands_response.dart';

class SearchFiltersCubit extends Cubit<List<Filter>> {
  SearchFiltersCubit() : super([]);
  Filter allCategories =
      Filter(name: MyApp.context.resources.strings.allCategories, key: -1);
  Filter allBrands =
      Filter(name: MyApp.context.resources.strings.allBrands, key: -2);
  Filter priceLowToHigh =
      Filter(name: MyApp.context.resources.strings.priceLowToHigh, key: -3);

  void init() {
    state.clear();
    state.add(allCategories);
    state.add(allBrands);
    state.add(priceLowToHigh);
  }

  void remove(category) {
    if (category.key == 0) {
      state.removeWhere((element) => element.key == 0);
      state.insert(2, priceLowToHigh);
      // state.add(priceLowToHigh);
    }
    if (category.key == 1) {
      state.removeWhere((element) => element.key == 1);
      state.insert(0, allCategories);
      // state.add(allCategories);
    }
    if (category.key == 2) {
      state.removeWhere((element) => element.name == category.name);
      var count = state.where((element) => element.key == 2);
      if (count.isEmpty) {
        //state.add(allBrands);
        state.insert(1, allBrands);
      }
    }
    if (category.key == 4) {
      state.removeWhere((element) => element.key == 4);
    }
    emit(state.toSet().toList());
  }

  void addSort(Filter val, bool addDefaultSort) {
    //check if we have filter and remove it before add new
    state.removeWhere((element) => element.key == -3);
    state.removeWhere((item) => item.key == 0);
    var count = state.where((element) => element.key == 2);

    if (addDefaultSort) {
      // state.add(priceLowToHigh);
      if (count.length == 1) {
        state.insert(2, priceLowToHigh);
      } else {
        state.add(priceLowToHigh);
      }
    } else {
      if (count.length == 1) {
        state.insert(2, val);
      } else {
        state.add(val);
      }

      // state.add(val);
    }
    emit(state.toList());
  }

  void addBrands(List<int> val, List<Brands> brands) {
    //check if we have filter and remove it before add new
    state.removeWhere((item) => item.key == 2);
    state.removeWhere((item) => item.key == -2);

    if (val.isEmpty) {
      state.add(allBrands);
    } else {
      for (var id in val) {
        state.add(Filter(
            name: brands.where((element) => element.id == id).first.name,
            key: 2,
            isDeletable: true,
            id: id));
      }
      // var count = state.where((element) => element.key == 2);
      // if (brands.length == count.length) {
      //   state.removeWhere((element) => element.key == 2);
      //   state.add(allBrands);
      // } else {
      //   state.removeWhere((item) => item.key == -2);
      //
      //   //state.add(val);
      //   state.toSet().toList();
      // }
      //state.removeWhere((element) => element.key == 2);
      // state.add(allBrands);

      emit(state.toSet().toList());
    }
  }

  void addPrice(String min, String max) {
    state.removeWhere((element) => element.key == 4);

    if (min == "") {
      state.add(Filter(
          name: "${MyApp.context.resources.strings.maximum}:$max",
          key: 4,
          isDeletable: true));
    } else if (max == "") {
      state.add(Filter(
          name: "${MyApp.context.resources.strings.minimum}:$min",
          key: 4,
          isDeletable: true));
    } else {
      state.add(Filter(name: "$min-->$max", key: 4, isDeletable: true));
    }
    emit(state.toList());
  }

  void addCategory(Filter val, bool addAllCategory) {
    //check if we have filter and remove it before add new
    state.removeWhere((item) => item.key == 1);
    if (addAllCategory) {
      state.insert(0, allCategories);
    } else {
      state.removeWhere((item) => item.key == -1);
      state.insert(0, val);

      // state.add(val);
    }
    emit(state.toList());
  }
}

class Filter {
  Filter(
      {required this.name,
      required this.key,
      this.isDeletable = false,
      this.id = -1});
  String name;
  int key;
  bool isDeletable;
  int id;
}
