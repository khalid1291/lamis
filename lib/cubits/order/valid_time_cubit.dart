import 'package:flutter_bloc/flutter_bloc.dart';

class ValidTimeCubit extends Cubit<bool> {
  ValidTimeCubit(bool initialState) : super(initialState);

  void save(bool val) => emit(val);
}
