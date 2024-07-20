import 'package:flutter_bloc/flutter_bloc.dart';

class ProductSinglePriceStringCubit extends Cubit<String> {
  ProductSinglePriceStringCubit(String initialState) : super("");

  void save(String val) => emit(val);
}
