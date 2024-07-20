import 'dart:convert';

WishListChekResponse wishListChekResponseFromJson(String str) =>
    WishListChekResponse.fromJson(json.decode(str));

String wishListChekResponseToJson(WishListChekResponse data) =>
    json.encode(data.toJson());

class WishListChekResponse {
  WishListChekResponse({
    this.message,
    this.isInWishList,
    this.productId,
    this.wishListId,
  });

  String? message;
  bool? isInWishList;
  int? productId;
  int? wishListId;

  factory WishListChekResponse.fromJson(Map<String, dynamic> json) =>
      WishListChekResponse(
        message: json["message"],
        isInWishList: json["is_in_wishlist"],
        productId: json["product_id"],
        wishListId: json["wishlist_id"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "is_in_wishlist": isInWishList,
        "product_id": productId,
        "wishlist_id": wishListId,
      };
}
