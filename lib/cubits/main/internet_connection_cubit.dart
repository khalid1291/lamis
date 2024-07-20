import 'package:flutter_bloc/flutter_bloc.dart';

class InternetConnectionCubit extends Cubit<bool> {
  InternetConnectionCubit(bool initialState) : super(initialState);

  void appOffline() {
    emit(false);
  }

  void appOnline() {
    emit(true);
  }
}
