import 'package:flutter_bloc/flutter_bloc.dart';

class AddressStateNameCubit extends Cubit<int> {
  AddressStateNameCubit(int initialState) : super(initialState);
  void save(int val) => emit(val);
}
