import 'package:flutter_bloc/flutter_bloc.dart';

class CartDatePickerCubit extends Cubit<String> {
  CartDatePickerCubit(String initialState) : super(initialState);

  void save(String val) => emit(val);
}
