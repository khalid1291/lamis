import 'dart:convert';

import '../../../../models/models.dart';

UnAuthorisedResponse unAuthorisedResponseFromJson(String str) =>
    UnAuthorisedResponse.fromJson(json.decode(str));

String unAuthorisedResponseToJson(UnAuthorisedResponse data) =>
    json.encode(data.toJson());

class UnAuthorisedResponse {
  bool result;
  String message;
  User? user;

  UnAuthorisedResponse(
      {required this.result, required this.message, this.user});

  factory UnAuthorisedResponse.fromJson(Map<String, dynamic> json) =>
      UnAuthorisedResponse(
        result: json["result"],
        message: json["message"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );
  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
        "user": user?.toJson(),
      };
}
