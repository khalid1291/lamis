import 'dart:convert';

SignupResponse signupResponseFromJson(String str) =>
    SignupResponse.fromJson(json.decode(str));

String signupResponseToJson(SignupResponse data) => json.encode(data.toJson());

class SignupResponse {
  SignupResponse({
    required this.result,
    required this.message,
    this.userId,
  });

  bool result;
  String message;
  int? userId;

  factory SignupResponse.fromJson(Map<String, dynamic> json) => SignupResponse(
        result: json["result"],
        message: json["message"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
        "user_id": userId,
      };
}
