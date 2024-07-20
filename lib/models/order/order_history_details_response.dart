import 'dart:convert';

import '../general/links.dart';

OrderDetailResponse orderDetailResponseFromJson(String str) =>
    OrderDetailResponse.fromJson(json.decode(str));

String orderDetailResponseToJson(OrderDetailResponse data) =>
    json.encode(data.toJson());

class OrderDetailResponse {
  OrderDetailResponse({
    this.detailedOrders,
    this.success,
    this.status,
  });

  List<DetailedOrder>? detailedOrders;
  bool? success;
  int? status;

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) =>
      OrderDetailResponse(
        detailedOrders: List<DetailedOrder>.from(
            json["data"].map((x) => DetailedOrder.fromJson(x))),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(detailedOrders!.map((x) => x.toJson())),
        "success": success,
        "status": status,
      };
}

class DetailedOrder {
  DetailedOrder(
      {this.id,
      this.code,
      this.userId,
      this.manuallyPayable,
      this.shippingAddress,
      // this.shipping_type,
      this.shippingTypeString,
      this.paymentType,
      this.paymentStatus,
      this.paymentStatusString,
      this.deliveryStatus,
      this.deliveryStatusString,
      this.grandTotal,
      this.couponDiscount,
      this.shippingCost,
      this.subtotal,
      this.tax,
      this.date,
      this.links,
      this.combinedOrderId,
      this.note,
      this.deliveryMethod,
      this.deliveryMethodPrice,
      this.deliveryDate});

  int? id;
  String? code;
  int? userId;
  bool? manuallyPayable;
  ShippingAddress? shippingAddress;
  // String? shipping_type;
  String? shippingTypeString;
  String? paymentType;
  String? paymentStatus;
  String? paymentStatusString;
  String? deliveryStatus;
  String? deliveryStatusString;
  String? grandTotal;
  String? couponDiscount;
  String? shippingCost;
  String? subtotal;
  String? tax;
  String? date;
  Links? links;
  int? combinedOrderId;
  String? note;
  String? deliveryMethod;
  String? deliveryMethodPrice;
  String? deliveryDate;

  factory DetailedOrder.fromJson(Map<String, dynamic> json) => DetailedOrder(
      id: json["id"],
      code: json["code"],
      userId: json["user_id"],
      manuallyPayable: json["manually_payable"],
      shippingAddress: ShippingAddress.fromJson(json["shipping_address"]),
      // shipping_type: json["shipping_type"],
      shippingTypeString: json["shipping_type_string"],
      paymentType: json["payment_type"],
      paymentStatus: json["payment_status"],
      paymentStatusString: json["payment_status_string"],
      deliveryStatus: json["delivery_status"],
      deliveryStatusString: json["delivery_status_string"],
      grandTotal: json["grand_total"],
      couponDiscount: json["coupon_discount"],
      shippingCost: json["shipping_cost"],
      subtotal: json["subtotal"],
      tax: json["tax"],
      date: json["date"],
      links: Links.fromJson(json["links"]),
      note: json["note"],
      combinedOrderId: json["combined_order_id"],
      deliveryMethod: json["delivery_method"],
      deliveryMethodPrice: json["delivery_method_price"],
      deliveryDate: json["delivery_date"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "user_id": userId,
        "manually_payable": manuallyPayable,
        "shipping_address": shippingAddress?.toJson(),
        // "shipping_type": shipping_type,
        "shipping_type_string": shippingTypeString,
        "payment_type": paymentType,
        "payment_status": paymentStatus,
        "payment_status_string": paymentStatusString,
        "delivery_status": deliveryStatus,
        "delivery_status_string": deliveryStatusString,
        "grand_total": grandTotal,
        "coupon_discount": couponDiscount,
        "shipping_cost": shippingCost,
        "subtotal": subtotal,
        "tax": tax,
        "date": date,
        "links": links?.toJson(),
        "combined_order_id": combinedOrderId,
        "note": note,
        "delivery_method": deliveryMethod,
        "delivery_method_price": deliveryMethodPrice,
        "delivery_date": deliveryDate
      };
}

class ShippingAddress {
  ShippingAddress({
    this.name,
    this.email,
    this.address,
    this.country,
    this.state,
    this.city,
    this.postalCode,
    this.phone,
    this.checkoutType,
  });

  String? name;
  String? email;
  String? address;
  String? country;
  String? state;
  String? city;
  String? postalCode;
  String? phone;
  String? checkoutType;

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      ShippingAddress(
        name: json["name"],
        email: json["email"],
        address: json["address"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        postalCode: json["postal_code"],
        phone: json["phone"],
        checkoutType: json["checkout_type"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "address": address,
        "country": country,
        "state": state,
        "city": city,
        "postal_code": postalCode,
        "phone": phone,
        "checkout_type": checkoutType,
      };
}
