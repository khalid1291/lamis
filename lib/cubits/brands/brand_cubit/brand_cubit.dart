import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/res/app_context_extension.dart';

import '../../../../../models/models.dart';
import '../../../../../repos/repos.dart';
import '../../../main.dart';
part 'brand_state.dart';

class BrandsCubit extends Cubit<BrandsState> {
  BrandsCubit() : super(BrandsInitial());
  SearchRepo searchRepo = SearchRepo();
  void getBrands() async {
    emit(BrandsLoading());
    try {
      BrandResponse response = await searchRepo.getBrands();
      emit(BrandsDone(response: response));
    } catch (e) {
      emit(BrandsError(message: MyApp.context.resources.strings.errorGot));
    }
  }
}
