import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/res/app_context_extension.dart';

import '../../../main.dart';
import '../../../repos/repos.dart';
import '../../../models/models.dart';

part 'post_selected_address_state.dart';

class PostSelectedAddresCubit extends Cubit<PostSelectedAddressState> {
  final _myRepo = AddressRepo();
  PostSelectedAddresCubit() : super(PostSelectedAddressInitial());

  Future<void> addAddress(int addressId) async {
    emit(PostSelectedAddressLoading());
    try {
      await _myRepo.postSelectAddress(addressId).then((value) {
        emit(PostSelectedAddressMessage(value!));
      }).onError((error, stackTrace) {
        emit(PostSelectedAddressMessage(GeneralResponse(
            result: false,
            message: (MyApp.context.resources.strings.errorGot))));
      });
    } catch (e) {
      emit(PostSelectedAddressMessage(
          GeneralResponse(result: false, message: e.toString())));
    }
  }
}
