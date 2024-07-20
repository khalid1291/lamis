// To parse this JSON data, do
//
//     final userByTokenResponse = userByTokenResponseFromJson(jsonString);

import 'dart:convert';

import '../../data/remote/network/base_api_service.dart';
import '../models.dart';

ProfileResponse profileResponseFromJson(String str) =>
    ProfileResponse.fromJson(json.decode(str));

String profileResponseToJson(ProfileResponse data) =>
    json.encode(data.toJson());

class ProfileResponse {
  ProfileResponse({required this.result, required this.user});

  bool result;
  User user;

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      ProfileResponse(
        result: json["result"],
        user: User(
            id: json["id"],
            name: json["name"],
            email: json["email"],
            avatar: json["avatar"],
            avatarOriginal:
                BaseApiService.imagesRoute + json["avatar_original"],
            phone: json["phone"],
            code: json["affiliate_code"]),
      );

  Map<String, dynamic> toJson() => {"result": result, "user": user.toJson()};
}
