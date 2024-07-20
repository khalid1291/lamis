import 'package:flutter_bloc/flutter_bloc.dart';

class CartTotalPriceCubit extends Cubit<double> {
  CartTotalPriceCubit(double initialState) : super(initialState);

  void save(double val) => emit(val);
}
