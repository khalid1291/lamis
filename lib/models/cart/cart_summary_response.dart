import 'dart:convert';

CartSummaryResponse cartSummaryResponseFromJson(String str) =>
    CartSummaryResponse.fromJson(json.decode(str));

String cartSummaryResponseToJson(CartSummaryResponse data) =>
    json.encode(data.toJson());

class CartSummaryResponse {
  CartSummaryResponse(
      {this.subTotal,
      this.tax,
      this.shippingCost,
      this.discount,
      this.grandTotal,
      this.grandTotalValue,
      this.couponCode,
      required this.couponApplied,
      this.balance,
      this.deliveryPrice,
      this.balanceString});

  String? subTotal;
  String? tax;
  String? shippingCost;
  String? discount;
  String? grandTotal;
  double? grandTotalValue;
  String? couponCode;
  bool couponApplied;
  double? balance;
  String? balanceString;
  String? deliveryPrice;

  factory CartSummaryResponse.fromJson(Map<String, dynamic> json) =>
      CartSummaryResponse(
        subTotal: json["sub_total"],
        tax: json["tax"],
        shippingCost: json["shipping_cost"],
        discount: json["discount"],
        grandTotal: json["grand_total"],
        grandTotalValue: double.parse(json["grand_total_value"].toString()),
        couponCode: json["coupon_code"],
        couponApplied: json["coupon_applied"],
        balance: json["balance"].toDouble(),
        balanceString: json["balance_String"],
        deliveryPrice: json["delivery_price"],
      );

  Map<String, dynamic> toJson() => {
        "sub_total": subTotal,
        "tax": tax,
        "shipping_cost": shippingCost,
        "discount": discount,
        "grand_total": grandTotal,
        "grand_total_value": grandTotalValue,
        "coupon_code": couponCode,
        "coupon_applied": couponApplied,
        "balance": balance,
        "balance_String": balanceString,
        "delivery_price": deliveryPrice
      };
}
