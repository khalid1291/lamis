import 'package:flutter_bloc/flutter_bloc.dart';

class ExpandedCartCardCubit extends Cubit<bool> {
  ExpandedCartCardCubit(bool initialState) : super(initialState);

  void save(bool val) => emit(val);
}
