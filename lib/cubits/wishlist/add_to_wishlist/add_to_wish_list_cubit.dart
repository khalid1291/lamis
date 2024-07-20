import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/res/app_context_extension.dart';

import '../../../../repos/repos.dart';
import '../../../../models/models.dart';
import '../../../main.dart';

part 'add_to_wish_list_state.dart';

class AddToWishListCubit extends Cubit<AddToWishListState> {
  final _myRepo = WishListRepo();
  AddToWishListCubit() : super(AddToWishListInitial());

  Future<void> addToWishList(int productId) async {
    emit(AddToWishListLoading());
    try {
      await _myRepo.addtoWishList(productId).then((value) {
        emit(AddToWishListDone(value!));
      }).onError((error, stackTrace) {
        emit(AddToWishListError(MyApp.context.resources.strings.errorGot));
      });
    } catch (error) {
      emit(AddToWishListError(MyApp.context.resources.strings.errorGot));
    }
  }

  Future<void> removeFromWishList(int productId) async {
    emit(AddToWishListLoading());
    try {
      await _myRepo.deleteFromWishList(productId).then((value) {
        emit(AddToWishListDone(value!));
      }).onError((error, stackTrace) {
        emit(AddToWishListError(MyApp.context.resources.strings.errorGot));
      });
    } catch (error) {
      emit(AddToWishListError(MyApp.context.resources.strings.errorGot));
    }
  }
}
