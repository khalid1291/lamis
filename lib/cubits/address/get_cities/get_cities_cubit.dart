import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/res/app_context_extension.dart';

import '../../../main.dart';
import '../../../repos/repos.dart';
import '../../../models/models.dart';

part 'get_cities_state.dart';

class GetCitiesCubit extends Cubit<GetCitiesState> {
  final _myRepo = AddressRepo();

  GetCitiesCubit() : super(GetCitiesInitial());

  Future<void> getCities(int stateId) async {
    emit(GetCitiesLoading());
    try {
      await _myRepo.citiesList(stateId).then((value) {
        emit(GetCitiesDone(value!));
      }).onError((error, stackTrace) {
        emit(GetCitiesError(MyApp.context.resources.strings.errorGot));
      });
    } catch (e) {
      emit(GetCitiesError(e.toString()));
    }
  }
}
