import 'dart:convert';

GeneralResponse generalResponseFromJson(String str) =>
    GeneralResponse.fromJson(json.decode(str));

String generalResponseToJson(GeneralResponse data) =>
    json.encode(data.toJson());

class GeneralResponse {
  GeneralResponse({
    required this.result,
    required this.message,
  });

  bool result;
  String message;

  factory GeneralResponse.fromJson(Map<String, dynamic> json) =>
      GeneralResponse(
        result: json["result"] ?? json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
      };
}
