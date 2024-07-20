import 'dart:convert';

import '../general/meta.dart';

OrderMiniResponse orderMiniResponseFromJson(String str) =>
    OrderMiniResponse.fromJson(json.decode(str));

String orderMiniResponseToJson(OrderMiniResponse data) =>
    json.encode(data.toJson());

class OrderMiniResponse {
  OrderMiniResponse({
    required this.orders,
    this.links,
    this.meta,
    this.success,
    this.status,
  });

  List<Order> orders;
  OrderMiniResponseLinks? links;
  Meta? meta;
  bool? success;
  int? status;

  factory OrderMiniResponse.fromJson(Map<String, dynamic> json) =>
      OrderMiniResponse(
        orders: List<Order>.from(json["data"].map((x) => Order.fromJson(x))),
        links: OrderMiniResponseLinks.fromJson(json["links"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(orders.map((x) => x.toJson())),
        "links": links!.toJson(),
        "meta": meta == null ? null : meta!.toJson(),
        "success": success,
        "status": status,
      };
}

class Order {
  Order({
    required this.id,
    required this.code,
    required this.userId,
    required this.paymentType,
    required this.paymentStatus,
    required this.paymentStatusString,
    required this.deliveryStatus,
    required this.deliveryStatusString,
    required this.grandTotal,
    required this.date,
    required this.links,
  });

  int id;
  String code;
  int userId;
  String paymentType;
  String paymentStatus;
  String paymentStatusString;
  String deliveryStatus;
  String deliveryStatusString;
  String grandTotal;
  String date;
  OrderLinks links;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        code: json["code"],
        userId: json["user_id"],
        paymentType: json["payment_type"],
        paymentStatus: json["payment_status"],
        paymentStatusString: json["payment_status_string"],
        deliveryStatus: json["delivery_status"],
        deliveryStatusString: json["delivery_status_string"],
        grandTotal: json["grand_total"],
        date: json["date"],
        links: OrderLinks.fromJson(json["links"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "user_id": userId,
        "payment_type": paymentType,
        "payment_status": paymentStatus,
        "payment_status_string": paymentStatusString,
        "delivery_status": deliveryStatus,
        "delivery_status_string": deliveryStatusString,
        "grand_total": grandTotal,
        "date": date,
        "links": links.toJson(),
      };
}

class OrderLinks {
  OrderLinks({
    required this.details,
  });

  String details;

  factory OrderLinks.fromJson(Map<String, dynamic> json) => OrderLinks(
        details: json["details"],
      );

  Map<String, dynamic> toJson() => {
        "details": details,
      };
}

class OrderMiniResponseLinks {
  OrderMiniResponseLinks({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  dynamic first;
  dynamic last;
  dynamic prev;
  dynamic next;

  factory OrderMiniResponseLinks.fromJson(Map<String, dynamic> json) =>
      OrderMiniResponseLinks(
        first: json["first"],
        last: json["last"],
        prev: json["prev"],
        next: json["next"],
      );

  Map<String, dynamic> toJson() => {
        "first": first,
        "last": last,
        "prev": prev,
        "next": next,
      };
}
