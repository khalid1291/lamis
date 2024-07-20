import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/res/resources_export.dart';

import '../../../main.dart';
import '../../../repos/repos.dart';
import '../../../models/models.dart';

part 'get_states_state.dart';

class GetStatesCubit extends Cubit<GetStatesState> {
  final _myRepo = AddressRepo();
  GetStatesCubit() : super(GetStatesInitial());

  Future<void> getStates(int countryId) async {
    emit(GetStatesLoading());
    try {
      await _myRepo.statesList(countryId).then((value) {
        emit(GetStatesDone(value!));
      }).onError((error, stackTrace) {
        emit(GetStatesError(MyApp.context.resources.strings.errorGot));
      });
    } catch (e) {
      emit(GetStatesError(e.toString()));
    }
  }
}
