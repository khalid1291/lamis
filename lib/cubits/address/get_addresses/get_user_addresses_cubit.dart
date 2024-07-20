import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/res/app_context_extension.dart';

import '../../../main.dart';
import '../../../models/models.dart';
import '../../../repos/repos.dart';

part 'get_user_addresses_state.dart';

class GetUserAddressesCubit extends Cubit<GetUserAddressesState> {
  final _myRepo = AddressRepo();

  GetUserAddressesCubit() : super(GetUserAddressesInitial());

  Future<void> getAddresses() async {
    emit(GetUserAddressesLoading());
    try {
      await _myRepo.getAddresses().then((value) {
        // value?.addresses?.forEach((element) async {
        //   element.phone = await getPhone(element.phone!);
        // });
        emit(GetUserAddressesDone(value!));
      }).onError((error, stackTrace) {
        emit(GetUserAddressesError(MyApp.context.resources.strings.errorGot));
      });
    } catch (error) {
      emit(GetUserAddressesError(error.toString()));
    }
  }

  // Future<String> getPhone(String phone) async {
  //   PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(phone);
  //   String parsableNumber = number.parseNumber();
  //   print(number.phoneNumber);
  //   print(number.isoCode);
  //
  //   // print(parsableNumber);
  //   return parsableNumber;
  // }
}
