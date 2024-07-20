import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedAddressCubit extends Cubit<int> {
  SelectedAddressCubit(int initialState) : super(initialState);

  void save(int val) => emit(val);
}
