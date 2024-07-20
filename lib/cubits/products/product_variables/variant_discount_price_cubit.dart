import 'package:flutter_bloc/flutter_bloc.dart';

class VariantDiscountPriceCubit extends Cubit<String> {
  VariantDiscountPriceCubit(String initialState) : super(initialState);

  void save(String val) => emit(val);
}
