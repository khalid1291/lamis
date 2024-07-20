// To parse this JSON data, do
//
//     final shopResponse = shopResponseFromJson(jsonString);
// https://app.quicktype.io/

import 'dart:convert';

import '../../data/remote/network/base_api_service.dart';
import '../general/meta.dart';

ShopResponse shopResponseFromJson(String str) =>
    ShopResponse.fromJson(json.decode(str));

String shopResponseToJson(ShopResponse data) => json.encode(data.toJson());

class ShopResponse {
  ShopResponse({
    required this.shops,
    required this.meta,
    required this.success,
    required this.status,
  });

  List<Shop> shops;
  Meta? meta;
  bool success;
  int status;

  factory ShopResponse.fromJson(Map<String, dynamic> json) => ShopResponse(
        shops: List<Shop>.from(json["data"].map((x) => Shop.fromJson(x))),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(shops.map((x) => x.toJson())),
        "meta": meta?.toJson(),
        "success": success,
        "status": status,
      };
}

class Shop {
  Shop({
    required this.id,
    required this.name,
    required this.logo,
  });

  int id;
  String name;
  String logo;

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        id: json["id"],
        name: json["name"],
        logo: BaseApiService.imagesRoute + json["logo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "logo": logo,
      };
}
