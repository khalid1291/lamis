import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../widgets/helpers/helpers.dart';

class ValidationCubit extends Cubit<bool?> {
  ValidationCubit(bool? initialState) : super(true);
  // int result = getTheme() as int;
  late String emailErrorMessage;
  late String passwordErrorMessage;
  String phoneErrorMessage = "";

  String validateEmail(String email, bool clear) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+")
        .hasMatch(email);
    // bool emailValid = RegExp(
    //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    //  .hasMatch(email);

    // if (kDebugMode) {
    //   print(emailValid);
    // }
    //emit(emailValid);
    if (email.isEmpty) {
      if (clear) {
        emit(true);
        return "";
      } else {
        emit(null);
        return WordsHelper.getLang(ValidationMessage.emailRequired);
      }
    } else {
      emit(emailValid);
      return WordsHelper.getLang(ValidationMessage.emailNotValid);
    }
  }

  String validatePassword(String password, bool clear) {
    if (password.length < 6) {
      if (password.isEmpty) {
        if (clear) {
          emit(true);
          return "";
        } else {
          emit(null);
          return WordsHelper.getLang(ValidationMessage.passwordRequired);
        }
      } else {
        emit(false);
        return WordsHelper.getLang(ValidationMessage.passwordNotValid);
      }
    } else {
      emit(true);
      return WordsHelper.getLang(ValidationMessage.passwordNotValid);
    }
  }

  String checkRetryPassword(String password, String retryPassword, bool clear) {
    if (!clear) {
      emit(false);
      return WordsHelper.getLang(ValidationMessage.passwordNotMatch);
    }
    if (retryPassword.isEmpty) {
      emit(false);
      return WordsHelper.getLang(ValidationMessage.passwordNotMatch);
    } else if (password == retryPassword) {
      emit(true);
      return "";
    } else {
      emit(false);
      return WordsHelper.getLang(ValidationMessage.passwordNotMatch);
    }
  }

  String checkFirstName(String firstName) {
    if (firstName.trim().isEmpty) {
      emit(false);
      return WordsHelper.getLang(ValidationMessage.firstNameRequired);
    }
    emit(true);
    return "";
  }

  String checkLastName(String firstName) {
    if (firstName.trim().isEmpty) {
      emit(false);
      return WordsHelper.getLang(ValidationMessage.lastNameRequired);
    }
    emit(true);
    return "";
  }

  String validationPhoneNumber(String phone) {
    if (phone.isEmpty) {
      emit(null);
      phoneErrorMessage =
          WordsHelper.getLang(ValidationMessage.phoneNumberRequired);
      return WordsHelper.getLang(ValidationMessage.phoneNumberRequired);
    }

    if (double.tryParse(phone) != null) {
      if (phone.length >= 6) {
        emit(true);
        phoneErrorMessage = "";
        return "";
      }
      emit(false);
      phoneErrorMessage =
          WordsHelper.getLang(ValidationMessage.phoneNumberNotValid);

      return WordsHelper.getLang(ValidationMessage.phoneNumberNotValid);
    }
    emit(false);
    phoneErrorMessage =
        WordsHelper.getLang(ValidationMessage.phoneNumberNotValid);

    return WordsHelper.getLang(ValidationMessage.phoneNumberNotValid);
  }

  String validationVerificationCode(String code, errorController) {
    if (code.length != 6) {
      emit(false);
      errorController!.add(ErrorAnimationType.shake);
      return WordsHelper.getLang(ValidationMessage.codeNotValid);
    } else {
      emit(true);
      return "n";
    }
  }

  void save(bool state) {
    emit(state);
  }
}
