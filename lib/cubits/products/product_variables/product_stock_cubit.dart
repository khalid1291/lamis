import 'package:flutter_bloc/flutter_bloc.dart';

class ProductStockCubit extends Cubit<int> {
  ProductStockCubit(int initialState) : super(0);

  void save(int i) => emit(i);
}
