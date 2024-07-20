import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/res/app_context_extension.dart';

import '../../../../models/models.dart';
import '../../../../repos/repos.dart';
import '../../../main.dart';

part 'get_user_wish_list_state.dart';

class GetUserWishListCubit extends Cubit<GetUserWishListState> {
  final _myRepo = WishListRepo();
  GetUserWishListCubit() : super(GetUserWishListInitial());

  Future<void> getUserWishList() async {
    emit(GetUserWishListLoading());
    try {
      await _myRepo.getUserWishList().then((value) {
        emit(GetUserWishListDone(value!));
      }).onError((error, stackTrace) {
        emit(GetUserWishListError(MyApp.context.resources.strings.errorGot));
      });
    } catch (error) {
      emit(GetUserWishListError(MyApp.context.resources.strings.errorGot));
    }
  }

  Future<void> removeFromWishlist(int productId) async {
    try {
      await _myRepo.deleteFromWishList(productId).then((value) async {
        if (value?.isInWishList == false) {
          await _myRepo.getUserWishList().then((value) {
            emit(GetUserWishListDone(value!));
          }).onError((error, stackTrace) {
            emit(GetUserWishListError(error!.toString()));
          });
        }
      }).onError((error, stackTrace) {
        emit(GetUserWishListError(MyApp.context.resources.strings.errorGot));
      });
    } catch (error) {
      emit(GetUserWishListError(MyApp.context.resources.strings.errorGot));
    }
  }
}
