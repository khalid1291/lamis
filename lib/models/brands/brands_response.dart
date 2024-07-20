// To parse this JSON data, do
//
//     final brandResponse = brandResponseFromJson(jsonString);
// https://app.quicktype.io/
import 'dart:convert';

import '../../data/remote/network/base_api_service.dart';
import '../general/meta.dart';

BrandResponse brandResponseFromJson(String str) =>
    BrandResponse.fromJson(json.decode(str));

String brandResponseToJson(BrandResponse data) => json.encode(data.toJson());

class BrandResponse {
  BrandResponse({
    required this.brands,
    required this.meta,
    required this.success,
    required this.status,
  });

  List<Brands> brands;
  Meta? meta;
  bool success;
  int status;

  factory BrandResponse.fromJson(Map<String, dynamic> json) => BrandResponse(
        brands: List<Brands>.from(json["data"].map((x) => Brands.fromJson(x))),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(brands.map((x) => x.toJson())),
        "meta": meta?.toJson(),
        "success": success,
        "status": status,
      };
}

class Brands {
  Brands({
    required this.id,
    required this.name,
    required this.logo,
    required this.links,
  });

  int id;
  String name;
  String logo;
  BrandsLinks links;
  bool selected = false;

  factory Brands.fromJson(Map<String, dynamic> json) => Brands(
        name: json["name"],
        id: json["id"],
        logo: BaseApiService.imagesRoute + json["logo"],
        links: BrandsLinks.fromJson(json["links"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "logo": logo,
        "links": links.toJson(),
      };
}

class BrandsLinks {
  BrandsLinks({
    required this.products,
  });

  String products;

  factory BrandsLinks.fromJson(Map<String, dynamic> json) => BrandsLinks(
        products: json["products"],
      );

  Map<String, dynamic> toJson() => {
        "products": products,
      };
}
