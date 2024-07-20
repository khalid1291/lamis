import 'dart:convert';

import 'package:lamis/data/remote/remote.dart';

FlashDealResponse flashDealResponseFromJson(String str) =>
    FlashDealResponse.fromJson(json.decode(str));

String flashDealResponseToJson(FlashDealResponse data) =>
    json.encode(data.toJson());

class FlashDealResponse {
  FlashDealResponse({
    this.flashDeals,
    required this.success,
    required this.status,
  });

  List<FlashDeal>? flashDeals;
  bool success;
  int status;

  factory FlashDealResponse.fromJson(Map<String, dynamic> json) =>
      FlashDealResponse(
        flashDeals: List<FlashDeal>.from(
            json["data"].map((x) => FlashDeal.fromJson(x))),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(flashDeals!.map((x) => x.toJson())),
        "success": success,
        "status": status,
      };
}

class FlashDeal {
  FlashDeal({
    required this.id,
    this.title,
    this.date,
    this.banner,
  });

  int id;
  String? title;
  int? date;
  String? banner;

  factory FlashDeal.fromJson(Map<String, dynamic> json) => FlashDeal(
        id: json["id"],
        title: json["title"],
        date: json["date"],
        banner: BaseApiService.imagesRoute + json["banner"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "date": date,
        "banner": banner,
      };
}
