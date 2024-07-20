import 'dart:convert';

OrderCreateResponse orderCreateResponseFromJson(String str) =>
    OrderCreateResponse.fromJson(json.decode(str));

String orderCreateResponseToJson(OrderCreateResponse data) =>
    json.encode(data.toJson());

class OrderCreateResponse {
  OrderCreateResponse({
    this.combinedOrderId,
    this.result,
    this.message,
  });

  int? combinedOrderId;
  bool? result;
  String? message;

  factory OrderCreateResponse.fromJson(Map<String, dynamic> json) =>
      OrderCreateResponse(
        combinedOrderId: json["combined_order_id"],
        result: json["result"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "combined_order_id": combinedOrderId,
        "result": result,
        "message": message,
      };
}
