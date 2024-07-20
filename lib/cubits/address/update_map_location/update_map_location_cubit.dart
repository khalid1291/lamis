import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/models/general/general_response.dart';
import 'package:lamis/repos/address/address_repo.dart';
import 'package:lamis/res/resources_export.dart';

import '../../../main.dart';

part 'update_map_location_state.dart';

class UpdateMapLocationCubit extends Cubit<UpdateMapLocationState> {
  final _myRepo = AddressRepo();
  UpdateMapLocationCubit() : super(UpdateMapLocationInitial());

  Future<void> updateMapAddress(int id, double lan, double lat) async {
    emit(UpdateMapLocationLoading());
    try {
      await _myRepo.updateMapAddress(id: id, lan: lan, lat: lat).then((value) {
        if (value!.result) {
          emit(UpdateMapLocationDone(value));
        } else {
          emit(UpdateMapLocationError(value.message));
        }
      }).onError((error, stackTrace) {
        emit(
            UpdateMapLocationError((MyApp.context.resources.strings.errorGot)));
      });
    } catch (e) {
      emit(UpdateMapLocationError(e.toString()));
    }
  }
}
