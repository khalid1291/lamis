import 'package:flutter_bloc/flutter_bloc.dart';

class AddressPhoneNumberCubit extends Cubit<String> {
  AddressPhoneNumberCubit(String initialState) : super(initialState);
  void save(String val) => emit(val);
}
