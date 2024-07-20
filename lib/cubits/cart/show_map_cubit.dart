import 'package:flutter_bloc/flutter_bloc.dart';

class ShowMapCubit extends Cubit<bool> {
  int id;
  ShowMapCubit(bool initialState, this.id) : super(initialState);

  void save(bool val, int id) {
    this.id = id;
    emit(val);
  }
}
