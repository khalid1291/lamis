import 'package:flutter_bloc/flutter_bloc.dart';

class AddressZipCodeCubit extends Cubit<String> {
  AddressZipCodeCubit(String initialState) : super(initialState);

  void save(String val) => emit(val);
}
