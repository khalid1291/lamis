import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/models/models.dart';
import 'package:lamis/repos/repos.dart';
import 'package:lamis/res/app_context_extension.dart';

import '../../../main.dart';

part 'points_state.dart';

class MyPointsCubit extends Cubit<PointsState> {
  MyPointsCubit() : super(PointsInitial());
  UserRepo repo = UserRepo();
  void getMyPoints() async {
    emit(PointsLoading());
    try {
      MyPointsResponse response = await repo.getMyPoints();
      emit(PointsDone(myPointsResponse: response));
    } catch (e) {
      emit(PointsError(
          errorMessage: (MyApp.context.resources.strings.errorGot)));
    }
  }
}
