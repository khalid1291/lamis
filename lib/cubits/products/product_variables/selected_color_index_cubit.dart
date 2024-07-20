import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedColorIndexCubit extends Cubit<int> {
  SelectedColorIndexCubit(int initialState) : super(0);

  void save(int i) => emit(i);
}
