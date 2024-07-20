import 'package:lamis/data/remote/remote.dart';
import 'package:lamis/models/models.dart';

class AuthRepo {
  final BaseApiService _apiService = NetworkApiService();

  Future<GeneralResponse> getLoginResponse({required String phone}) async {
    Map<String, String> body = {
      "phone": phone,
    };

    try {
      dynamic response =
          await _apiService.postRequest(ApiEndPoints.login, body);
      return generalResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<SignupResponse> getSignupResponse(
      {required String name, required String phone, String? code}) async {
    Map<String, String> body = {
      "name": name,
      "phone": phone,
      "affiliate_code": code ?? ''
    };

    // Map<String, String> body = {
    //   "name": name,
    //   "email_or_phone": email,
    //   "password": password,
    //   "password_confirmation": password,
    //   "register_by": "email"
    // };

    try {
      dynamic response =
          await _apiService.postRequest(ApiEndPoints.signup, body);
      return signupResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralResponse> getSignupResponseGeneral(
      {required String name, required String phone, String? code}) async {
    Map<String, String> body = {
      "name": name,
      "phone": phone,
      "affiliate_code": code ?? ''
    };

    try {
      dynamic response =
          await _apiService.postRequest(ApiEndPoints.signup, body);
      return generalResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<LoginResponse> getSocialLoginResponse(
      {required String name, required String email, required String id}) async {
    Map<String, String> body = {"name": name, "email": email, "provider": id};

    try {
      dynamic response =
          await _apiService.postRequest(ApiEndPoints.socialLogin, body);
      return loginResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
