import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/models/models.dart';

import '../../../repos/repos.dart';

part 'delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit() : super(DeleteAccountInitial());

  void deleteMyAccount() async {
    UserRepo repo = UserRepo();

    emit(DeleteAccountLoading());

    try {
      GeneralResponse response = await repo.deleteAccount();

      if (response.result) {
        repo.changeLoggedInState(state: false);
        repo.token = "";
        repo.deletedAccount = true;
        emit(DeleteAccountDone());
      } else {
        emit(DeleteAccountError(response.message));
      }
    } catch (e) {
      emit(DeleteAccountError(e.toString()));
    }
  }
}
