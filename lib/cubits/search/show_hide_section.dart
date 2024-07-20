import 'package:flutter_bloc/flutter_bloc.dart';

class ShowHideSectionCubit extends Cubit<bool> {
  ShowHideSectionCubit(bool initialState) : super(initialState);

  void save(bool val) => emit(val);
}
