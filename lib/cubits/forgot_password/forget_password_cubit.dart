import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/models.dart';
import '../../../../repos/repos.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<VerificationState> {
  ForgetPasswordCubit() : super(VerificationInitial());
  UserRepo repo = UserRepo();

  // void sendForgetPassword(
  //     {required String email, required String sendBy}) async {
  //   emit(ForgetPasswordLoading());
  //
  //   try {
  //     GeneralResponse response =
  //         await repo.sendForgetPassword(email: email, sendBy: sendBy);
  //     emit(ForgetPasswordDone(forgetPasswordResponse: response));
  //   } catch (e) {
  //     emit(ForgetPasswordError(message: e.toString()));
  //   }
  // }

  void sendVerifyCode(
      {required String phone,
      required String verifyCode,
      required bool isRegister}) async {
    emit(VerificationLoading());

    try {
      // if (isRegister) {
      dynamic response = await repo.sendVerifyCodeRegister(
          phone: phone, verifyCode: verifyCode);
      if (response.result) {
        emit(VerifyRegisterDone(generalResponse: response));
      } else {
        emit(VerificationError(message: response.message));
      }
      // } else {
      //   LoginResponse response =
      //       await repo.sendVerifyCode(phone: phone, verifyCode: verifyCode);
      //   emit(VerificationDone(loginResponse: response));
      // }
    } catch (e) {
      ///for test
      // GeneralResponse response = await repo.sendVerifyCodeRegisterGeneral(
      //     phone: phone, verifyCode: verifyCode);
      emit(VerificationError(message: e.toString()));
    }
  }
}
