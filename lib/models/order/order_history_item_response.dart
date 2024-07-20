// To parse this JSON data, do
//
//     final orderItemlResponse = orderItemlResponseFromJson(jsonString);
//https://app.quicktype.io/
import 'dart:convert';

OrderItemResponse orderItemlResponseFromJson(String str) =>
    OrderItemResponse.fromJson(json.decode(str));

String orderItemlResponseToJson(OrderItemResponse data) =>
    json.encode(data.toJson());

class OrderItemResponse {
  OrderItemResponse({
    required this.orderedItems,
    required this.success,
    required this.status,
  });

  List<OrderItem> orderedItems;
  bool success;
  int status;

  factory OrderItemResponse.fromJson(Map<String, dynamic> json) =>
      OrderItemResponse(
        orderedItems: List<OrderItem>.from(
            json["data"].map((x) => OrderItem.fromJson(x))),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(orderedItems.map((x) => x.toJson())),
        "success": success,
        "status": status,
      };
}

class OrderItem {
  OrderItem(
      {required this.id,
      required this.productId,
      required this.productName,
      this.variation,
      required this.price,
      required this.tax,
      required this.shippingCost,
      required this.couponDiscount,
      required this.quantity,
      required this.paymentStatus,
      required this.paymentStatusString,
      required this.deliveryStatus,
      required this.deliveryStatusString,
      required this.refundSection,
      required this.refundButton,
      required this.refundLabel,
      required this.refundRequestStatus});

  int id;
  int productId;
  String productName;
  String? variation;
  String price;
  String tax;
  String shippingCost;
  String couponDiscount;
  int quantity;
  String paymentStatus;
  String paymentStatusString;
  String deliveryStatus;
  String deliveryStatusString;
  bool refundSection;
  bool refundButton;
  String refundLabel;
  int refundRequestStatus;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json["id"],
        productId: json["product_id"],
        productName: json["product_name"],
        variation: json["variation"],
        price: json["price"],
        tax: json["tax"],
        shippingCost: json["shipping_cost"],
        couponDiscount: json["coupon_discount"],
        quantity: json["quantity"],
        paymentStatus: json["payment_status"],
        paymentStatusString: json["payment_status_string"],
        deliveryStatus: json["delivery_status"],
        deliveryStatusString: json["delivery_status_string"],
        refundSection: json["refund_section"],
        refundButton: json["refund_button"],
        refundLabel: json["refund_label"],
        refundRequestStatus: json["refund_request_status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "product_name": productName,
        "variation": variation,
        "price": price,
        "tax": tax,
        "shipping_cost": shippingCost,
        "coupon_discount": couponDiscount,
        "quantity": quantity,
        "payment_status": paymentStatus,
        "payment_status_string": paymentStatusString,
        "delivery_status": deliveryStatus,
        "delivery_status_string": deliveryStatusString,
        "refund_section": refundSection,
        "refund_button": refundButton,
        "refund_label": refundLabel,
        "refund_request_status": refundRequestStatus,
      };
}
