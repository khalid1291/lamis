// To parse this JSON data, do
//
//     final cartResponse = cartResponseFromJson(jsonString);

import 'dart:convert';

import '../../data/remote/network/base_api_service.dart';

List<CartResponse> cartResponseFromJson(String str) => List<CartResponse>.from(
    json.decode(str).map((x) => CartResponse.fromJson(x)));

String cartResponseToJson(List<CartResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartResponse {
  CartResponse({
    this.name,
    this.ownerId,
    this.cartItems,
  });

  String? name;
  int? ownerId;
  List<CartItem>? cartItems;

  factory CartResponse.fromJson(Map<String, dynamic> json) => CartResponse(
        name: json["name"] ?? "",
        ownerId: json["owner_id"] ?? 0,
        cartItems: json["cart_items"] == null
            ? null
            : List<CartItem>.from(
                json["cart_items"].map((x) => CartItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name ?? "",
        "owner_id": ownerId ?? 0,
        "cart_items": cartItems == null
            ? []
            : List<dynamic>.from(cartItems!.map((x) => x.toJson())),
      };
}

class CartItem {
  CartItem(
      {required this.id,
      this.ownerId,
      this.userId,
      this.productId,
      this.productName,
      this.productThumbnailImage,
      this.variation,
      this.currencySymbol,
      this.price,
      this.tax,
      this.shippingCost,
      this.quantity,
      this.lowerLimit,
      this.upperLimit,
      required this.isFavourite});

  int id;
  int? ownerId;
  int? userId;
  int? productId;
  String? productName;
  String? productThumbnailImage;
  String? variation;
  double? price;
  String? currencySymbol;
  double? tax;
  double? shippingCost;
  int? quantity;
  int? lowerLimit;
  int? upperLimit;
  bool isFavourite;

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
      id: json["id"] ?? 0,
      ownerId: json["owner_id"] ?? 0,
      userId: json["user_id"] ?? 0,
      productId: json["product_id"] ?? 0,
      productName: json["product_name"] ?? "",
      productThumbnailImage:
          BaseApiService.imagesRoute + json["product_thumbnail_image"],
      variation: json["variation"] ?? "",
      price: json["price"].toDouble() ?? 0.0,
      currencySymbol: json["currency_symbol"] ?? "\$",
      tax: json["tax"].toDouble() ?? 0.0,
      shippingCost: json["shipping_cost"].toDouble() ?? 0.0,
      quantity: json["quantity"] ?? 1,
      lowerLimit: json["lower_limit"] ?? 1,
      upperLimit: json["upper_limit"] ?? 10,
      isFavourite: json["is_favourite"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "owner_id": ownerId ?? 0,
        "user_id": userId ?? 0,
        "product_id": productId ?? 0,
        "product_name": productName ?? "",
        "product_thumbnail_image": productThumbnailImage ?? "",
        "variation": variation ?? "",
        "price": price ?? 0,
        "currency_symbol": currencySymbol ?? "\$",
        "tax": tax ?? 0,
        "shipping_cost": shippingCost ?? 0,
        "quantity": quantity ?? 1,
        "lower_limit": lowerLimit ?? 1,
        "upper_limit": upperLimit ?? 10,
        "is_favourite": isFavourite
      };
}
