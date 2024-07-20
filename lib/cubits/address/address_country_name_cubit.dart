import 'package:flutter_bloc/flutter_bloc.dart';

class AddressCountryNameCubit extends Cubit<int> {
  AddressCountryNameCubit(int initialState) : super(initialState);

  void save(int val) => emit(val);
}
