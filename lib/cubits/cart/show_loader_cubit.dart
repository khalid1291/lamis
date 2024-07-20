import 'package:flutter_bloc/flutter_bloc.dart';

class ShowLoaderCubit extends Cubit<bool> {
  ShowLoaderCubit(bool initialState) : super(initialState);

  void save(bool val) => emit(val);
}
