import 'package:flutter_bloc/flutter_bloc.dart';

class AnimatedAppbarCubit extends Cubit<bool> {
  AnimatedAppbarCubit(bool initialState) : super(initialState);

  void changeState() {
    emit(!state);
  }
}
