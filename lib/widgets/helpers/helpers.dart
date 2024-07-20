import 'package:flutter/painting.dart';
import 'package:lamis/repos/repos.dart';

class ColorHelper {
  static Color getColorFromColorCode(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}

class WordsHelper {
  static String getLang(ValidationMessage type) {
    switch (type) {
      case ValidationMessage.emailRequired:
        switch (UserRepo().language) {
          case "en":
            return "email is required.";
          case "ar":
            return "الايميل مطلوب";

          default:
            {
              return "email is required.";
            }
        }
      case ValidationMessage.passwordRequired:
        switch (UserRepo().language) {
          case "en":
            return "password is required.";
          case "ar":
            return "كلمة السر مطلوبة";

          default:
            {
              return "password is required.";
            }
        }
      case ValidationMessage.emailNotValid:
        switch (UserRepo().language) {
          case "en":
            return "email is invalid.";
          case "ar":
            return "البريدالالكتروني غير صحيح";

          default:
            {
              return "email is invalid.";
            }
        }
      case ValidationMessage.passwordNotValid:
        switch (UserRepo().language) {
          case "en":
            return "password must be at least 6 characters.";
          case "ar":
            return "كلمة المرور يجب أن تكون 6 محارف";

          default:
            {
              return "password must be at least 6 characters.";
            }
        }
      case ValidationMessage.passwordNotMatch:
        switch (UserRepo().language) {
          case "en":
            return "password not match.";
          case "ar":
            return "كلمة المرور غير مطابقة";

          default:
            {
              return "password not match.";
            }
        }
      case ValidationMessage.firstNameRequired:
        switch (UserRepo().language) {
          case "en":
            return "First Name is Required.";
          case "ar":
            return "الاسم الاول مطلوب";

          default:
            {
              return "First Name is Required.";
            }
        }
      case ValidationMessage.lastNameRequired:
        switch (UserRepo().language) {
          case "en":
            return "Last Name is Required.";
          case "ar":
            return "الاسم الأخير مطلوب";

          default:
            {
              return "Last Name is Required.";
            }
        }
      case ValidationMessage.phoneNumberRequired:
        switch (UserRepo().language) {
          case "en":
            return "Phone Number is Required.";
          case "ar":
            return "رقم الهاتف مطلوب";

          default:
            {
              return "Phone Number is Required.";
            }
        }
      case ValidationMessage.phoneNumberNotValid:
        switch (UserRepo().language) {
          case "en":
            return "phone number not valid.";
          case "ar":
            return "رقم الهاتف غير صحيح";

          default:
            {
              return "phone number not valid.";
            }
        }
      case ValidationMessage.codeNotValid:
        switch (UserRepo().language) {
          case "en":
            return "*Please fill up all the cells properly";
          case "ar":
            return "الرجاء ادخال جميع الارقام";

          default:
            {
              return "*Please fill up all the cells properly";
            }
        }
    }
  }

  // static String emailRequired = "email is required.";
  // static String passwordRequired = "password is required.";
  // static String emailNotValid = "email not valid.";
  // static String passwordNotValid = "password must be at least 6 characters.";
  // static String passwordNotMatch = "password not match.";
  // static String firstNameRequired = "first name required";
  // static String lastNameRequired = "last name required";
  // static String phoneNumberRequired = "phone number required";
  // static String phoneNumberNotValid = "phone number not valid";
  // static String codeNotValid = "*Please fill up all the cells properly";
}

enum ValidationMessage {
  emailRequired,
  passwordRequired,
  emailNotValid,
  passwordNotValid,
  passwordNotMatch,
  firstNameRequired,
  lastNameRequired,
  phoneNumberRequired,
  phoneNumberNotValid,
  codeNotValid
}
