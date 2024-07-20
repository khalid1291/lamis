import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/res/app_context_extension.dart';

import '../../../main.dart';
import '../../../models/wishlist/wishlist_check_response.dart';
import '../../../repos/wishlist/wishlist_repo.dart';

part 'remove_from_wish_list_state.dart';

class RemoveFromWishListCubit extends Cubit<RemoveFromWishListState> {
  final _myRepo = WishListRepo();
  RemoveFromWishListCubit() : super(RemoveFromWishListInitial());

  Future<void> removeFromWishList(int productId) async {
    emit(RemoveFromWishListLoading());
    try {
      await _myRepo.deleteFromWishList(productId).then((value) {
        emit(RemoveFromWishListDone(value!));
      }).onError((error, stackTrace) {
        emit(RemoveFromWishListError(MyApp.context.resources.strings.errorGot));
      });
    } catch (error) {
      emit(RemoveFromWishListError(MyApp.context.resources.strings.errorGot));
    }
  }
}
