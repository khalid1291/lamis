import 'package:flutter_bloc/flutter_bloc.dart';

class ProductSinglePriceCubit extends Cubit<dynamic> {
  ProductSinglePriceCubit(initialState) : super(initialState);

  void save(dynamic val) => emit(val);
}
