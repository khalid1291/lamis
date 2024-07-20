import 'package:flutter_bloc/flutter_bloc.dart';

class ProductVariantCubit extends Cubit<String> {
  ProductVariantCubit(String initialState) : super("");

  void save(String val) => emit(val);
}
