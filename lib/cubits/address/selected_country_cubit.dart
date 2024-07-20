import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedCountryCubit extends Cubit<String> {
  SelectedCountryCubit(String initialState, {this.flag = ""})
      : super(initialState);

  String? flag;
  String? arabicName;

  void save(String val) => emit(val);
  void saveFlag(String val) {
    flag = val;
  }
}
