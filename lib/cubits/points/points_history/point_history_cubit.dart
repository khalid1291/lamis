import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/repos/repos.dart';
import 'package:lamis/res/app_context_extension.dart';

import '../../../main.dart';
import '../../../models/models.dart';

part 'point_history_state.dart';

class PointHistoryCubit extends Cubit<PointHistoryState> {
  PointHistoryCubit() : super(PointHistoryInitial());
  final List<ClubPoint> pointHistoryList = [];

  void getPointHistory({int pageNumber = 1}) async {
    UserRepo repo = UserRepo();

    if (pageNumber == 1) {
      emit(PointHistoryLoading());
    } else {
      emit(PointHistoryPagination());
    }

    try {
      ClubPointResponse response = await repo.getClubPointsHistory(pageNumber);
      pointHistoryList.addAll(response.clubPoints);
      emit(PointHistoryDone(clubPointResponse: response));
    } catch (e) {
      emit(PointHistoryError(
          errorMessage: (MyApp.context.resources.strings.errorGot)));
    }
  }
}
