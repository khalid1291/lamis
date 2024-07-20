// To parse this JSON data, do
//
//     final profileEditResponse = profileEditResponseFromJson(jsonString);

import 'dart:convert';

ProfileEditResponse profileEditResponseFromJson(String str) =>
    ProfileEditResponse.fromJson(json.decode(str));

String profileEditResponseToJson(ProfileEditResponse data) =>
    json.encode(data.toJson());

class ProfileEditResponse {
  ProfileEditResponse({
    required this.result,
    required this.message,
  });

  bool result;
  String message;

  factory ProfileEditResponse.fromJson(Map<String, dynamic> json) =>
      ProfileEditResponse(
        result: json["result"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
      };
}
