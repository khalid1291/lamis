import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentScreenCubit extends Cubit<int> {
  CurrentScreenCubit(int initialState) : super(initialState);

  void change(int screen) => emit(screen);
}
