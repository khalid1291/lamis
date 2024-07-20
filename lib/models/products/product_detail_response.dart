import 'dart:convert';

import 'package:lamis/data/remote/remote.dart';
import 'package:lamis/main.dart';
import 'package:lamis/res/resources_export.dart';

ProductDetailsResponse productDetailsResponseFromJson(String str) {
  return ProductDetailsResponse.fromJson(json.decode(str));
}

String productDetailsResponseToJson(ProductDetailsResponse data) =>
    json.encode(data.toJson());

class ProductDetailsResponse {
  ProductDetailsResponse({
    required this.detailedProducts,
    required this.success,
    required this.status,
  });

  List<DetailedProduct> detailedProducts;
  bool success;
  int status;

  factory ProductDetailsResponse.fromJson(Map<String, dynamic> json) =>
      ProductDetailsResponse(
        detailedProducts: List<DetailedProduct>.from(
            json["data"].map((x) => DetailedProduct.fromJson(x))),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(detailedProducts.map((x) => x.toJson())),
        "success": success,
        "status": status,
      };
}

class DetailedProduct {
  DetailedProduct(
      {this.id,
      this.name,
      this.categoryName,
      this.addedBy,
      this.sellerId,
      this.shopId,
      this.shopName,
      this.shopLogo,
      this.photos,
      this.thumbnailImage,
      this.tags,
      this.priceHighLow,
      this.choiceOptions,
      this.colors,
      this.hasDiscount,
      this.strokedPrice,
      this.mainPrice,
      this.calculablePrice,
      this.currencySymbol,
      this.currentStock,
      this.unit,
      this.rating,
      this.ratingCount,
      this.earnPoint,
      this.description,
      this.videoLink,
      this.link,
      this.brand,
      this.location,
      this.stockVisibility,
      this.instagramPage,
      this.privacyPolicy,
      this.cashOnDelivery,
      this.websiteLink,
      this.minPurchaseQty});

  int? id;
  String? name;
  String? addedBy;
  String? categoryName;
  int? sellerId;
  int? shopId;
  String? shopName;
  String? shopLogo;
  List<Photo>? photos;
  String? thumbnailImage;
  List<String>? tags;
  String? priceHighLow;
  List<ChoiceOption>? choiceOptions;
  List<String>? colors;
  bool? hasDiscount;
  String? strokedPrice;
  String? mainPrice;
  // ignore: prefer_typing_uninitialized_variables
  var calculablePrice;
  String? currencySymbol;
  int? currentStock;
  String? unit;
  int? rating;
  int? ratingCount;
  int? earnPoint;
  String? description;
  String? videoLink;
  String? link;
  Brand? brand;
  String? location;
  String? privacyPolicy;
  String? instagramPage;
  bool? cashOnDelivery;
  String? websiteLink;
  String? stockVisibility;
  int? minPurchaseQty;

  factory DetailedProduct.fromJson(Map<String, dynamic> json) =>
      DetailedProduct(
          id: json["id"],
          name: json["name"],
          addedBy: json["added_by"],
          categoryName: json["category_name"],
          sellerId: json["seller_id"],
          shopId: json["shop_id"],
          shopName: json["shop_name"],
          shopLogo: BaseApiService.imagesRoute + json["shop_logo"],
          photos:
              List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
          thumbnailImage: BaseApiService.imagesRoute + json["thumbnail_image"],
          tags: List<String>.from(json["tags"].map((x) => x)),
          priceHighLow: json["price_high_low"],
          choiceOptions: List<ChoiceOption>.from(
              json["choice_options"]?.map((x) => ChoiceOption.fromJson(x))),
          colors: json["colors"] == null
              ? []
              : List<String>.from(json["colors"].map((x) => x)),
          hasDiscount: json["has_discount"],
          strokedPrice: json["stroked_price"],
          mainPrice: json["main_price"],
          calculablePrice: json["calculable_price"],
          currencySymbol: json["currency_symbol"],
          currentStock: json["current_stock"],
          unit: json["unit"],
          rating: json["rating"].toInt(),
          ratingCount: json["rating_count"],
          earnPoint: json["earn_point"].toInt(),
          description: json["description"] == null || json["description"] == ""
              ? MyApp.context.resources.strings.noDescription
              : json['description'],
          videoLink: json["video_link"],
          link: json["link"],
          brand: Brand.fromJson(json["brand"]),
          location: json["location"],
          privacyPolicy: json["privacy_policy"],
          instagramPage: json["instagram_page"],
          cashOnDelivery: (json["cash_on_delivery"] == 1) ? true : false,
          websiteLink: json["website_link"],
          stockVisibility: json["stock_visibility_state"],
          minPurchaseQty: json["min_purchase_qty"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "added_by": addedBy,
        "seller_id": sellerId,
        "shop_id": shopId,
        "shop_name": shopName,
        "shop_logo": shopLogo,
        "photos": List<dynamic>.from(photos!.map((x) => x.toJson())),
        "thumbnail_image": thumbnailImage,
        "tags": List<dynamic>.from(tags!.map((x) => x)),
        "price_high_low": priceHighLow,
        "choice_options":
            List<dynamic>.from(choiceOptions!.map((x) => x.toJson())),
        "colors": List<dynamic>.from(colors!.map((x) => x)),
        "has_discount": hasDiscount,
        "stroked_price": strokedPrice,
        "main_price": mainPrice,
        "calculable_price": calculablePrice,
        "currency_symbol": currencySymbol,
        "current_stock": currentStock,
        "unit": unit,
        "rating": rating,
        "rating_count": ratingCount,
        "earn_point": earnPoint,
        "description": description,
        "video_link": videoLink,
        "link": link,
        "brand": brand!.toJson(),
        "stock_visibility_state": stockVisibility,
        "min_purchase_qty": minPurchaseQty
      };
}

class Brand {
  Brand({
    required this.id,
    required this.name,
    required this.logo,
  });

  int id;
  String name;
  String logo;

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
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

class Photo {
  Photo({
    required this.variant,
    required this.path,
  });

  String variant;
  String path;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        variant: json["variant"],
        path: BaseApiService.imagesRoute + json["path"],
      );

  Map<String, dynamic> toJson() => {
        "variant": variant,
        "path": path,
      };
}

class ChoiceOption {
  ChoiceOption({
    required this.name,
    required this.title,
    required this.options,
  });

  String name;
  String title;
  List<String> options;

  factory ChoiceOption.fromJson(Map<String, dynamic> json) => ChoiceOption(
        name: json["name"],
        title: json["title"],
        options: List<String>.from(json["options"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "title": title,
        "options": List<dynamic>.from(options.map((x) => x)),
      };
}
