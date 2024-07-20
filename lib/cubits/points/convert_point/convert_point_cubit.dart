import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/models/general/general_response.dart';
import 'package:lamis/res/app_context_extension.dart';

import '../../../main.dart';
import '../../../repos/repos.dart';

part 'convert_point_state.dart';

class ConvertPointCubit extends Cubit<ConvertPointState> {
  ConvertPointCubit() : super(ConvertPointInitial());
  UserRepo repo = UserRepo();

  void convertPoint(int id) async {
    emit(ConvertPointLoading());

    try {
      GeneralResponse response = await repo.convertPoints(id: id);
      emit(ConvertPointDone(response: response));
    } catch (e) {
      emit(ConvertPointError(
          errorMessage: (MyApp.context.resources.strings.errorGot)));
    }
  }

  void convertAll() async {
    emit(ConvertPointLoading());
    try {
      GeneralResponse response = await repo.convertAllPoints();
      emit(ConvertPointDone(response: response));
    } catch (e) {
      emit(ConvertPointError(
          errorMessage: (MyApp.context.resources.strings.errorGot)));
    }
  }
}
