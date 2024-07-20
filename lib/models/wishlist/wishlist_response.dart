import 'dart:convert';

import 'package:lamis/data/remote/remote.dart';

WishlistResponse wishlistResponseFromJson(String str) =>
    WishlistResponse.fromJson(json.decode(str));

String wishlistResponseToJson(WishlistResponse data) =>
    json.encode(data.toJson());

class WishlistResponse {
  WishlistResponse({
    this.wishlistItems,
    required this.success,
    required this.status,
  });

  List<WishlistItem>? wishlistItems;
  bool success;
  int status;

  factory WishlistResponse.fromJson(Map<String, dynamic> json) =>
      WishlistResponse(
        wishlistItems: List<WishlistItem>.from(
            json["data"].map((x) => WishlistItem.fromJson(x))),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(wishlistItems!.map((x) => x.toJson())),
        "success": success,
        "status": status,
      };
}

class WishlistItem {
  WishlistItem({
    required this.id,
    required this.product,
  });

  int id;
  Product product;

  factory WishlistItem.fromJson(Map<String, dynamic> json) => WishlistItem(
        id: json["id"],
        product: Product.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product": product.toJson(),
      };
}

class Product {
  Product({
    required this.id,
    this.name,
    this.thumbnailImage,
    this.basePrice,
    this.rating,
  });

  int id;
  String? name;
  String? thumbnailImage;
  String? basePrice;
  double? rating;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        thumbnailImage: BaseApiService.imagesRoute + json["thumbnail_image"],
        basePrice: json["base_price"],
        rating: json["rating"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "thumbnail_image": thumbnailImage,
        "base_price": basePrice,
        "rating": rating,
      };
}
