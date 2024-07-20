import 'dart:convert';

import 'package:lamis/data/remote/remote.dart';

VariantResponse variantResponseFromJson(String str) =>
    VariantResponse.fromJson(json.decode(str));

String variantResponseToJson(VariantResponse data) =>
    json.encode(data.toJson());

class VariantResponse {
  VariantResponse(
      {this.productId,
      this.variant,
      this.price,
      this.priceString,
      this.stock,
      this.image,
      this.basePriceString});

  int? productId;
  String? variant;
  double? price;
  String? priceString;
  int? stock;
  String? image;
  String? basePriceString;

  factory VariantResponse.fromJson(Map<String, dynamic> json) =>
      VariantResponse(
          productId: json["product_id"],
          variant: json["variant"],
          price: json["price"].toDouble(),
          priceString: json["price_string"],
          stock: json["stock"],
          image: BaseApiService.imagesRoute + json["image"],
          basePriceString: json["base_price_string"]);

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "variant": variant,
        "price": price,
        "price_string": priceString,
        "stock": stock,
        "image": image,
        "base_price_string": basePriceString
      };
}
