// To parse this JSON data, do
//
//     final clubpointResponse = clubpointResponseFromJson(jsonString);

import 'dart:convert';

import '../../models/models.dart';

ClubPointResponse clubPointResponseFromJson(String str) =>
    ClubPointResponse.fromJson(json.decode(str));

String clubPointResponseToJson(ClubPointResponse data) =>
    json.encode(data.toJson());

class ClubPointResponse {
  ClubPointResponse({
    required this.clubPoints,
    required this.links,
    required this.meta,
    required this.success,
    required this.status,
  });

  List<ClubPoint> clubPoints;
  Links links;
  Meta meta;
  bool success;
  int status;

  factory ClubPointResponse.fromJson(Map<String, dynamic> json) =>
      ClubPointResponse(
        clubPoints: List<ClubPoint>.from(
            json["data"].map((x) => ClubPoint.fromJson(x))),
        links: Links.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(clubPoints.map((x) => x.toJson())),
        "links": links.toJson(),
        "meta": meta.toJson(),
        "success": success,
        "status": status,
      };
}

class ClubPoint {
  ClubPoint(
      {required this.id,
      required this.userId,
      required this.points,
      required this.convertStatus,
      required this.date,
      this.type});

  int id;
  int userId;
  double points;
  int convertStatus;
  String date;
  String? type;

  factory ClubPoint.fromJson(Map<String, dynamic> json) => ClubPoint(
      id: json["id"],
      userId: json["user_id"],
      points: json["points"].toDouble(),
      convertStatus: json["convert_status"],
      date: json["date"],
      type: json["type"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "points": points,
        "convert_status": convertStatus,
        "date": date,
        "type": type
      };
}
