import 'package:flutter_bloc/flutter_bloc.dart';

class IsInWishListCubit extends Cubit<bool> {
  IsInWishListCubit(bool initialState) : super(initialState);

  void save(bool val) => emit(val);
}
