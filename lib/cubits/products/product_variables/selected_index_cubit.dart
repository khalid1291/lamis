import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedIndexCubit extends Cubit<int> {
  SelectedIndexCubit(int initialState) : super(0);

  void save(int i) => emit(i);
}
