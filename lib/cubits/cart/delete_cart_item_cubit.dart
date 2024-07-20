import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteCartItemCubit extends Cubit<bool> {
  DeleteCartItemCubit(bool initialState) : super(initialState);

  void save(bool val) => emit(val);
}
