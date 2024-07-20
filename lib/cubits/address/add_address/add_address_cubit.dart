import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/res/app_context_extension.dart';

import '../../../main.dart';
import '../../../repos/repos.dart';
import '../../../models/models.dart';

part 'add_address_state.dart';

class AddAddressCubit extends Cubit<AddAddressState> {
  final _myRepo = AddressRepo();
  AddAddressCubit() : super(AddAddressInitial());

  Future<void> addAddress(
      {String? address,
      int? country,
      int? state,
      int? city,
      String? zipCode,
      String? phoneNumber}) async {
    emit(AddAddressLoading());
    try {
      await _myRepo
          .addAddress(
              country: country,
              city: city,
              zipCode: zipCode,
              phoneNumber: phoneNumber,
              state: state,
              address: address)
          .then((value) {
        if (value?.result == true) {
          emit(AddAddressDone(value!));
        } else {
          emit(AddAddressError(value?.message ?? ""));
        }
      }).onError((error, stackTrace) {
        emit(AddAddressError((MyApp.context.resources.strings.errorGot)));
      });
    } catch (error) {
      emit(AddAddressError(MyApp.context.resources.strings.errorGot));
    }
  }

  Future<void> updateAddress(
      {required int id,
      String? address,
      int? country,
      int? state,
      int? city,
      String? zipCode,
      String? phoneNumber}) async {
    emit(AddAddressLoading());
    try {
      await _myRepo
          .updateAddress(
              id: id,
              countryId: country,
              cityId: city,
              postalCode: zipCode,
              phone: phoneNumber,
              stateId: state,
              address: address)
          .then((value) {
        if (value?.result == true) {
          emit(AddAddressDone(value!));
        } else {
          emit(AddAddressError(value?.message ?? ""));
        }
      }).onError((error, stackTrace) {
        emit(AddAddressError((MyApp.context.resources.strings.errorGot)));
      });
    } catch (error) {
      emit(AddAddressError(MyApp.context.resources.strings.errorGot));
    }
  }

  Future<void> deleteAddress({required int id}) async {
    emit(AddAddressLoading());
    try {
      await _myRepo.deleteAddress(id: id).then((value) {
        if (value?.result == true) {
          emit(AddAddressDone(value!));
        } else {
          emit(AddAddressError(value?.message ?? ""));
        }
      }).onError((error, stackTrace) {
        emit(AddAddressError(MyApp.context.resources.strings.errorGot));
      });
    } catch (error) {
      emit(AddAddressError(MyApp.context.resources.strings.errorGot));
    }
  }
}
