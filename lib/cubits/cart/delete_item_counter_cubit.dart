import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteItemCounterCubit extends Cubit<int> {
  DeleteItemCounterCubit(int initialState) : super(initialState);

  void change(int val) => emit(val);
}
