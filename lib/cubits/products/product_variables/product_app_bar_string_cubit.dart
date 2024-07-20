import 'package:flutter_bloc/flutter_bloc.dart';

class ProductAppBarStringCubit extends Cubit<String> {
  ProductAppBarStringCubit(String initialState) : super(". . .");

  void save(String val) => emit(val);
}
