import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/res/resources_export.dart';

import '../../../main.dart';
import '../../../models/models.dart';
import '../../../repos/repos.dart';

part 'get_countries_state.dart';

class GetCountriesCubit extends Cubit<GetCountriesState> {
  List<String> countries = [];
  final _myRepo = AddressRepo();
  GetCountriesCubit() : super(GetCountriesInitial());

  Future<void> getCountries() async {
    emit(GetCountriesLoading());
    try {
      await _myRepo.countriesList().then((value) {
        value?.countries?.forEach((element) {
          countries.add(element.code ?? "");
        });
        emit(GetCountriesDone(value!));
      }).onError((error, stackTrace) {
        emit(GetCountriesError(MyApp.context.resources.strings.errorGot));
      });
    } catch (e) {
      emit(GetCountriesError(e.toString()));
    }
  }
}
