
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../repos/repos.dart';
import '../../../../models/models.dart';

part 'counters_state.dart';

class CountersCubit extends Cubit<CountersState> {
  CountersCubit() : super(CountersInitial());

  void getCountersData() async {
    UserRepo repo = UserRepo();

    emit(CountersLoading());

    try {
      ProfileCountersResponse response = await repo.getCounterResponse();

      emit(CountersDone(profileCountersResponse: response));
    } catch (e) {
      emit(CountersError());
    }
  }
}
