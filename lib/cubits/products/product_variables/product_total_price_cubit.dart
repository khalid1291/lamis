import 'package:flutter_bloc/flutter_bloc.dart';

class ProductTotalPriceCubit extends Cubit<dynamic> {
  ProductTotalPriceCubit(initialState) : super(initialState);

  void save(dynamic val) => emit(val);
}
