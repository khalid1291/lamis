import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:lamis/data/remote/remote.dart';
import 'package:lamis/models/models.dart';
import 'package:lamis/repos/app/app_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepo {
  static final UserRepo _singleton = UserRepo._internal();
  final BaseApiService _apiService = NetworkApiService();

  factory UserRepo() {
    return _singleton;
  }

  UserRepo._internal();

  String token = '';
  String language = 'ar';
  String country = 'JO';
  bool deletedAccount = false;
  User user = User(
      id: -1,
      type: '',
      name: '',
      email: '',
      avatar: '',
      avatarOriginal: '',
      code: '',
      phone: '');

  void setUserData({required User? user, required String token}) async {
    final prefs = await SharedPreferences.getInstance();
    String userEncoded = json.encode(user?.toJson());
    prefs.setString("user_token", token);
    prefs.setString("user", userEncoded);
    this.user = user ??
        User(
            id: -1,
            type: '',
            name: '',
            email: '',
            avatar: '',
            avatarOriginal: '',
            code: '',
            phone: '');
    this.token = token;
  }

  void changeLoggedInState({required bool state}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(AppRepo.isLoggedInKey, state);
  }

  getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    User user = User.fromJson(json.decode(prefs.getString("user") ?? ""));
    user.avatarOriginal = user.avatarOriginal
        .replaceFirst(RegExp(BaseApiService.imagesRoute), '');
    String? token = prefs.getString("user_token");
    this.user = user;
    this.token = token ?? '';
  }

  void saveUserToken({required String token}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("user_token", token);
  }

  void saveUserData({required User user}) async {
    final prefs = await SharedPreferences.getInstance();
    this.user = user;
    String userEncoded = json.encode(user.toJson());
    prefs.setString("user", userEncoded);
  }

  Future<String> getUserToken({required String token}) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("user_token");
    return token ?? '';
  }

  Future<ProfileResponse> getProfileResponse() async {
    try {
      dynamic response =
          await _apiService.getRequestAuthenticated(ApiEndPoints.getUserData);
      var temp = profileResponseFromJson(response);
      saveUserData(user: temp.user);
      return temp;
    } catch (e) {
      rethrow;
    }
  }

  Future<ProfileEditResponse> editProfile(
      {required int id, required String name, required String email}) async {
    Map<String, String> body = {
      "name": name,
      "email": email,
    };

    try {
      dynamic response = await _apiService.postRequestAuthenticated(
          ApiEndPoints.editProfile, body);
      return profileEditResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<ProfileUploadImageResponse> editProfileImage(
      {required int id,
      required String fileName,
      required String image}) async {
    Map<String, String> body = {
      // "id": "$id",
      "filename": fileName,
      "image": image
    };

    try {
      dynamic response = await _apiService.postRequestAuthenticated(
          ApiEndPoints.editProfileImage, body);
      return profileUploadImageResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<ProfileCountersResponse> getCounterResponse() async {
    try {
      dynamic response = await _apiService
          .getRequestAuthenticated(ApiEndPoints.getUserCounters);
      return profileCountersResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderMiniResponse> getOrdersResponse(
      {required int userId,
      required int page,
      required String paymentStatus,
      required String deliveryStatus}) async {
    try {
      dynamic response = await _apiService.getRequestAuthenticated(
          "${ApiEndPoints.getUserOrders}?page=$page&payment_status=$paymentStatus&delivery_status=$deliveryStatus");
      return orderMiniResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderDetailResponse> getOrderHistoryDetails(
      {required int orderId}) async {
    try {
      dynamic response = await _apiService.getRequestAuthenticated(
          ApiEndPoints.getOrderHistoryDetails + orderId.toString());
      return orderDetailResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderItemResponse> getOrderHistoryItem({required int orderId}) async {
    try {
      dynamic response = await _apiService.getRequestAuthenticated(
          ApiEndPoints.getOrderHistoryItem + orderId.toString());
      return orderItemlResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralResponse> sendForgetPassword(
      {required String email, required String sendBy}) async {
    Map<String, String> body = {
      'email_or_phone': email,
      'send_code_by': sendBy
    };
    try {
      dynamic response =
          await _apiService.postRequest(ApiEndPoints.forgetPassword, body);
      return generalResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<LoginResponse> sendVerifyCode(
      {required String phone, required String verifyCode}) async {
    Map<String, String> body = {
      'phone': phone,
      'verification_code': verifyCode
    };
    try {
      dynamic response =
          await _apiService.postRequest(ApiEndPoints.confirmLogin, body);
      return loginResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<Object> sendVerifyCodeRegister(
      {required String phone, required String verifyCode}) async {
    Map<String, String> body = {
      'phone': phone,
      'verification_code': verifyCode
    };
    try {
      dynamic response =
          await _apiService.postRequest(ApiEndPoints.confirmRegister, body);
      try {
        return loginResponseFromJson(response);
      } catch (e) {
        return generalResponseFromJson(response);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralResponse> sendVerifyCodeRegisterGeneral(
      {required String phone, required String verifyCode}) async {
    Map<String, String> body = {
      'phone': phone,
      'verification_code': verifyCode
    };
    try {
      dynamic response =
          await _apiService.postRequest(ApiEndPoints.confirmRegister, body);
      return generalResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralResponse> sendFcmToken({required String deviceToken}) async {
    Map<String, String> body = {'device_token': deviceToken};
    if (kDebugMode) {
      print("device token is $deviceToken");
    }
    try {
      dynamic response = await _apiService.postRequestAuthenticated(
          ApiEndPoints.sendFcm, body);
      return generalResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralResponse> logoutFromSession() async {
    try {
      dynamic response =
          await _apiService.getRequestAuthenticated(ApiEndPoints.logout);
      return generalResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<WalletBalanceResponse> getWalletResponse() async {
    try {
      dynamic response =
          await _apiService.getRequestAuthenticated(ApiEndPoints.walletBalance);
      return walletBalanceResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<WalletHistoryResponse> getWalletHistoryResponse(int pageNumber) async {
    try {
      dynamic response = await _apiService.getRequestAuthenticated(
          "${ApiEndPoints.walletHistory}?page=$pageNumber");
      return walletHistoryResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<ClubPointResponse> getClubPointsHistory(int pageNumber) async {
    try {
      dynamic response = await _apiService.getRequestAuthenticated(
          "${ApiEndPoints.clubPoint}?page=$pageNumber");
      return clubPointResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralResponse> convertPoints({required int id}) async {
    Map<String, String> body = {'id': id.toString()};
    try {
      dynamic response = await _apiService.postRequestAuthenticated(
          ApiEndPoints.convertPoint, body);
      return generalResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<MyPointsResponse> getMyPoints() async {
    try {
      dynamic response =
          await _apiService.getRequestAuthenticated(ApiEndPoints.myPoints);
      return myPointResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralResponse> convertAllPoints() async {
    Map<String, String> body = {};
    try {
      dynamic response = await _apiService.postRequestAuthenticated(
          ApiEndPoints.convertAllPoints, body);
      return generalResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralResponse> deleteAccount() async {
    try {
      dynamic response =
          await _apiService.getRequestAuthenticated(ApiEndPoints.deleteAccount);
      return generalResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralResponse> removeProfileImage() async {
    Map<String, String> body = {};
    try {
      dynamic response = await _apiService.postRequestAuthenticated(
          ApiEndPoints.deleteImage, body);
      return generalResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
