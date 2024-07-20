import 'package:flutter_bloc/flutter_bloc.dart';

class CartCheckoutAvailableCubit extends Cubit<bool> {
  CartCheckoutAvailableCubit(bool initialState) : super(initialState);

  void save(bool val) => emit(val);
}
