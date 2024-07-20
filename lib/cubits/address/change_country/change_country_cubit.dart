import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/main.dart';
import 'package:lamis/models/general/general_response.dart';
import 'package:lamis/res/app_context_extension.dart';

import '../../../repos/address/address_repo.dart';

part 'change_country_state.dart';

class ChangeCountryCubit extends Cubit<ChangeCountryState> {
  final _myRepo = AddressRepo();
  ChangeCountryCubit() : super(ChangeCountryInitial());

  Future<void> changeCountry() async {
    emit(ChangeCountryLoading());
    try {
      await _myRepo.changeCountry().then((value) {
        if (value!.result) {
          emit(ChangeCountryDone(value));
        } else {
          emit(ChangeCountryError(value.message));
        }
      }).onError((error, stackTrace) {
        emit(ChangeCountryError(MyApp.context.resources.strings.errorGot));
      });
    } catch (e) {
      emit(ChangeCountryError(e.toString()));
    }
  }
}
