import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/res/app_context_extension.dart';

import '../../../../repos/repos.dart';
import '../../../../models/models.dart';
import '../../../main.dart';

part 'check_if_in_user_wish_list_state.dart';

class CheckIfInUserWishListCubit extends Cubit<CheckIfInUserWishListState> {
  final _myRepo = WishListRepo();

  CheckIfInUserWishListCubit() : super(CheckIfInUserWishListInitial());

  Future<void> checkIfnUserWishlist(int productId) async {
    emit(CheckIfInUserWishListLoading());
    try {
      await _myRepo.checkUserProductWishlist(productId).then((value) {
        emit(CheckIfInUserWishListDone(value!));
      }).onError((error, stackTrace) {
        emit(CheckIfInUserWishListError(
            MyApp.context.resources.strings.errorGot));
      });
    } catch (error) {
      emit(
          CheckIfInUserWishListError(MyApp.context.resources.strings.errorGot));
    }
  }
}
