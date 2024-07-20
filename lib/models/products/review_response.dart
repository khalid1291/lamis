// To parse this JSON data, do
//
//     final reviewResponse = reviewResponseFromJson(jsonString);

import 'dart:convert';

import '../../data/remote/network/base_api_service.dart';
import '../general/meta.dart';

ReviewResponse reviewResponseFromJson(String str) =>
    ReviewResponse.fromJson(json.decode(str));

String reviewResponseToJson(ReviewResponse data) => json.encode(data.toJson());

class ReviewResponse {
  ReviewResponse({
    this.reviews,
    this.meta,
    this.success,
    this.status,
  });

  List<Review>? reviews;
  Meta? meta;
  bool? success;
  int? status;

  factory ReviewResponse.fromJson(Map<String, dynamic> json) => ReviewResponse(
        reviews: List<Review>.from(json["data"].map((x) => Review.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(reviews!.map((x) => x.toJson())),
        "meta": meta?.toJson(),
        "success": success,
        "status": status,
      };
}

class Review {
  Review({
    this.userId,
    this.userName,
    this.avatar,
    this.rating,
    this.comment,
    this.time,
  });

  int? userId;
  String? userName;
  String? avatar;
  double? rating;
  String? comment;
  String? time;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        userId: json["user_id"],
        userName: json["user_name"],
        avatar: BaseApiService.imagesRoute + json["avatar"],
        rating: json["rating"].toDouble(),
        comment: json["comment"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "avatar": avatar,
        "rating": rating,
        "comment": comment,
        "time": time,
      };
}
