import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubits/cubits.dart';
import '../../../../repos/repos.dart';

class IsLoggedInCubit extends Cubit<bool> {
  final UserRepo userRepo;

  IsLoggedInCubit(bool initialState, {required this.userRepo})
      : super(initialState);

  void changeUserState({required bool isLoggedIn}) {
    userRepo.changeLoggedInState(state: isLoggedIn);
    emit(isLoggedIn);
  }

  void logOut({required BuildContext context}) {
    userRepo.logoutFromSession();
    userRepo.setUserData(user: null, token: '');
    Authentication.signOut(context: context);
    changeUserState(isLoggedIn: false);
  }
}
