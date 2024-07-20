// To parse this JSON data, do
//
//     final profileUploadImageResponse = profileUploadImageResponseFromJson(jsonString);

import 'dart:convert';

ProfileUploadImageResponse profileUploadImageResponseFromJson(String str) =>
    ProfileUploadImageResponse.fromJson(json.decode(str));

String profileUploadImageResponseToJson(ProfileUploadImageResponse data) =>
    json.encode(data.toJson());

class ProfileUploadImageResponse {
  ProfileUploadImageResponse({
    required this.result,
    required this.message,
    required this.path,
  });

  bool result;
  String message;
  String path;

  factory ProfileUploadImageResponse.fromJson(Map<String, dynamic> json) =>
      ProfileUploadImageResponse(
        result: json["result"],
        message: json["message"],
        path: json["path"],
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
        "path": path,
      };
}
