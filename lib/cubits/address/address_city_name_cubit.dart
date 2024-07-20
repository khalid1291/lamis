import 'package:flutter_bloc/flutter_bloc.dart';

class AddressCityNameCubit extends Cubit<int> {
  AddressCityNameCubit(int initialState) : super(initialState);
  void save(int val) => emit(val);
}
