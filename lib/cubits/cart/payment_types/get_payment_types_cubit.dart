import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/res/app_context_extension.dart';

import '../../../../repos/repos.dart';
import '../../../../models/models.dart';
import '../../../main.dart';

part 'get_payment_types_state.dart';

class GetPaymentTypesCubit extends Cubit<GetPaymentTypesState> {
  final _myRepo = CartRepo();
  GetPaymentTypesCubit() : super(GetPaymentTypesInitial());

  Future<void> getPaymentTypes() async {
    emit(GetPaymentTypesLoading());

    try {
      List<PaymentTypeResponse>? val = await _myRepo.fetchPaymentTypes();
      emit(GetPaymentTypesDone(val!));
    } catch (e) {
      emit(GetPaymentTypesError(MyApp.context.resources.strings.errorGot));
    }
  }
}
