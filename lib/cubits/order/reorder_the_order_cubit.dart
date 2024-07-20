import 'package:flutter_bloc/flutter_bloc.dart';

class ReorderTheOrderCubit extends Cubit<bool> {
  ReorderTheOrderCubit(bool initialState) : super(initialState);

  void save(bool val) => emit(val);
}
