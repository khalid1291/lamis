import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/main.dart';
import 'package:lamis/res/resources_export.dart';

BuildContext context = MyApp.context;

class SortResultCubit extends Cubit<SortResult> {
  SortResultCubit()
      : super(SortResult(
            name: context.resources.strings.topRated, key: "top_rated"));
  SortResult defaultSort =
      SortResult(name: context.resources.strings.defaultSort, key: "");
  SortResult priceHighToLow = SortResult(
      name: context.resources.strings.priceHighToLow, key: "price_high_to_low");
  SortResult priceLowToHigh = SortResult(
      name: context.resources.strings.priceLowToHigh, key: "price_low_to_high");
  SortResult newArrival = SortResult(
      name: context.resources.strings.newArrival, key: "new_arrival");
  SortResult popularity =
      SortResult(name: context.resources.strings.popularity, key: "popularity");
  SortResult topRated =
      SortResult(name: context.resources.strings.topRated, key: "top_rated");
  List<SortResult> sortResult = [];
  void init() {
    sortResult.clear();
    // sortResult.add(defaultSort);
    sortResult.add(priceLowToHigh);

    sortResult.add(priceHighToLow);
    sortResult.add(topRated);

    sortResult.add(newArrival);
    sortResult.add(popularity);
    emit(priceLowToHigh);
  }

  void save(SortResult val) => emit(val);
}

class SortResult {
  SortResult({required this.name, required this.key});
  String name;
  String key;
}
