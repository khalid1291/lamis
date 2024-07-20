import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repos/repos.dart';
import '../../models/models.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void save(value) {
    emit(value);
  }

  void login({
    required String phone,
    // required String password,
  }) async {
    AuthRepo repo = AuthRepo();

    emit(AuthLoading());

    try {
      GeneralResponse response = await repo.getLoginResponse(phone: phone);

      if (response.result) {
        emit(AuthDoneBeforeVerification(loginResponse: response));
      } else {
        emit(AuthError(message: response.message));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
  //
  // void googleLogin({context}) async {
  //   AuthRepo repo = AuthRepo();
  //
  //   emit(AuthLoading());
  //   var user = await Authentication.signInWithGoogle(context: context);
  //   if (user == null) {
  //     emit(AuthError(message: "Failed to Login using Google"));
  //   } else {
  //     try {
  //       LoginResponse response = await repo.getSocialLoginResponse(
  //           name: user.displayName ?? "", email: user.email, id: user.id);
  //
  //       if (response.result) {
  //         emit(AuthDone(loginResponse: response));
  //       } else {
  //         emit(AuthError(message: response.message));
  //       }
  //     } catch (e) {
  //       emit(AuthError(message: e.toString()));
  //     }
  //   }
  // }

  // void facebookLogin({context}) async {
  //   AuthRepo repo = AuthRepo();
  //   UserCredential facebookCredentials;
  //   emit(AuthLoading());
  //   try {
  //     facebookCredentials = await Authentication.signInWithFacebook();
  //   } on Exception catch (e) {
  //     emit(AuthError(message: e.toString()));
  //     return;
  //   }
  //
  //   if (facebookCredentials.user == null) {
  //     emit(AuthError(message: "Failed to Login using Facebook"));
  //   } else {
  //     try {
  //       LoginResponse response = await repo.getSocialLoginResponse(
  //           name: facebookCredentials.user?.displayName ?? "",
  //           email: facebookCredentials.user?.email ?? "",
  //           id: facebookCredentials.user?.uid ?? "");
  //
  //       if (response.result) {
  //         emit(AuthDone(loginResponse: response));
  //       } else {
  //         emit(AuthError(message: response.message));
  //       }
  //     } catch (e) {
  //       emit(AuthError(message: e.toString()));
  //     }
  //   }
  // }

  void signUp({
    required String name,
    required String phone,
    String? code,
  }) async {
    AuthRepo repo = AuthRepo();

    emit(AuthLoading());

    try {
      SignupResponse response =
          await repo.getSignupResponse(name: name, phone: phone, code: code);

      if (response.result) {
        //login(phone: phone);
        emit(RegisterSuccess(signupResponse: response));
      } else {
        emit(AuthError(message: response.message));
      }
    } catch (e) {
      GeneralResponse generalResponse = await repo.getSignupResponseGeneral(
          name: name, phone: phone, code: code);

      emit(AuthError(message: generalResponse.message));
    }
  }

  void returnToInitial() => emit(AuthInitial());
}
