import 'package:flutter_bloc/flutter_bloc.dart';

class AddressAddressNameCubit extends Cubit<String> {
  AddressAddressNameCubit(String initialState) : super(initialState);
  void save(String val) => emit(val);
}
