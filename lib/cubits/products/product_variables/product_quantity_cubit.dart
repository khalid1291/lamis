import 'package:flutter_bloc/flutter_bloc.dart';

class ProductQuantityCubit extends Cubit<int> {
  ProductQuantityCubit(int initialState) : super(1);

  void save(int i) => emit(i);
}
