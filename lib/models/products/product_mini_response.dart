import 'dart:convert';

import 'package:lamis/data/remote/remote.dart';

import '../general/links.dart';
import '../general/meta.dart';

ProductMiniResponse productMiniResponseFromJson(String str) =>
    ProductMiniResponse.fromJson(json.decode(str));

String productMiniResponseToJson(ProductMiniResponse data) =>
    json.encode(data.toJson());

class ProductMiniResponse {
  ProductMiniResponse({
    required this.products,
    required this.meta,
    required this.success,
    required this.status,
  });

  List<MiniProduct> products;
  bool success;
  int status;
  Meta? meta;

  factory ProductMiniResponse.fromJson(Map<String, dynamic> json) =>
      ProductMiniResponse(
        products: List<MiniProduct>.from(
            json["data"].map((x) => MiniProduct.fromJson(x))),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(products.map((x) => x.toJson())),
        "meta": meta?.toJson() ??
            Meta(
                to: null,
                total: null,
                perPage: null,
                path: '',
                lastPage: null,
                from: null,
                currentPage: null),
        "success": success,
        "status": status,
      };
}

class MiniProduct {
  MiniProduct(
      {required this.id,
      required this.name,
      required this.thumbnailImage,
      required this.mainPrice,
      required this.strokedPrice,
      required this.hasDiscount,
      required this.rating,
      required this.sales,
      required this.links,
      this.wishlisted});

  int id;
  String name;
  String thumbnailImage;
  String mainPrice;
  String strokedPrice;
  bool hasDiscount;
  int rating;
  int sales;
  Links links;
  bool? wishlisted;

  factory MiniProduct.fromJson(Map<String, dynamic> json) => MiniProduct(
        id: json["id"],
        name: json["name"],
        thumbnailImage: BaseApiService.imagesRoute + json["thumbnail_image"],
        mainPrice: json["main_price"],
        strokedPrice: json["stroked_price"],
        hasDiscount: json["has_discount"],
        rating: json["rating"].toInt(),
        sales: json["sales"],
        links: Links.fromJson(
          json["links"],
        ),
        wishlisted: json["wishlisted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "thumbnail_image": thumbnailImage,
        "main_price": mainPrice,
        "stroked_price": strokedPrice,
        "has_discount": hasDiscount,
        "rating": rating,
        "sales": sales,
        "links": links.toJson(),
        "wishlisted": wishlisted
      };
}
