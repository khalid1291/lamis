import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedPaymentMethodCubit extends Cubit<String> {
  SelectedPaymentMethodCubit(String initialState) : super(initialState);

  void save(String val) => emit(val);
}
