import 'dart:convert';

MyPointsResponse myPointResponseFromJson(String str) =>
    MyPointsResponse.fromJson(json.decode(str));

String myPointResponseToJson(MyPointsResponse data) =>
    json.encode(data.toJson());

class MyPointsResponse {
  MyPointsResponse({
    required this.success,
    required this.pointsSystemConvertRate,
    required this.userPoints,
  });

  bool success;
  String pointsSystemConvertRate;
  double userPoints;

  factory MyPointsResponse.fromJson(Map<String, dynamic> json) =>
      MyPointsResponse(
          success: json["result"],
          pointsSystemConvertRate: json["points_system_convert_rate"],
          userPoints: json["user_points"].toDouble());

  Map<String, dynamic> toJson() => {
        "result": success,
        "points_system_convert_rate": pointsSystemConvertRate,
        "user_points": userPoints
      };
}
